-- -- Check if the database 'TaxiManagementSystem' exists
-- IF EXISTS (SELECT name FROM sys.databases WHERE name = N'TaxiManagementSystem')
-- BEGIN
--     -- Drop (delete) the database 'TaxiManagementSystem' if it exists
--     DROP DATABASE TaxiManagementSystem;
-- END
-- GO

-- -- DROP DATABASE TaxiManagementSystem

-- -- Create a new database named 'TaxiManagementSystem'
-- CREATE DATABASE TaxiManagementSystem;
-- GO

-- -- Switch to the 'TaxiManagementSystem' database
-- USE TaxiManagementSystem;
-- GO

-- -- Drop table statements

-- -- ServiceRequest Table
-- DROP TABLE IF EXISTS ServiceRequest;
-- GO

-- -- RideRequest Table
-- DROP TABLE IF EXISTS RideRequest;
-- GO

-- -- Trip Estimate Table
-- DROP TABLE IF EXISTS TripEstimate;
-- GO

-- -- Feedback Table
-- DROP TABLE IF EXISTS Feedback;
-- GO

-- -- Driver Table
-- DROP TABLE IF EXISTS Driver;
-- GO

-- -- User Table
-- DROP TABLE IF EXISTS [User];
-- GO

-- -- Vehicle Table
-- DROP TABLE IF EXISTS Vehicle;
-- GO

-- -- Customer Table
-- DROP TABLE IF EXISTS Customer;
-- GO

-- -- Insurance Table
-- DROP TABLE IF EXISTS Insurance;
-- GO

-- -- Service Table
-- DROP TABLE IF EXISTS Service;
-- GO

-- -- InsuranceLogs Table
-- DROP TABLE IF EXISTS InsuranceLogs;
-- GO

-- -- Service Table
-- CREATE TABLE Service (
--     ServiceId INT PRIMARY KEY,          -- Unique identifier for each service
--     ServiceCompanyName VARCHAR(50),     -- Name of the company providing the service
--     ServiceName VARCHAR(50),            -- Name of the service
--     ServiceDetails VARCHAR(255)         -- Additional details or description of the service
-- );
-- GO

-- -- Insurance Table
-- CREATE TABLE Insurance (
--     InsuranceId INT PRIMARY KEY,            -- Unique identifier for each insurance record
--     InsuranceProvider VARCHAR(50),          -- Name of the insurance provider
--     InsuranceCoverage VARCHAR(255),         -- Details of insurance coverage
--     InsurancePremium DECIMAL(10, 2),        -- Cost of the insurance premium (monetary value with two decimal places)
--     InsuranceDeductible DECIMAL(10, 2)      -- Deductible amount for the insurance (monetary value with two decimal places)
-- );
-- GO

-- -- Vehicle Table
-- CREATE TABLE Vehicle (
--     VehicleId INT PRIMARY KEY,                                      -- Unique identifier for each vehicle
--     VehicleType VARCHAR(50),                                        -- Type or model of the vehicle
--     ServiceInfo VARCHAR(255),                                       -- Information about the vehicle's service history
--     InsuranceInfo CHAR(1) CHECK (InsuranceInfo IN ('Y', 'N'))       -- Check constraint for InsuranceInfo (Y for present, N for not present)
-- );
-- GO

-- -- User Table
-- CREATE TABLE [User] (
--     UserID INT PRIMARY KEY,                                         -- Unique identifier for each user
--     UserFName VARCHAR(50) NOT NULL,                                 -- User's first name
--     UserLName VARCHAR(50) NOT NULL,                                 -- User's last name
--     PhoneNumber VARCHAR(15) NOT NULL,                               -- User's phone number
--     EmailId VARCHAR(255) NOT NULL,                                  -- User's email address
--     DOB DATE NOT NULL,                                              -- User's date of birth
--     BankAccInfo VARCHAR(255) NOT NULL,                              -- User's bank account information
--     UserType CHAR(1) NOT NULL CHECK (UserType IN ('D', 'C')),       -- Type of user (D for driver, C for customer)
-- );
-- GO

