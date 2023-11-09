CREATE PROCEDURE moveBooks
    @fromStore INT,
    @toStore INT,
    @ISBN VARCHAR(17),
    @quantity INT = 1
AS
BEGIN
    BEGIN TRAN;

    BEGIN TRY

        UPDATE Inventory
        SET Quantity = Quantity + @quantity
        WHERE ISBN = @ISBN AND StoreID = @toStore;
        
        UPDATE Inventory
        SET Quantity = (SELECT IIF((Quantity - @quantity) > 0, Quantity - @quantity, 0))
        WHERE ISBN = @ISBN AND StoreID = @fromStore;

        -- Istället för IIF(), funkar i SQL Server 2022 T-SQL 16.x+:
        -- GREATEST(Quantity - @quantity, 0) -- mycket mer clean imo
        
        COMMIT;
    END TRY
    BEGIN CATCH
        PRINT 'Something went wrong moving books: ' + ERROR_MESSAGE();
        ROLLBACK;
    END CATCH;
END