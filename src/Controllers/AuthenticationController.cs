using Connect.Agro.Models.Dtos;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Models.Dtos.Responses;
using Connect.Agro.Services;
using Microsoft.AspNetCore.Mvc;

namespace Connect.Agro.Controllers;

[Route("api/[controller]")]
[ApiController]
public class AuthenticationController : ControllerBase
{

    [HttpPost]
    [Route("login")]
    public async Task<IActionResult> Login(LoginRequestDto loginDto)
    {
        var userService = new UserService();
        LoginResponseDto response = await userService.Authenticate(loginDto);
        return Ok(response);
    }

    [HttpPost]
    [Route("register")]
    public async Task<IActionResult> Register(UserRegisterRequestDto registerDto)
    {
        var userService = new UserService();
        var response = await userService.Register(registerDto);

        switch (response.Code)
        {
            case 201:
                return Created();
            case 409:
                return Conflict();
            case 400:
                return BadRequest();
            default:
                return StatusCode(500);
        }
    }

    [HttpPost]
    [Route("forgot-password")]
    public IActionResult ForgotPassword()
    {
        return Ok();
    }
}