-- -- Customer Table
-- -- This table stores information about customers who use the service.
-- CREATE TABLE Customer (
--     CustomerID INT PRIMARY KEY,                             -- Unique identifier for each customer
--     UserID INT FOREIGN KEY REFERENCES [User](UserID),       -- Foreign key referencing the User table to link with user information
--     EncryptedPaymentInfo VARBINARY(MAX)                    -- Encrypted payment information for the customer
-- );

-- -- Create a master key
-- CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'AmeySatwe23';

-- -- Create a certificate to protect the master key
-- CREATE CERTIFICATE MyCertificate
--    WITH SUBJECT = 'My Column Encryption Certificate';

-- -- Create a symmetric key
-- CREATE SYMMETRIC KEY MySymmetricKey
--    WITH ALGORITHM = AES_256
--    ENCRYPTION BY CERTIFICATE MyCertificate;

-- -- Create an AFTER INSERT trigger
-- GO

-- -- Driver Table
-- -- This table stores information about drivers who provide services using vehicles.

-- CREATE TABLE Driver (
--     DriverID INT PRIMARY KEY NOT NULL,                               -- Unique identifier for each driver
--     UserID INT FOREIGN KEY REFERENCES [User](UserID),                -- Foreign key referencing the User table to link with user information
--     VehicleID INT FOREIGN KEY REFERENCES Vehicle(VehicleID),         -- Foreign key referencing the Vehicle table to link with vehicle information
--     LicenseInfo VARCHAR(255) NOT NULL,                               -- Driver's license information
-- );
-- GO

-- -- Feedback Table
-- CREATE TABLE Feedback (
--     FeedbackID INT PRIMARY KEY NOT NULL,                            -- Unique identifier for each feedback record
--     CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerId),     -- Foreign key referencing Customer table
--     DriverID INT FOREIGN KEY REFERENCES Driver(DriverID),           -- Foreign key referencing Driver table
--     Message VARCHAR(255) NOT NULL,                                   -- Feedback message
--     Rating Float CHECK(Rating BETWEEN 0.0 AND 5.0) DEFAULT 0.0
-- );
-- GO

-- -- Trip Estimate Table
-- CREATE TABLE TripEstimate (
--     EstimationId INT PRIMARY KEY NOT NULL,                          -- Unique identifier for each trip estimate
--     VehicleID INT FOREIGN KEY REFERENCES Vehicle(VehicleID),        -- Foreign key referencing Vehicle table
--     CurrentTime DATETIME NOT NULL,                                  -- Timestamp of the trip estimate
--     Cost DECIMAL(10, 2) NOT NULL                                    -- Estimated cost of the trip
-- );
-- GO

-- -- RideRequest Table
-- CREATE TABLE RideRequest (
--     RequestId INT PRIMARY KEY NOT NULL,                                                 -- Unique identifier for each ride request
--     EstimationID INT FOREIGN KEY REFERENCES TripEstimate(EstimationId),                 -- Foreign key referencing TripEstimate table
--     VehicleID INT FOREIGN KEY REFERENCES Vehicle(VehicleID),                            -- Foreign key referencing Vehicle table
--     DriverID INT FOREIGN KEY REFERENCES Driver(DriverID),
--     CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
--     RequestType VARCHAR(50) NOT NULL,                                                   -- Type of the ride request
--     ReqDateTime DATETIME NOT NULL,                                                      -- Timestamp of the ride request
--     PickUpLocationLatitude DECIMAL(10, 6) NOT NULL,                                     -- Latitude of the pickup location
--     PickUpLocationLongitude DECIMAL(10, 6) NOT NULL,                                    -- Longitude of the pickup location
--     DestinationLocationLatitude DECIMAL(10, 6) NOT NULL,                                -- Latitude of the destination location
--     DestinationLocationLongitude DECIMAL(10, 6) NOT NULL,                               -- Longitude of the destination location
--     TripType VARCHAR(50) NOT NULL CHECK (TripType IN ('City Cab', 'Out Station Cab')),  -- Type of the trip
--     TripCompletionFlag BIT NOT NULL,                                                    -- Flag indicating trip completion status
--     PickUpLocation VARCHAR(50) NOT NULL,                                                -- Textual description of the pickup location
--     DestinationLocation VARCHAR(50) NOT NULL                                            -- Textual description of the destination location
-- );
-- GO

