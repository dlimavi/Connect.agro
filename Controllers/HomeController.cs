using Connect.Agro.Web.Filters;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;

namespace Connect.Agro.Web.Controllers;

[AuthenticatedUserFilter]
public class HomeController : Controller
{

    public IActionResult Index()
    {
        return View();
    }

    [Route("Home/Error")]
    public IActionResult Error()
    {
        var exceptionFeature = HttpContext.Features.Get<IExceptionHandlerFeature>();
        if (exceptionFeature != null)
        {
            var exception = exceptionFeature.Error;
            
            ViewData["ExceptionMessage"] = exception.Message;
        }

        return View("Error");
    }
}
