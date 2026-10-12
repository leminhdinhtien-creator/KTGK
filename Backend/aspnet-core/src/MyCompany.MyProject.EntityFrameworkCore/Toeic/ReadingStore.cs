using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Abp.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using MyCompany.MyProject.EntityFrameworkCore;

namespace MyCompany.MyProject.Toeic;
public class ReadingStore : IReadingStore
{
    private readonly IDbContextProvider<MyProjectDbContext> _provider;
    public ReadingStore(IDbContextProvider<MyProjectDbContext> provider) { _provider=provider; }
    private MyProjectDbContext Db => _provider.GetDbContext();
    public Task<List<ReadingExam>> List() => Db.ReadingExams.AsNoTracking().OrderByDescending(e=>e.Id).ToListAsync();
    public async Task<ReadingExam> Exam(int id, bool includeImages = true)
    {
        // Flat reads avoid Include's SQL sorts and large memory grants for nvarchar(max).
        // Editing keeps tracked entities; student reads never fetch image binaries.
        IQueryable<T> Read<T>(IQueryable<T> query) where T : class => includeImages ? query : query.AsNoTracking();
        var exam=await Read(Db.ReadingExams).SingleOrDefaultAsync(e=>e.Id==id);
        if(exam==null) return null;
        var parts=await Read(Db.ReadingParts).Where(p=>p.ExamId==id).ToListAsync();
        var partIds=parts.Select(p=>p.Id).ToArray();
        var groups=await Read(Db.ReadingGroups).Where(g=>partIds.Contains(g.PartId)).ToListAsync();
        var groupIds=groups.Select(g=>g.Id).ToArray();
        var questions=await Read(Db.ReadingQuestions).Where(q=>q.ExamId==id).ToListAsync();
        var questionIds=questions.Select(q=>q.Id).ToArray();
        var choices=await Read(Db.ReadingChoices).Where(c=>questionIds.Contains(c.QuestionId)).ToListAsync();
        List<ReadingDocument> docs;
        if(includeImages)
            docs=Db.ReadingDocuments.Where(d=>groupIds.Contains(d.GroupId)).ToList();
        else {
            var metadata=await Db.ReadingDocuments.AsNoTracking().Where(d=>groupIds.Contains(d.GroupId))
                .Select(d=>new {d.Id,d.GroupId,d.Order,d.Text,d.TextWasEdited,d.ImageMime,HasImage=d.Image!=null}).ToListAsync();
            docs=metadata.Select(d=>new ReadingDocument {Id=d.Id,GroupId=d.GroupId,Order=d.Order,Text=d.Text,TextWasEdited=d.TextWasEdited,ImageMime=d.ImageMime,HasImage=d.HasImage}).ToList();
        }
        exam.Parts=parts;
        foreach(var p in parts) {
            p.Groups=groups.Where(g=>g.PartId==p.Id).OrderBy(g=>g.Id).ToList();
            p.Questions=questions.Where(q=>q.PartId==p.Id).ToList();
        }
        foreach(var g in groups) g.Documents=docs.Where(d=>d.GroupId==g.Id).ToList();
        foreach(var q in questions) q.Choices=choices.Where(c=>c.QuestionId==q.Id).ToList();
        return exam;
    }
    public Task<ReadingDocument> DocumentImage(int id) => Task.FromResult(Db.ReadingDocuments.AsNoTracking().SingleOrDefault(d=>d.Id==id));
    public async Task Add(ReadingExam exam) { await Db.ReadingExams.AddAsync(exam); }
    public Task Save() => Db.SaveChangesAsync();
    public Task<bool> HasAttempts(int examId) => Db.ReadingAttempts.AnyAsync(a=>a.ExamId==examId);
    public async Task Lock(string resource)
    {
        // Transaction-owned database lock serializes save/submit/timeout across server processes.
        await Db.Database.ExecuteSqlInterpolatedAsync($@"DECLARE @r int; EXEC @r=sys.sp_getapplock @Resource={resource}, @LockMode='Exclusive', @LockOwner='Transaction', @LockTimeout=10000; IF @r < 0 THROW 51000, 'Cannot lock reading attempt', 1;");
    }
    public Task<ReadingAttempt> Attempt(Guid id) => Db.ReadingAttempts.Include(a=>a.Answers).SingleOrDefaultAsync(a=>a.Id==id);
    public Task<ReadingAttempt> Active(int examId,string guestKeyHash) => Db.ReadingAttempts.Include(a=>a.Answers).FirstOrDefaultAsync(a=>a.ExamId==examId && a.GuestKeyHash==guestKeyHash && a.Status=="inProgress");
    public async Task AddAttempt(ReadingAttempt attempt) { await Db.ReadingAttempts.AddAsync(attempt); }
    public void RemoveAnswer(ReadingAnswer answer) => Db.ReadingAnswers.Remove(answer);
    public Task<List<Guid>> Expired(DateTime now) => Db.ReadingAttempts.Where(a=>a.Status=="inProgress" && a.Deadline<=now).Select(a=>a.Id).ToListAsync();
}
