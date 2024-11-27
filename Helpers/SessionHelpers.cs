using Connect.Agro.Models.Domain;
using Connect.Agro.Web.Interfaces;
using Newtonsoft.Json;
using System.Text.Json.Serialization;

namespace Connect.Agro.Web.Helpers;

public class SessionHelpers : ISessionHelper
{
    private readonly IHttpContextAccessor _contextAccessor;

    public SessionHelpers(IHttpContextAccessor contextAccessor)
    {
        _contextAccessor = contextAccessor;
    }

    public void CreateSession(User user)
    {
        _contextAccessor.HttpContext.Session.SetString("LoggedUserSession", JsonConvert.SerializeObject(user));
    }

    public void DeleteSession()
    {
        _contextAccessor.HttpContext.Session.Remove("LoggedUserSession");
    }

    public User? SearchSession()
    {
        var userJson = _contextAccessor.HttpContext.Session.GetString("LoggedUserSession");

        if (userJson == null)
            return null;

        return JsonConvert.DeserializeObject<User?>(userJson);
    }
}
