using System;
using System.Linq;
using System.Threading.Tasks;
using Abp.Application.Services;
using Abp.Auditing;
using Abp.Authorization;
using Abp.Domain.Uow;
using Abp.UI;
using MyCompany.MyProject.Authorization;

namespace MyCompany.MyProject.Toeic;

// Only explicit MVC/API routes expose this service; never expose entity graphs through dynamic APIs.
[RemoteService(false)]
public class ReadingService : MyProjectAppServiceBase
{
    private readonly IReadingStore _store;
    private readonly TaggedWordParser _parser;
    public ReadingService(IReadingStore store,TaggedWordParser parser) { _store=store; _parser=parser; }
    [AbpAllowAnonymous]
    public async Task<object> List() => (await _store.List()).Select(e=>new {e.Id,e.Name,e.DurationMinutes,e.TotalQuestions,e.AnswerStatus}).ToArray();
    [AbpAllowAnonymous]
    [UnitOfWork]
    public async Task<int> Import(byte[] bytes)
    {
        var exam=_parser.Parse(bytes); // All validation precedes any write; images stay in SQL transaction.
        await _store.Lock("reading-import:"+exam.SourceHash);
        if((await _store.List()).Any(e=>e.SourceHash==exam.SourceHash)) throw new UserFriendlyException("File này đã được import.");
        await _store.Add(exam); await _store.Save(); return exam.Id;
    }
    [AbpAllowAnonymous]
    public async Task<object> Preview(int id) => Project(await GetExam(id),true);
    [AbpAllowAnonymous]
    public Task<ReadingDocument> DocumentImage(int id) => _store.DocumentImage(id);
    [AbpAllowAnonymous]
    public object PreviewFile(byte[] bytes) => Project(_parser.Parse(bytes),true);
    [AbpAllowAnonymous]
    [UnitOfWork]
    public async Task EditQuestion(int id,QuestionEdit input)
    {
        await _store.Lock("reading-exam:"+id); await Editable(id);
        var e=await GetExam(id,true); var q=e.Parts.SelectMany(p=>p.Questions).SingleOrDefault(q=>q.Number==input.Number);
        if(q==null || string.IsNullOrWhiteSpace(input.Text) || input.Options==null || input.Options.Length!=4 || input.Options.Any(string.IsNullOrWhiteSpace) || !new[]{"A","B","C","D"}.Contains(input.Answer) || !new[]{"proposed","verified"}.Contains(input.Status)) throw new UserFriendlyException("Nội dung câu hỏi hoặc đáp án không hợp lệ.");
        q.Text=input.Text; q.CorrectAnswer=input.Answer; q.AnswerStatus=input.Status;
        for(var i=0;i<4;i++) q.Choices.Single(c=>c.Letter=="ABCD"[i].ToString()).Text=input.Options[i];
        e.AnswerStatus=e.Parts.SelectMany(p=>p.Questions).All(q=>q.AnswerStatus=="verified")?"verified":"proposed";
        await _store.Save();
    }
    [AbpAllowAnonymous]
    [UnitOfWork]
    public async Task EditDocument(int id,DocumentEdit input)
    {
        await _store.Lock("reading-exam:"+id); await Editable(id);
        var e=await GetExam(id,true); var doc=e.Parts.SelectMany(p=>p.Groups).SelectMany(g=>g.Documents).SingleOrDefault(d=>d.Id==input.Id);
        if(doc==null || string.IsNullOrWhiteSpace(input.Text)) throw new UserFriendlyException("Nội dung tài liệu không hợp lệ.");
        var p=e.Parts.Single(p=>p.Groups.Any(g=>g.Id==doc.GroupId));
        if(p.Number==6)
        {
            var old=System.Text.RegularExpressions.Regex.Matches(doc.Text,@"\{\{\d+\}\}").Select(m=>m.Value).OrderBy(x=>x);
            var updated=System.Text.RegularExpressions.Regex.Matches(input.Text,@"\{\{\d+\}\}").Select(m=>m.Value).OrderBy(x=>x);
            if(!old.SequenceEqual(updated)) throw new UserFriendlyException("Không được thay đổi chỗ trống Part 6.");
        }
        if(input.ImageBase64!=null) { var bytes=Convert.FromBase64String(input.ImageBase64); TaggedWordParser.ValidateImage(bytes); doc.Image=bytes; doc.ImageMime=bytes[0]==137?"image/png":"image/jpeg"; }
        if(input.RemoveImage) { doc.Image=null; doc.ImageMime=null; }
        if(doc.Text!=input.Text) doc.TextWasEdited=true;
        if(input.ImageBase64!=null) doc.TextWasEdited=false;
        doc.Text=input.Text; await _store.Save();
    }
    private async Task Editable(int id) { if(await _store.HasAttempts(id)) throw new UserFriendlyException("Đề đã có lượt thi. Import bản mới để bảo toàn kết quả cũ."); }
    [AbpAllowAnonymous,DisableAuditing]
    [UnitOfWork]
    public async Task<object> Start(int id,string sessionKey)
    {
        var hash=ReadingSession.Hash(sessionKey); await _store.Lock("reading-exam:"+id); await _store.Lock("reading-start:"+hash+":"+id);
        var e=await GetExam(id); var a=await _store.Active(id,hash);
        if(a!=null && a.Deadline<=DateTime.UtcNow) { ReadingScoring.Submit(a,e.Parts.SelectMany(p=>p.Questions),DateTime.UtcNow); await _store.Save(); a=null; }
        if(a==null) { var now=DateTime.UtcNow; a=new ReadingAttempt{Id=Guid.NewGuid(),ExamId=id,GuestKeyHash=hash,StartedAt=now,Deadline=now.AddMinutes(e.DurationMinutes)}; await _store.AddAttempt(a); await _store.Save(); }
        return State(a,e);
    }
    [AbpAllowAnonymous,DisableAuditing]
    [UnitOfWork]
    public async Task<object> Progress(Guid id,string sessionKey)
    {
        var a=await Owned(id,sessionKey); var e=await GetExam(a.ExamId); Expire(a,e); await _store.Save(); return State(a,e);
    }
    [AbpAllowAnonymous,DisableAuditing]
    [UnitOfWork]
    public async Task<object> Answer(Guid id,AnswerEdit input,string sessionKey)
    {
        var a=await Owned(id,sessionKey); var e=await GetExam(a.ExamId); Expire(a,e);
        // Expired requests commit finalization without accepting their answer.
        if(a.Status!="inProgress") { await _store.Save(); return State(a,e); }
        if(input.Letter!=null && !new[]{"A","B","C","D"}.Contains(input.Letter)) throw new UserFriendlyException("Chọn A, B, C, D hoặc hủy.");
        var q=e.Parts.SelectMany(p=>p.Questions).SingleOrDefault(q=>q.Number==input.Number) ?? throw new UserFriendlyException("Số câu không hợp lệ.");
        var previous=a.Answers.SingleOrDefault(x=>x.QuestionId==q.Id);
        if(previous!=null && input.Letter==null) { a.Answers.Remove(previous); _store.RemoveAnswer(previous); }
        else if(previous!=null) previous.Letter=input.Letter;
        else if(input.Letter!=null) a.Answers.Add(new ReadingAnswer{AttemptId=a.Id,QuestionId=q.Id,Letter=input.Letter});
        await _store.Save(); return State(a,e);
    }
    [AbpAllowAnonymous,DisableAuditing]
    [UnitOfWork]
    public async Task<object> Submit(Guid id,string sessionKey)
    {
        var a=await Owned(id,sessionKey); var e=await GetExam(a.ExamId); ReadingScoring.Submit(a,e.Parts.SelectMany(p=>p.Questions),DateTime.UtcNow); await _store.Save(); return State(a,e);
    }
    [AbpAllowAnonymous,DisableAuditing]
    [UnitOfWork]
    public async Task<object> Result(Guid id,string sessionKey)
    {
        var a=await Owned(id,sessionKey); var e=await GetExam(a.ExamId); Expire(a,e); await _store.Save();
        if(a.Status=="inProgress") throw new UserFriendlyException("Chưa nộp bài.");
        return new {Summary=State(a,e),Review=e.Parts.SelectMany(p=>p.Questions).Select(q=>new {q.Number,q.CorrectAnswer,q.AnswerStatus,Selected=a.Answers.SingleOrDefault(x=>x.QuestionId==q.Id)?.Letter}).ToArray()};
    }
    private async Task<ReadingAttempt> Owned(Guid id,string sessionKey)
    {
        await _store.Lock("reading-attempt:"+id); var a=await _store.Attempt(id);
        if(a==null || !ReadingSession.Matches(sessionKey,a.GuestKeyHash)) throw new AbpAuthorizationException("Không có quyền xem lượt thi."); return a;
    }
    private async Task<ReadingExam> GetExam(int id,bool includeImages=false) => await _store.Exam(id,includeImages) ?? throw new UserFriendlyException("Không tìm thấy đề.");
    private static void Expire(ReadingAttempt a,ReadingExam e) { if(DateTime.UtcNow>=a.Deadline) ReadingScoring.Submit(a,e.Parts.SelectMany(p=>p.Questions),DateTime.UtcNow); }
    private static object State(ReadingAttempt a,ReadingExam e) => new {a.Id,a.ExamId,a.StartedAt,a.Deadline,a.SubmittedAt,a.Status,a.Correct,a.Wrong,a.Skipped,ServerNow=DateTime.UtcNow,Answered=a.Answers.Count,Answers=a.Answers.Select(x=>new {Number=e.Parts.SelectMany(p=>p.Questions).Single(q=>q.Id==x.QuestionId).Number,x.Letter}).ToArray(),Exam=Project(e,false)};
    private static object Project(ReadingExam e,bool admin) => new {e.Id,e.Name,e.DurationMinutes,e.TotalQuestions,e.AnswerStatus,Parts=e.Parts.OrderBy(p=>p.Number).Select(p=>new {p.Number,Groups=p.Groups.Select(g=>new {g.Id,g.Key,Documents=g.Documents.OrderBy(d=>d.Order).Select(d=>new {d.Id,d.Order,d.Text,d.TextWasEdited,Image=d.Image==null?null:Convert.ToBase64String(d.Image),d.ImageMime,ImageUrl=(d.HasImage || d.Image!=null) && d.Id>0 ? "/api/reading/documents/"+d.Id+"/image" : null}).ToArray()}).ToArray(),Questions=p.Questions.OrderBy(q=>q.Number).Select(q=>admin?(object)new {q.Number,q.Text,q.GroupId,q.CorrectAnswer,q.AnswerStatus,Options=q.Choices.OrderBy(c=>c.Letter).Select(c=>new {c.Letter,c.Text}).ToArray()}:new {q.Number,q.Text,q.GroupId,Options=q.Choices.OrderBy(c=>c.Letter).Select(c=>new {c.Letter,c.Text}).ToArray()}).ToArray()}).ToArray()};
}
public class QuestionEdit { public int Number {get;set;} public string Text {get;set;} public string[] Options {get;set;} public string Answer {get;set;} public string Status {get;set;} }
public class DocumentEdit { public int Id {get;set;} public string Text {get;set;} public string ImageBase64 {get;set;} public bool RemoveImage {get;set;} }
public class AnswerEdit { public int Number {get;set;} public string Letter {get;set;} }
