using Connect.Agro.Models;
using Connect.Agro.Models.Consts;
using Connect.Agro.Models.Domain;
using Dapper;
using Microsoft.Data.SqlClient;

namespace Connect.Agro.Repositories;

public class StorageReportsRepository
{
    public async Task<List<StorageSupply>> GetCurrentSuppliesStorage()
    {

        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
                SELECT 
					pdt.Id,
					pdt.Description,
					pdt.Price,
					query.Quantity
				FROM Products pdt 
				INNER JOIN Supplies spl ON (pdt.Id = spl.ProductId)
				LEFT JOIN 
					(SELECT 
						ProductId,
						Description, 
						SUM(Quantity) AS Quantity
						FROM (
						SELECT 
							invmov.ProductId,
							prod.Description,
							invmov.Quantity AS Quantity
						FROM InventoryMovements invmov
						INNER JOIN Entries ent ON (invmov.Id = ent.InventoryMovementId)
						INNER JOIN Products prod ON (invmov.ProductId = prod.Id)
						UNION
						SELECT 
							invmov.ProductId,
							prod.Description,
							invmov.Quantity * (-1) AS Quantity
						FROM InventoryMovements invmov
						INNER JOIN PlantationUsedSupplies pus ON (invmov.Id = pus.InventoryMovementId)
						INNER JOIN Products prod ON (invmov.ProductId = prod.Id)) sub
					GROUP BY 
						ProductId,
						Description)query 
						ON (query.ProductId = pdt.Id)
            ";
        var result =
            await connection.QueryAsync<StorageSupply>
            (
                query
            );

        var storageSupplies = result.ToList();

        return storageSupplies;
    }

    public async Task<StorageProduce> GetCurrentProducesStorageByProductId(int productId)
    {

        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
                SELECT 
					pdt.Id,
					pdt.Description,
					pdt.Price,
					SUM(query.Quantity) AS Quantity
				FROM Products pdt 
				INNER JOIN Produces pdc ON (pdt.Id = pdc.ProductId)
				INNER JOIN 
								(SELECT 
									ProductId,
									Description, 
									Quantity
									FROM (
										SELECT 
											invmov.ProductId,
											prod.Description,
											invmov.Quantity AS Quantity
										FROM InventoryMovements invmov
										INNER JOIN Plantations plant ON (invmov.Id = plant.InventoryMovementId)
										INNER JOIN Products prod ON (invmov.ProductId = prod.Id)
										WHERE prod.Id = @ProductId
										AND plant.ExpectedHarvestDate <= GETDATE()
										UNION
										SELECT 
											invmov.ProductId,
											prod.Description,
											invmov.Quantity * (-1) AS Quantity
										FROM InventoryMovements invmov
										INNER JOIN Sales sal ON (invmov.Id = sal.InventoryMovementId)
										INNER JOIN Products prod ON (invmov.ProductId = prod.Id)
										WHERE prod.Id = @ProductId
										)sub
									)query 
					ON (query.ProductId = pdt.Id)
				GROUP BY 
					pdt.Id,
					pdt.Description,
					pdt.Price;

            ";
        var result =
            await connection.QueryAsync<StorageProduce>
            (
                query,
				new
				{
					productId
				}
            );

        var storageProduces = result.FirstOrDefault();

        return storageProduces;
    }

    public async Task<List<StorageProduce>> GetCurrentProducesStorage()
    {

        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
                  SELECT 
						pdt.Id,
						pdt.Description,
						pdt.Price,
						SUM(query.Quantity) AS Quantity
					FROM Products pdt 
					INNER JOIN Produces pdc ON (pdt.Id = pdc.ProductId)
					LEFT JOIN 
									(SELECT 
										ProductId,
										Description, 
										Quantity
										FROM (
											SELECT 
												invmov.ProductId,
												prod.Description,
												invmov.Quantity AS Quantity
											FROM InventoryMovements invmov
											INNER JOIN Plantations plant ON (invmov.Id = plant.InventoryMovementId)
											INNER JOIN Products prod ON (invmov.ProductId = prod.Id)
											WHERE plant.ExpectedHarvestDate <= GETDATE()
											UNION
											SELECT 
												invmov.ProductId,
												prod.Description,
												invmov.Quantity * (-1) AS Quantity
											FROM InventoryMovements invmov
											INNER JOIN Sales sal ON (invmov.Id = sal.InventoryMovementId)
											INNER JOIN Products prod ON (invmov.ProductId = prod.Id)
											)sub
										)query 
						ON (query.ProductId = pdt.Id)
					GROUP BY 
						pdt.Id,
						pdt.Description,
						pdt.Price;
            ";
        var result =
            await connection.QueryAsync<StorageProduce>
            (
                query
            );

        var storageSupplies = result.ToList();

        return storageSupplies;
    }
}
