using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MyCompany.MyProject.Controllers;

namespace MyCompany.MyProject.Web.Controllers;

[AllowAnonymous]
public class StudioController : MyProjectControllerBase
{
    public IActionResult Index() => View();
}
