using Connect.Agro.Models.Consts;
using Connect.Agro.Models.Domain;
using Dapper;
using Microsoft.Data.SqlClient;

namespace Connect.Agro.Repositories;

public class CustomerRepository
{
    public async Task<List<Customer>> GetAllCustomersAsync()
    {
         await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            SELECT 
                * 
            FROM Customers cust
            INNER JOIN Companies comp ON (cust.CompanyId = comp.Id)";
        var result =
            await connection.QueryAsync<Customer>
            (
                query
            );

        var Customers = result.ToList();

        return Customers;
    } 

    public async Task<Customer?> GetById(int CustomerId)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            SELECT 
                * 
            FROM Customers cust
            INNER JOIN Companies comp ON (cust.CompanyId = comp.Id)
            WHERE cust.CompanyId = @Id";
        var result =
            await connection.QueryAsync<Customer>
            (
                query,
                new { Id = CustomerId }
            );

        var Customer = result.FirstOrDefault();

        return Customer;
    }

    public async Task<int> InsertAsync(Customer Customer)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            DECLARE @InsertedId INT;

            INSERT INTO Companies ( BusinessName, Email, Document )
            VALUES ( @BusinessName, @Email, @Document );

            SET @InsertedId = SCOPE_IDENTITY();

            INSERT INTO Customers ( CompanyId, Address ) 
            VALUES ( @InsertedId, @Address )";
        var insertedCustomerId = await connection.ExecuteScalarAsync<int>
        (
            query,
            new
            {
                Customer.BusinessName,
                Customer.Email,
                Customer.Document,
                Customer.Address
            }
        );

        return insertedCustomerId;
    }

    public async Task Update(Customer Customer)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            UPDATE Companies
            SET 
                BusinessName = @BusinessName,
                Email = @Email,
                Document = @Document

            WHERE Id = @Id;
            
            UPDATE Customers
            SET Address = @Address
            WHERE CompanyId = @Id";
        await connection.ExecuteAsync
        (
            query,
            new
            {
                Customer.BusinessName,
                Customer.Email,
                Customer.Document,
                Customer.Address,
                Customer.Id
            }
        );
    }

    public async Task DeleteAsync(int CustomerId)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            DELETE FROM Customers
            WHERE CompanyId = @Id
            DELETE FROM Companies  
            WHERE Id = @Id";
        await connection.ExecuteAsync
        (
            query, new { Id = CustomerId }
        );
    }
}
