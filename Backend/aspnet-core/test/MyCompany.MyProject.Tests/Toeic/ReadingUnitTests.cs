using System;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using Abp.UI;
using MyCompany.MyProject.Toeic;
using Xunit;

namespace MyCompany.MyProject.Tests.Toeic;
public class ReadingUnitTests
{
    private static byte[] Source() => File.ReadAllBytes(Path.Combine(AppContext.BaseDirectory,"TOEIC-Reading-Test10-Tagged.docx"));
    private static byte[] Change(Func<string,string> change)
    {
        using var ms=new MemoryStream();ms.Write(Source());
        using(var zip=new ZipArchive(ms,ZipArchiveMode.Update,true)) { var e=zip.GetEntry("word/document.xml");string xml;using(var r=new StreamReader(e.Open()))xml=r.ReadToEnd();e.Delete();using var w=new StreamWriter(zip.CreateEntry("word/document.xml").Open(),Encoding.UTF8);w.Write(change(xml)); }
        return ms.ToArray();
    }
    [Fact] public void RealWordPreservesAllQuestionsGroupsAndEmbeddedDocuments()
    {
        var e=new TaggedWordParser().Parse(Source());
        Assert.Equal(new[]{30,16,54},e.Parts.Select(p=>p.Questions.Count));
        Assert.Equal(Enumerable.Range(101,100),e.Parts.SelectMany(p=>p.Questions).Select(q=>q.Number));
        Assert.Equal(19,e.Parts.Sum(p=>p.Groups.Count));Assert.Equal(27,e.Parts.SelectMany(p=>p.Groups).Sum(g=>g.Documents.Count));
        Assert.All(e.Parts.SelectMany(p=>p.Questions),q=>Assert.Equal(new[]{"A","B","C","D"},q.Choices.Select(c=>c.Letter)));
        Assert.All(e.Parts.SelectMany(p=>p.Groups).SelectMany(g=>g.Documents),d=>Assert.NotEmpty(d.Image));
        Assert.Contains(e.Parts[2].Groups,g=>g.Documents.Count==3);Assert.Equal("proposed",e.AnswerStatus);
    }
    [Theory]
    [InlineData("number=&quot;101&quot;","number=&quot;102&quot;")]
    [InlineData("answer=&quot;B&quot;","answer=&quot;X&quot;")]
    [InlineData("minutes=&quot;75&quot;","minutes=&quot;74&quot;")]
    [InlineData("letter=&quot;A&quot;","letter=&quot;D&quot;")]
    [InlineData("&lt;/exam&gt;","")]
    [InlineData("&lt;blank number=&quot;131&quot;/&gt;","&lt;blank number=&quot;999&quot;/&gt;")]
    [InlineData("ref=&quot;embedded&quot;","ref=&quot;missing&quot;")]
    [InlineData("answerStatus=&quot;proposed&quot;","answerStatus=&quot;verified&quot;")]
    public void InvalidWordIsRejectedBeforePersistence(string from,string to)
    { Assert.Throws<UserFriendlyException>(()=>new TaggedWordParser().Parse(Change(s=>s.Replace(from.Replace("&quot;","\""),to.Replace("&quot;","\""))))); }
    [Theory][InlineData("Choose a word")][InlineData("132")]
    public void Part6StemMustMatchItsQuestionNumber(string stem)
    {
        Assert.Throws<UserFriendlyException>(()=>new TaggedWordParser().Parse(Change(s=>s.Replace("&lt;stem&gt;131&lt;/stem&gt;","&lt;stem&gt;"+stem+"&lt;/stem&gt;"))));
    }
    [Fact] public void NonDocxRejected() => Assert.Throws<UserFriendlyException>(()=>new TaggedWordParser().Parse(new byte[]{1,2,3}));
    [Theory][InlineData(0,0,0,100)][InlineData(20,10,20,70)][InlineData(100,0,100,0)]
    public void ScoreCountsAnsweredWrongAndSkipped(int correct,int wrong,int expectedCorrect,int skipped)
    {
        var q=Enumerable.Range(1,100).Select(i=>new ReadingQuestion{Id=i,CorrectAnswer="A"}).ToArray();
        var now=DateTime.UtcNow;var a=new ReadingAttempt{StartedAt=now,Deadline=now.AddMinutes(75)};
        for(var i=1;i<=correct+wrong;i++)a.Answers.Add(new ReadingAnswer{QuestionId=i,Letter=i<=correct?"A":"B"});
        ReadingScoring.Submit(a,q,now);Assert.Equal(expectedCorrect,a.Correct);Assert.Equal(wrong,a.Wrong);Assert.Equal(skipped,a.Skipped);Assert.Equal(100,a.Correct+a.Wrong+a.Skipped);
        a.Answers.Clear();ReadingScoring.Submit(a,q,now.AddMinutes(1));Assert.Equal(expectedCorrect,a.Correct);Assert.Equal("submitted",a.Status);
    }
    [Fact] public void ExpiryRecordsDeadlineAndIsIdempotent()
    { var now=DateTime.UtcNow;var a=new ReadingAttempt{Deadline=now.AddSeconds(-1)};ReadingScoring.Submit(a,Enumerable.Range(1,100).Select(i=>new ReadingQuestion{Id=i,CorrectAnswer="A"}),now);Assert.Equal("expired",a.Status);Assert.Equal(a.Deadline,a.SubmittedAt);Assert.Equal(100,a.Skipped); }
}
