using Connect.Agro.Repositories;
using Connect.Agro.Models.Dtos;
using Connect.Agro.Models.Dtos.Responses;
using System.Security.Cryptography;
using System.Text;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Models.Domain;
using Connect.Agro.Helpers;

namespace Connect.Agro.Services;

public class UserService
{
    private void ValidateLoginRequest(LoginRequestDto loginDto)
    {
        if (string.IsNullOrWhiteSpace(loginDto.Username))
        {
            throw new ArgumentNullException(nameof(loginDto.Username));
        }

        if (string.IsNullOrWhiteSpace(loginDto.Password))
        {
            throw new ArgumentNullException(nameof(loginDto.Password));
        }
    }

    private static bool PasswordHashMatches(string rawPassword, byte[] passwordHash, byte[] passwordSalt)
        {
            using var hmac = new HMACSHA512(passwordSalt);
            var newHash = hmac.ComputeHash(Encoding.UTF8.GetBytes(rawPassword));
            return newHash.SequenceEqual(passwordHash);
        }

    private async Task<bool> UserAlreadyExists(UserRepository userRepository, string username)
    {
        var userFromDatabase = await userRepository.GetUserByUsername(username);

        return userFromDatabase != null;
    }


    public async Task<CreationResponse> Register(UserRegisterRequestDto userDto)
    {
        try
        {
            if (userDto == null)
            {
                return new CreationResponse
                {
                    Code = 400,
                    Success = false,
                    Payload = "Invalid request"
                };
            }

            var userRepository = new UserRepository();

           if (await UserAlreadyExists(userRepository, userDto.Username))
            {
                return new CreationResponse
                {
                    Code = 409,
                    Success = false,
                    Payload = "Username already exists"
                };
            }

            (var passwordHash, var passwordSalt) = CreatePasswordHash(userDto.Password);

            var user = new User()
            {
                Username = userDto.Username,
                Email = userDto.Email,
                PasswordHash = passwordHash,
                PasswordSalt = passwordSalt
            };

            await userRepository.AddUser(user);

            return new CreationResponse
            {
                Payload = "User registered successfully"
            };
        }
        catch (Exception ex)
        {
            return new CreationResponse
            {
                Code = 500,
                Success = false,
                Payload = ex.Message
            };
        }
    }

    private static (byte[] hash, byte[] salt) CreatePasswordHash(string password)
        {
            using var hmac = new HMACSHA512();
            return (
                   hmac.ComputeHash(Encoding.UTF8.GetBytes(password)),
                   hmac.Key
               );
        }

    public async Task<LoginResponseDto> Authenticate(LoginRequestDto loginDto)
    {
        try     
        {
            ValidateLoginRequest(loginDto);

            var userRepository = new UserRepository();
            
            var userFromDatabase = await userRepository.GetUserByUsername(loginDto.Username);

            if (userFromDatabase == null || !PasswordHashMatches(loginDto.Password, userFromDatabase.PasswordHash, userFromDatabase.PasswordSalt))
            {
                return new LoginResponseDto
                {
                    Success = false,
                    Payload = "Invalid username or password"
                };
            }

            userFromDatabase.PasswordHash = [];
            userFromDatabase.PasswordSalt = [];

            return new LoginResponseDto()
            {
                Success = true,
                Payload = "Login successful",
                AuthorizationToken = JwtHelper.GenerateJwtToken(loginDto),
                LoggedUser = userFromDatabase
            };

        }
        catch (Exception ex)
        {
            return new LoginResponseDto
            {
                Success = false,
                Payload = ex.Message
            };
        }
    }
}
