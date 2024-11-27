using Connect.Agro.Dll.src.Models.Dtos.Reports;
using Connect.Agro.Models.Consts;
using Connect.Agro.Models.Domain;
using Dapper;
using Microsoft.Data.SqlClient;

namespace Connect.Agro.Repositories;

public class EntryRepository
{
    public async Task<List<EntryReport>> GetAllEntries()
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            SELECT 
	            invmov.Id,
	            pdt.Description AS ProductDescription,
	            invmov.Date,
	            invmov.Quantity,
	            comp.BusinessName AS SupplierBusinessName
            FROM Entries ent
            INNER JOIN InventoryMovements invmov ON (ent.InventoryMovementId = invmov.Id)
            INNER JOIN Products pdt ON (invmov.ProductId = pdt.Id)
            INNER JOIN Companies comp ON (ent.SupplierId = comp.Id)";
        var result =
            await connection.QueryAsync<EntryReport>
            (
                query
            );

        var Entries = result.ToList();

        return Entries;
    }

    public async Task<Entry?> GetById(int id)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            SELECT
            * 
            FROM Entries ent
            INNER JOIN InventoryMovements invmov ON (ent.InventoryMovementId = invmov.Id)
            WHERE ent.InventoryMovementId = @Id";

        var result = await connection.QueryAsync<Entry> (query, new { Id = id });

        var Entry = result.FirstOrDefault();

        return Entry;
    }

    public async Task Update(Entry Entry)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            
            UPDATE InventoryMovements
            SET 
                ProductId = @ProductId,
                Date = @Date, 
                Quantity = @Quantity
            WHERE Id = @Id;

            UPDATE Entries
            SET
                SupplierId = @SupplierId
            WHERE InventoryMovementId = @Id";

        var insertedEntryId = await connection.ExecuteScalarAsync<int>
        (
            query,
            new
            {
                Entry.Id,
                Entry.ProductId,
                Entry.Date,
                Entry.Quantity,
                Entry.SupplierId
            }
        );
    }


    public async Task Insert(Entry Entry)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            
            DECLARE @InsertedId INT;

            INSERT INTO InventoryMovements ( ProductId, Date, Quantity)
            VALUES ( @ProductId, @Date, @Quantity);

            SET @InsertedId = SCOPE_IDENTITY();

            INSERT INTO Entries (InventoryMovementId, SupplierId) 
            VALUES ( @InsertedId, @SupplierId)";
            
        var insertedEntryId = await connection.ExecuteAsync
        (
            query,
            new
            {
                Entry.ProductId,
                Entry.Date,
                Entry.Quantity,
                Entry.SupplierId
            }
        );
    }

    public async Task Delete(int id)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            DELETE FROM Entries  
            WHERE InventoryMovementId = @Id;
            
            DELETE FROM InventoryMovements  
            WHERE Id = @Id";

        await connection.ExecuteAsync ( query, new { id } );
    }
}
