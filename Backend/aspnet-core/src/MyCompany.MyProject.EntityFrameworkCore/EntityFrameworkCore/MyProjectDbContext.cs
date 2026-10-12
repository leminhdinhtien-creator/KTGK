using Abp.Zero.EntityFrameworkCore;
using MyCompany.MyProject.Authorization.Roles;
using MyCompany.MyProject.Authorization.Users;
using MyCompany.MyProject.MultiTenancy;
using Microsoft.EntityFrameworkCore;
using MyCompany.MyProject.Toeic;

namespace MyCompany.MyProject.EntityFrameworkCore;

public class MyProjectDbContext : AbpZeroDbContext<Tenant, Role, User, MyProjectDbContext>
{
    /* Define a DbSet for each entity of the application */
    public DbSet<ReadingExam> ReadingExams { get; set; }
    public DbSet<ReadingPart> ReadingParts { get; set; }
    public DbSet<ReadingGroup> ReadingGroups { get; set; }
    public DbSet<ReadingDocument> ReadingDocuments { get; set; }
    public DbSet<ReadingQuestion> ReadingQuestions { get; set; }
    public DbSet<ReadingChoice> ReadingChoices { get; set; }
    public DbSet<ReadingAttempt> ReadingAttempts { get; set; }
    public DbSet<ReadingAnswer> ReadingAnswers { get; set; }

    protected override void OnModelCreating(ModelBuilder b)
    {
        base.OnModelCreating(b);
        b.Entity<ReadingExam>().ToTable("ReadingExams",t=>t.HasCheckConstraint("CK_ReadingExam", "[DurationMinutes]=75 AND [TotalQuestions]=100 AND [AnswerStatus] IN ('proposed','verified')"));
        b.Entity<ReadingExam>().HasIndex(e=>e.SourceHash).IsUnique();
        b.Entity<ReadingPart>().HasIndex(p=>new {p.ExamId,p.Number}).IsUnique();
        b.Entity<ReadingPart>().HasAlternateKey(p=>new {p.Id,p.ExamId});
        b.Entity<ReadingPart>().ToTable("ReadingParts",t=>t.HasCheckConstraint("CK_ReadingPart","[Number] IN (5,6,7)"));
        b.Entity<ReadingGroup>().HasIndex(g=>new {g.PartId,g.Key}).IsUnique();
        b.Entity<ReadingGroup>().HasAlternateKey(g=>new {g.Id,g.PartId});
        b.Entity<ReadingDocument>().HasIndex(d=>new {d.GroupId,d.Order}).IsUnique();
        b.Entity<ReadingQuestion>().HasIndex(q=>new {q.ExamId,q.Number}).IsUnique();
        b.Entity<ReadingQuestion>().HasOne(q=>q.Exam).WithMany().HasForeignKey(q=>q.ExamId).OnDelete(DeleteBehavior.Restrict);
        b.Entity<ReadingQuestion>().HasOne(q=>q.Part).WithMany(p=>p.Questions).HasForeignKey(q=>new {q.PartId,q.ExamId}).HasPrincipalKey(p=>new {p.Id,p.ExamId}).OnDelete(DeleteBehavior.Restrict);
        b.Entity<ReadingQuestion>().HasOne(q=>q.Group).WithMany().HasForeignKey(q=>new {q.GroupId,q.PartId}).HasPrincipalKey(g=>new {g.Id,g.PartId}).OnDelete(DeleteBehavior.Restrict);
        b.Entity<ReadingQuestion>().ToTable("ReadingQuestions",t=>t.HasCheckConstraint("CK_ReadingQuestion","[Number] BETWEEN 101 AND 200 AND [CorrectAnswer] IN ('A','B','C','D') AND [AnswerStatus] IN ('proposed','verified')"));
        b.Entity<ReadingChoice>().HasIndex(c=>new {c.QuestionId,c.Letter}).IsUnique();
        b.Entity<ReadingChoice>().ToTable("ReadingChoices",t=>t.HasCheckConstraint("CK_ReadingChoice","[Letter] IN ('A','B','C','D')"));
        b.Entity<ReadingAttempt>().HasOne(a=>a.Exam).WithMany().HasForeignKey(a=>a.ExamId).OnDelete(DeleteBehavior.Restrict);
        b.Entity<ReadingAttempt>().HasOne(a=>a.User).WithMany().HasForeignKey(a=>a.UserId).OnDelete(DeleteBehavior.Restrict);
        b.Entity<ReadingAttempt>().HasIndex(a=>new {a.UserId,a.ExamId,a.Status});
        b.Entity<ReadingAttempt>().HasIndex(a=>new {a.GuestKeyHash,a.ExamId,a.Status});
        b.Entity<ReadingAttempt>().HasIndex(a=>new {a.Status,a.Deadline});
        b.Entity<ReadingAnswer>().HasIndex(a=>new {a.AttemptId,a.QuestionId}).IsUnique();
        b.Entity<ReadingAnswer>().HasOne(a=>a.Question).WithMany().HasForeignKey(a=>a.QuestionId).OnDelete(DeleteBehavior.Restrict);
        b.Entity<ReadingAnswer>().ToTable("ReadingAnswers",t=>t.HasCheckConstraint("CK_ReadingAnswer","[Letter] IN ('A','B','C','D')"));
    }

    public MyProjectDbContext(DbContextOptions<MyProjectDbContext> options)
        : base(options)
    {
    }
}
