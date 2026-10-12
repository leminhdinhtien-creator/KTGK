using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using Abp.Domain.Entities;
using Abp.Dependency;
using System.Threading.Tasks;

namespace MyCompany.MyProject.Toeic;

public class ReadingExam : Entity
{
    [Required, MaxLength(200)] public string Name { get; set; }
    public int DurationMinutes { get; set; } = 75;
    public int TotalQuestions { get; set; } = 100;
    [Required, MaxLength(20)] public string AnswerStatus { get; set; } = "proposed";
    [Required, MaxLength(64)] public string SourceHash { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public List<ReadingPart> Parts { get; set; } = new();
}
public class ReadingPart : Entity
{
    public int ExamId { get; set; }
    public ReadingExam Exam { get; set; }
    public int Number { get; set; }
    public List<ReadingGroup> Groups { get; set; } = new();
    public List<ReadingQuestion> Questions { get; set; } = new();
}
public class ReadingGroup : Entity
{
    public int PartId { get; set; }
    public ReadingPart Part { get; set; }
    [Required, MaxLength(80)] public string Key { get; set; }
    public List<ReadingDocument> Documents { get; set; } = new();
}
public class ReadingDocument : Entity
{
    public int GroupId { get; set; }
    public ReadingGroup Group { get; set; }
    public int Order { get; set; }
    [Required] public string Text { get; set; }
    public bool TextWasEdited { get; set; }
    public byte[] Image { get; set; }
    [MaxLength(30)] public string ImageMime { get; set; }
}
public class ReadingQuestion : Entity
{
    public int ExamId { get; set; }
    public ReadingExam Exam { get; set; }
    public int PartId { get; set; }
    public ReadingPart Part { get; set; }
    public int? GroupId { get; set; }
    public ReadingGroup Group { get; set; }
    public int Number { get; set; }
    [Required] public string Text { get; set; }
    [Required, MaxLength(1)] public string CorrectAnswer { get; set; }
    [Required, MaxLength(20)] public string AnswerStatus { get; set; } = "proposed";
    public List<ReadingChoice> Choices { get; set; } = new();
}
public class ReadingChoice : Entity
{
    public int QuestionId { get; set; }
    public ReadingQuestion Question { get; set; }
    [Required, MaxLength(1)] public string Letter { get; set; }
    [Required] public string Text { get; set; }
}
public class ReadingAttempt : Entity<Guid>
{
    public int ExamId { get; set; }
    public ReadingExam Exam { get; set; }
    public long? UserId { get; set; }
    public MyCompany.MyProject.Authorization.Users.User User { get; set; }
    [MaxLength(64)] public string GuestKeyHash { get; set; }
    public DateTime StartedAt { get; set; }
    public DateTime Deadline { get; set; }
    public DateTime? SubmittedAt { get; set; }
    [Required, MaxLength(20)] public string Status { get; set; } = "inProgress";
    public int Correct { get; set; }
    public int Wrong { get; set; }
    public int Skipped { get; set; }
    public List<ReadingAnswer> Answers { get; set; } = new();
}
public class ReadingAnswer : Entity
{
    public Guid AttemptId { get; set; }
    public ReadingAttempt Attempt { get; set; }
    public int QuestionId { get; set; }
    public ReadingQuestion Question { get; set; }
    [Required, MaxLength(1)] public string Letter { get; set; }
}
public interface IReadingStore : ITransientDependency
{
    Task<List<ReadingExam>> List();
    Task<ReadingExam> Exam(int id);
    Task Add(ReadingExam exam);
    Task Save();
    Task<bool> HasAttempts(int examId);
    Task Lock(string resource);
    Task<ReadingAttempt> Attempt(Guid id);
    Task<ReadingAttempt> Active(int examId, string guestKeyHash);
    Task AddAttempt(ReadingAttempt attempt);
    void RemoveAnswer(ReadingAnswer answer);
    Task<List<Guid>> Expired(DateTime now);
}
public static class ReadingScoring
{
    public static void Submit(ReadingAttempt attempt, IEnumerable<ReadingQuestion> questions, DateTime now)
    {
        if (attempt.SubmittedAt.HasValue) return;
        attempt.Correct = attempt.Wrong = attempt.Skipped = 0;
        var answers = new Dictionary<int,string>();
        foreach (var a in attempt.Answers) answers.Add(a.QuestionId,a.Letter);
        foreach (var q in questions)
        {
            if (!answers.TryGetValue(q.Id,out var letter)) attempt.Skipped++;
            else if (letter == q.CorrectAnswer) attempt.Correct++;
            else attempt.Wrong++;
        }
        attempt.SubmittedAt = now >= attempt.Deadline ? attempt.Deadline : now;
        attempt.Status = now >= attempt.Deadline ? "expired" : "submitted";
    }
}
