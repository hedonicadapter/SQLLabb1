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

		SELECT @realQuantity = IIF((Quantity - @quantity) > 0, Quantity - @quantity, 0)
        FROM Inventory
        WHERE ISBN = @ISBN AND StoreID = @fromStore;
		
		IF EXISTS (SELECT * FROM Inventory WHERE ISBN = @ISBN AND StoreID = @toStore)
		BEGIN
			UPDATE Inventory
			SET Quantity = Quantity + @realQuantity
			WHERE ISBN = @ISBN AND StoreID = @toStore;
		END
		ELSE BEGIN
			INSERT INTO Inventory(StoreID, ISBN, Quantity)
			VALUES (@toStore, @ISBN, @realQuantity);
		END
        
		IF @@ROWCOUNT = 0
            RAISERROR('No toStore rows updated', 16, 1);
 
		
		IF EXISTS (SELECT * FROM Inventory WHERE ISBN = @ISBN AND StoreID = @fromStore)
		BEGIN
			UPDATE Inventory
			SET Quantity = @realQuantity
			WHERE ISBN = @ISBN AND StoreID = @fromStore;
		END
		ELSE BEGIN
			INSERT INTO Inventory(StoreID, ISBN, Quantity)
			VALUES (@fromStore, @ISBN, @realQuantity);
		END

        IF @@ROWCOUNT = 0
            RAISERROR('No fromStore rows updated', 16, 1);
        
        COMMIT;
    END TRY

    BEGIN CATCH
        SELECT ERROR_LINE() as Line, ERROR_MESSAGE() as Error;
        ROLLBACK;
    END CATCH;
END
EXEC moveBooks @ISBN = 9781111111111, @fromStore = 5, @toStore = 4, @quantity = 45
