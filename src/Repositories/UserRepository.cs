using Connect.Agro.Models.Consts;
using Connect.Agro.Models.Domain;
using Dapper;
using Microsoft.Data.SqlClient;

namespace Connect.Agro.Repositories;

public class UserRepository
{
    public async Task<User?> GetUserByUsername(string username)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = "SELECT * FROM Users WHERE Username = @Username";
        var result =
            await connection.QueryAsync<User>
            (
                query,
                new { Username = username }
            );

        var user = result.FirstOrDefault();

        return user;
    }

    public async Task AddUser(User user){
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = "INSERT INTO Users (Username, PasswordHash, PasswordSalt, Email) VALUES (@Username, @PasswordHash, @PasswordSalt, @Email)";
        await connection.ExecuteAsync
        (
            query,
            new
            {
                user.Username,
                user.PasswordHash,
                user.PasswordSalt,
                user.Email
            }
        );
    }
}
