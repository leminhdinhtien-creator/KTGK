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
    public Task<ReadingExam> Exam(int id) => Db.ReadingExams
        .Include(e=>e.Parts).ThenInclude(p=>p.Questions).ThenInclude(q=>q.Choices)
        .Include(e=>e.Parts).ThenInclude(p=>p.Groups).ThenInclude(g=>g.Documents)
        .AsSplitQuery().SingleOrDefaultAsync(e=>e.Id==id);
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
