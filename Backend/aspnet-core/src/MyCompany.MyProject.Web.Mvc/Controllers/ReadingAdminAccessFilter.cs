using System.Net;
using System.Threading.Tasks;
using Abp.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using MyCompany.MyProject.Authorization;

namespace MyCompany.MyProject.Web.Controllers;

public class ReadingAdminAccessFilter : IAsyncAuthorizationFilter
{
    private readonly IWebHostEnvironment _environment;
    private readonly IConfiguration _configuration;
    private readonly IPermissionChecker _permissions;
    public ReadingAdminAccessFilter(IWebHostEnvironment environment, IConfiguration configuration, IPermissionChecker permissions)
    { _environment=environment; _configuration=configuration; _permissions=permissions; }

    public async Task OnAuthorizationAsync(AuthorizationFilterContext context)
    {
        var address=context.HttpContext.Connection.RemoteIpAddress;
        // Explicit local demo mode. Other machines/environments still require ReadingAdmin permission.
        if (_environment.IsDevelopment() && _configuration.GetValue<bool>("ReadingDemo:AllowAnonymousAdmin") &&
            address!=null && IPAddress.IsLoopback(address.IsIPv4MappedToIPv6 ? address.MapToIPv4() : address)) return;
        if (await _permissions.IsGrantedAsync(PermissionNames.Pages_ReadingAdmin)) return;
        context.Result=new UnauthorizedObjectResult(new { error=new { message="Admin cần quyền quản lý đề ngoài chế độ demo local." } });
    }
}
