using System;
using System.IO;
using System.Threading.Tasks;
using Abp.AspNetCore.Mvc.Authorization;
using Abp.Domain.Uow;
using Abp.UI;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MyCompany.MyProject.Authorization;
using MyCompany.MyProject.Toeic;
using MyCompany.MyProject.Controllers;

namespace MyCompany.MyProject.Web.Controllers;

[ServiceFilter(typeof(ReadingAdminAccessFilter))]
public class ReadingController : MyProjectControllerBase
{
    private readonly ReadingService _service;
    public ReadingController(ReadingService service) { _service=service; }
    public IActionResult Index() => View();
    [HttpGet] public Task<object> Exams() => _service.List();
    [HttpGet] public Task<object> Preview(int id) => _service.Preview(id);
    [HttpPost,RequestSizeLimit(26_000_000)]
    public async Task<object> PreviewFile(IFormFile file)
    {
        if(file==null || !file.FileName.EndsWith(".docx",StringComparison.OrdinalIgnoreCase) || file.Length>25_000_000) throw new UserFriendlyException("Chọn DOCX tối đa 25 MB.");
        using var ms=new MemoryStream(); await file.CopyToAsync(ms); return _service.PreviewFile(ms.ToArray());
    }
    [HttpPost,RequestSizeLimit(26_000_000),UnitOfWork]
    public async Task<object> Import(IFormFile file)
    {
        if(file==null || !file.FileName.EndsWith(".docx",StringComparison.OrdinalIgnoreCase) || file.Length>25_000_000) throw new UserFriendlyException("Chọn DOCX tối đa 25 MB.");
        using var ms=new MemoryStream(); await file.CopyToAsync(ms); return new {Id=await _service.Import(ms.ToArray())};
    }
    [HttpPost,UnitOfWork] public Task EditQuestion(int id,[FromBody] QuestionEdit input) => _service.EditQuestion(id,input);
    [HttpPost,UnitOfWork] public Task EditDocument(int id,[FromBody] DocumentEdit input) => _service.EditDocument(id,input);
}
[Route("api/reading"),Microsoft.AspNetCore.Authorization.AllowAnonymous,IgnoreAntiforgeryToken,Abp.Auditing.DisableAuditing]
public class ReadingApiController : MyProjectControllerBase
{
    private readonly ReadingService _service;
    public ReadingApiController(ReadingService service) { _service=service; }
    private string SessionKey => Request.Headers["X-Reading-Session"].ToString();
    [HttpGet("exams")] public Task<object> Exams() => _service.List();
    [HttpPost("exams/{id:int}/start"),UnitOfWork] public Task<object> Start(int id) => _service.Start(id,SessionKey);
    [HttpGet("attempts/{id:guid}"),UnitOfWork] public Task<object> Progress(Guid id) => _service.Progress(id,SessionKey);
    [HttpPut("attempts/{id:guid}/answer"),UnitOfWork] public Task<object> Answer(Guid id,[FromBody] AnswerEdit input) => _service.Answer(id,input,SessionKey);
    [HttpPost("attempts/{id:guid}/submit"),UnitOfWork] public Task<object> Submit(Guid id) => _service.Submit(id,SessionKey);
    [HttpGet("attempts/{id:guid}/result"),UnitOfWork] public Task<object> Result(Guid id) => _service.Result(id,SessionKey);
}
