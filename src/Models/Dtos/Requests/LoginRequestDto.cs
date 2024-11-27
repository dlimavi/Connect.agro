using System.ComponentModel.DataAnnotations;

namespace Connect.Agro.Models.Dtos;

public class LoginRequestDto
{
    [Required(ErrorMessage = "*Campo obrigat�rio")]
    public required string Username { get; set; }

    [Required(ErrorMessage = "*Campo obrigat�rio")]
    public required string Password { get; set; }

}
