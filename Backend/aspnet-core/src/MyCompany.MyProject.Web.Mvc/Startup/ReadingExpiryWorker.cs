using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Abp.Domain.Uow;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using MyCompany.MyProject.Toeic;

namespace MyCompany.MyProject.Web.Startup;
public class ReadingExpiryWorker : BackgroundService
{
    private readonly IServiceScopeFactory _scopes;
    private readonly ILogger<ReadingExpiryWorker> _log;
    public ReadingExpiryWorker(IServiceScopeFactory scopes,ILogger<ReadingExpiryWorker> log) { _scopes=scopes; _log=log; }
    protected override async Task ExecuteAsync(CancellationToken token)
    {
        using var timer=new PeriodicTimer(TimeSpan.FromSeconds(15));
        while(await timer.WaitForNextTickAsync(token))
        {
            try {
                using var scope=_scopes.CreateScope();
                var manager=scope.ServiceProvider.GetRequiredService<IUnitOfWorkManager>();
                var store=scope.ServiceProvider.GetRequiredService<IReadingStore>();
                using var uow=manager.Begin();
                foreach(var id in await store.Expired(DateTime.UtcNow)) {
                    await store.Lock("reading-attempt:"+id);
                    var a=await store.Attempt(id);
                    if(a.Status=="inProgress" && a.Deadline<=DateTime.UtcNow) { var e=await store.Exam(a.ExamId); ReadingScoring.Submit(a,e.Parts.SelectMany(p=>p.Questions),DateTime.UtcNow); }
                }
                await uow.CompleteAsync();
            } catch(Exception) { _log.LogWarning("Reading expiry worker could not access SQL; it will retry. Requests still enforce the server deadline."); }
        }
    }
}
