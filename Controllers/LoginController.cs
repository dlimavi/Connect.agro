using Connect.Agro.Models.Dtos;
using Connect.Agro.Models.Dtos.Responses;
using Connect.Agro.Services;
using Connect.Agro.Web.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace Connect.Agro.Web.Controllers;

public class LoginController : Controller
{
    private readonly ISessionHelper _sessionHelper;

    public LoginController(ISessionHelper sessionHelper)
    {
        _sessionHelper = sessionHelper;
    }

    public IActionResult Index()
    {
        var loggedUser = _sessionHelper.SearchSession();
        if (loggedUser is not null)
        {
            return RedirectToAction("Index", "Home");
        }
        return View();
    }

    [HttpPost]
    public async Task<IActionResult> Login(LoginRequestDto request)
    {
        if (ModelState.IsValid)
        {
            var userService = new UserService();
            LoginResponseDto response = await userService.Authenticate(request);

            if (response.Success)
            {
                _sessionHelper.CreateSession(response.LoggedUser);
                return RedirectToAction("Index", "Home");
            }

            TempData["ErrorMessage"] = "Usuário ou senha inválidos tente novamente!";
            return RedirectToAction("Index");
        }

        return View("Index");
    }
}