-- -- ServiceRequest Table
-- CREATE TABLE ServiceRequest (
--     SerReqId INT PRIMARY KEY NOT NULL,                             -- Unique identifier for each service request
--     VehicleId INT FOREIGN KEY REFERENCES Vehicle(VehicleID),       -- Foreign key referencing Vehicle table
--     ServiceId INT FOREIGN KEY REFERENCES Service(ServiceID),       -- Foreign key referencing Service table
--     ReqDateTime DATETIME NOT NULL,                                 -- Timestamp of the service request
--     ServiceDueDate DATE NOT NULL,                                  -- Due date for the requested service
--     PreviousServiceDate DATE NOT NULL                              -- Date of the previous service for the vehicle
-- );
-- GO

-- -- InsuranceLogs Table
-- CREATE TABLE InsuranceLogs (
--     VehicleID INT FOREIGN KEY REFERENCES Vehicle(VehicleID),            -- Foreign key referencing Vehicle table
--     InsuranceId INT FOREIGN KEY REFERENCES Insurance(InsuranceId),      -- Foreign key referencing Insurance table
--     InsuranceStartDate DATE NOT NULL,                                   -- Start date of the insurance coverage
--     InsuranceEndDate DATE NOT NULL                                      -- End date of the insurance coverage
-- );
-- GO

-- CREATE TABLE Customer (
--     CustomerID INT PRIMARY KEY,                             -- Unique identifier for each customer
--     UserID INT FOREIGN KEY REFERENCES [User](UserID),       -- Foreign key referencing the User table to link with user information
--     EncryptedPaymentInfo VARBINARY(MAX)                    -- Encrypted payment information for the customer
-- );

-- -- Create a master key
-- -- Create an AFTER INSERT trigger

-- Inserting Data in Service Table
INSERT INTO Service (ServiceId, ServiceCompanyName, ServiceName, ServiceDetails)
VALUES 
    (1, 'ABC Service Company', 'Regular Maintenance', 'Scheduled maintenance and inspection'),
    (2, 'XYZ Repairs', 'Brake Replacement', 'Replacement of worn-out brake components'),
    (3, 'QuickOil', 'Oil Change', 'Fast and efficient oil change service'),
    (4, 'Sparkle Wash', 'Car Wash', 'Exterior and interior cleaning services'),
    (5, 'Coolant Experts', 'Coolant Flush', 'Professional coolant system flushing');

-- Inserting Data in Insurance Table
INSERT INTO Insurance (InsuranceId, InsuranceProvider, InsuranceCoverage, InsurancePremium, InsuranceDeductible)
VALUES 
    (1, 'XYZ Insurance', 'Comprehensive Coverage', 500.00, 50.00),
    (2, 'SafeDrive Assurance', 'Liability Coverage', 300.00, 30.00),
    (3, 'Guardian Insurers', 'Collision Coverage', 400.00, 40.00),
    (4, 'Shield Protect', 'Full Coverage', 600.00, 60.00),
    (5, 'SureSafety Insurance', 'Uninsured Motorist Coverage', 250.00, 25.00);

