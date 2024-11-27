using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Connect.Agro.Models.Consts;
using Connect.Agro.Models.Dtos;
using Microsoft.IdentityModel.Tokens;

namespace Connect.Agro.Helpers;

public static class JwtHelper
{
    public static string GenerateJwtToken(LoginRequestDto userDto)
    {
        List<Claim> claims = new()
        {
            new Claim(ClaimTypes.Name, userDto.Username)
        };

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(SettingsConsts.JwtSecretKey));

        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);
        
        var token = new JwtSecurityToken(
                claims: claims,
                expires: DateTime.Now.AddHours(SettingsConsts.JwtTokenHoursToExpire),
                signingCredentials: credentials
            );

        return new JwtSecurityTokenHandler().WriteToken(token);

    }
}
