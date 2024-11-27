using System.ComponentModel.DataAnnotations;

namespace Connect.Agro.Models.Dtos;

public class LoginRequestDto
{
    [Required(ErrorMessage = "*Campo obrigatório")]
    public required string Username { get; set; }

    [Required(ErrorMessage = "*Campo obrigatório")]
    public required string Password { get; set; }

}