-- Inserting Data in Vehicle Table
INSERT INTO Vehicle (VehicleId, VehicleType, ServiceInfo, InsuranceInfo)
VALUES 
    (1, 'Sedan', 'Regularly serviced', 'Y'),
    (2, 'SUV', 'Bi-annual check-ups', 'Y'),
    (3, 'Truck', 'Heavy-duty maintenance', 'N'),
    (4, 'Compact', 'Fuel-efficient model', 'Y'),
    (5, 'Convertible', 'Specialized care', 'N');

-- Inserting Data in [User] Table
INSERT INTO [User] (UserID, UserFName, UserLName, PhoneNumber, EmailId, DOB, BankAccInfo, UserType)
VALUES 
    (1, 'John', 'Doe', '123-456-7890', 'john.doe@email.com', '1990-01-01', 'Bank XXXX-XXXX-XXXX', 'C'),
    (2, 'Alice', 'Johnson', '987-654-3210', 'alice.johnson@email.com', '1985-05-15', 'Bank YYYY-YYYY-YYYY', 'D'),
    (3, 'Bob', 'Smith', '555-123-4567', 'bob.smith@email.com', '1978-09-30', 'Bank ZZZZ-ZZZZ-ZZZZ', 'C'),
    (4, 'Eva', 'Williams', '111-222-3333', 'eva.williams@email.com', '1995-07-20', 'Bank ABCD-1234-5678', 'D'),
    (5, 'Chris', 'Taylor', '777-888-9999', 'chris.taylor@email.com', '1982-03-10', 'Bank WXYZ-5678-9012', 'C');

-- Inserting Data in Customer Table
INSERT INTO Customer (CustomerId, UserID, EncryptedPaymentInfo)
VALUES 
    (1, 1, CONVERT(varbinary(MAX),'Credit Card - XXXX-XXXX-XXXX-XXXX')),
    (2, 3, CONVERT(varbinary(MAX),'PayPal - user@example.com')),
    (3, 5, CONVERT(varbinary(MAX),'Debit Card - YYYY-YYYY-YYYY-YYYY')),
    (4, 2, CONVERT(varbinary(MAX),'Bank Transfer - Account: XXXXXXXX, Routing: YYYYYYYY')),
    (5, 4, CONVERT(varbinary(MAX),'Cash on Delivery'));

-- Inserting Data in Driver Table
INSERT INTO Driver (DriverID, UserID, VehicleID, LicenseInfo)
VALUES 
    (1, 2, 2, 'DL123456'),
    (2, 4, 1, 'DL789012'),
    (3, 5, 4, 'DL345678'),
    (4, 3, 3, 'DL901234'),
    (5, 1, 5, 'DL567890');

-- Inserting Data in Feedback Table
INSERT INTO Feedback (FeedbackID, CustomerID, DriverID, Message,Rating)
VALUES 
    (1, 1, 2, 'Excellent service!',2.5),
    (2, 3, 2, 'Driver was punctual.',3),
    (3, 5, 1, 'Vehicle was clean and well-maintained.',5),
    (4, 2, 3, 'Smooth and safe driving.',4),
    (5, 4, 1, 'Driver was courteous.',5);

-- Inserting Data in TripEstimate Table
INSERT INTO TripEstimate (EstimationId, VehicleID, CurrentTime, Cost)
VALUES 
    (1, 2, '2023-11-24 08:00:00', 35.50),
    (2, 4, '2023-11-25 14:30:00', 20.75),
    (3, 1, '2023-11-26 10:45:00', 45.20),
    (4, 3, '2023-11-27 18:20:00', 30.00),
    (5, 5, '2023-11-28 22:15:00', 55.80);

-- Inserting Data in RideRequest Table
INSERT INTO RideRequest (RequestId, EstimationID, VehicleID,DriverID, CustomerID,RequestType, ReqDateTime, 
    PickUpLocationLatitude, PickUpLocationLongitude, DestinationLocationLatitude, 
    DestinationLocationLongitude, TripType, TripCompletionFlag, PickUpLocation, DestinationLocation)
