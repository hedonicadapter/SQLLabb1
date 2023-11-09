CREATE PROCEDURE moveBooks
    @fromStore INT,
    @toStore INT,
    @ISBN VARCHAR(17),
    @quantity INT = 1
AS
BEGIN
    BEGIN TRAN;

    BEGIN TRY

        DECLARE @realQuantity INT = 0;

        SET @realQuantity = (
                SELECT IIF((Quantity - @quantity) > 0, Quantity - @quantity, 0) -- Math.Max(x, 0) (Finns GREATER() i senare versioner, mycket mer clean)
                FROM Inventory 
                WHERE ISBN = @ISBN AND StoreID = @fromStore
            )

        UPDATE Inventory
        SET Quantity = Quantity + @realQuantity
        WHERE ISBN = @ISBN AND StoreID = @toStore;
        
        UPDATE Inventory
        SET Quantity = @realQuantity
        WHERE ISBN = @ISBN AND StoreID = @fromStore;
        
        COMMIT;
    END TRY
    BEGIN CATCH
        PRINT 'Something went wrong moving books: ' + ERROR_MESSAGE();
        ROLLBACK;
    END CATCH;
END