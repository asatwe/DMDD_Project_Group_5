-- Create a stored procedure to decrypt payment information
CREATE PROCEDURE DecryptPaymentInfo
    @CustomerID INT
AS
BEGIN
    OPEN SYMMETRIC KEY MySymmetricKey DECRYPTION BY CERTIFICATE MyCertificate;

    SELECT 
        CustomerID,
        CONVERT(VARCHAR(MAX), DECRYPTBYKEY(EncryptedPaymentInfo)) AS DecryptedPaymentInfo
    FROM Customer
    WHERE CustomerID = @CustomerID;

    CLOSE SYMMETRIC KEY MySymmetricKey;
END;




-- -- CREATE TRIGGER EncryptPaymentInfo
-- -- ON Customer
-- -- AFTER INSERT
-- -- AS
-- -- BEGIN
-- --     OPEN SYMMETRIC KEY MySymmetricKey DECRYPTION BY CERTIFICATE MyCertificate;

-- --     UPDATE Customer
-- --     SET EncryptedPaymentInfo = ENCRYPTBYKEY(KEY_GUID('MySymmetricKey'), i.EncryptedPaymentInfo)
-- --     FROM Customer c
-- --     INNER JOIN inserted i ON c.CustomerID = i.CustomerID;

-- --     CLOSE SYMMETRIC KEY MySymmetricKey;
-- -- END;