VALUES 
    (1, 1, 2, 1,1,'City Cab', '2023-11-24 09:00:00', 40.7128, -74.0060, 40.7414, -73.9906, 'City Cab', 1, '123 Main St', '456 Broadway'),
    (2, 2, 4, 1,2,'Out Station Cab', '2023-11-25 15:00:00', 34.0522, -118.2437, 37.7749, -122.4194, 'Out Station Cab', 0, '789 Oak St', '101 Pine St'),
    (3, 3, 1, 1,3,'City Cab', '2023-11-26 11:00:00', 41.8781, -87.6298, 39.9526, -75.1652, 'City Cab', 1, '567 Elm St', '202 Walnut St'),
    (4, 4, 3, 2,4,'Out Station Cab', '2023-11-27 19:00:00', 29.7604, -95.3698, 32.7767, -96.7970, 'Out Station Cab', 0, '890 Maple St', '303 Oak St'),
    (5, 5, 5, 2,5,'City Cab', '2023-11-28 23:00:00', 34.0522, -118.2437, 34.0522, -118.2437, 'City Cab', 1, '111 Pine St', '999 Maple St');

-- Inserting Data in ServiceRequest Table
INSERT INTO ServiceRequest (SerReqId, VehicleId, ServiceId, ReqDateTime, ServiceDueDate, PreviousServiceDate)
VALUES 
    (1, 2, 1, '2023-11-24 10:00:00', '2023-12-01', '2023-11-01'),
    (2, 4, 3, '2023-11-25 16:00:00', '2023-12-05', '2023-11-01'),
    (3, 1, 2, '2023-11-26 12:00:00', '2023-12-10', '2023-11-01'),
    (4, 3, 4, '2023-11-27 20:00:00', '2023-12-15', '2023-11-01'),
    (5, 5, 5, '2023-11-29 00:00:00', '2023-12-20', '2023-11-01');

-- Inserting Data in InsuranceLogs Table
INSERT INTO InsuranceLogs (VehicleID, InsuranceId, InsuranceStartDate, InsuranceEndDate)
VALUES 
    (2, 1, '2023-01-01', '2023-12-31'),
    (4, 2, '2023-02-01', '2023-11-30'),
    (1, 3, '2023-03-01', '2023-12-15'),
    (3, 4, '2023-04-01', '2023-12-20'),
    (5, 5, '2023-05-01', '2023-12-25');

-- Displaying Data from Service Table
SELECT * FROM Service;

-- Displaying Data from Insurance Table
SELECT * FROM Insurance;

-- Displaying Data from Vehicle Table
SELECT * FROM Vehicle;

-- Displaying Data from [User] Table
SELECT * FROM [User];

-- Displaying Data from Customer Table
SELECT * FROM Customer;

-- Displaying Data from Driver Table
SELECT * FROM Driver;

-- Displaying Data from Feedback Table
SELECT * FROM Feedback;

-- Displaying Data from TripEstimate Table
SELECT * FROM TripEstimate;

-- Displaying Data from RideRequest Table
SELECT * FROM RideRequest;

-- Displaying Data from ServiceRequest Table
SELECT * FROM ServiceRequest;

-- Displaying Data from InsuranceLogs Table
SELECT * FROM InsuranceLogs;







-- CREATE TRIGGER EncryptPaymentInfo
-- ON Customer
-- AFTER INSERT
-- AS
-- BEGIN
--     OPEN SYMMETRIC KEY MySymmetricKey DECRYPTION BY CERTIFICATE MyCertificate;

--     UPDATE Customer
--     SET EncryptedPaymentInfo = ENCRYPTBYKEY(KEY_GUID('MySymmetricKey'), i.EncryptedPaymentInfo)
--     FROM Customer c
--     INNER JOIN inserted i ON c.CustomerID = i.CustomerID;

--     CLOSE SYMMETRIC KEY MySymmetricKey;
-- END;
