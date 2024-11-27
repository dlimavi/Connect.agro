using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.IdentityModel.Tokens;

namespace Connect.Agro.Web.Filters;

public class AuthenticatedUserFilter : ActionFilterAttribute
{
    public override void OnActionExecuting(ActionExecutingContext context)
    {
        var loggedUser = context.HttpContext.Session.GetString("LoggedUserSession");
        if (loggedUser.IsNullOrEmpty())
        {
            var redirectToRouteResult = new RedirectToRouteResult(
                    new RouteValueDictionary 
                    {
                        { "controller", "Login" },
                        { "action", "Index" }
                    }
                );
            context.Result = redirectToRouteResult;
        }
        base.OnActionExecuting(context);
    }

}
