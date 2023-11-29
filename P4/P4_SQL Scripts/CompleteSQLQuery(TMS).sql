-- Check if the database 'TaxiManagementSystem' exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'TaxiManagementSystem')
BEGIN
    -- Drop (delete) the database 'TaxiManagementSystem' if it exists
    DROP DATABASE TaxiManagementSystem;
END
GO

-- Create a new database named 'TaxiManagementSystem'
CREATE DATABASE TaxiManagementSystem;
GO

-- Switch to the 'TaxiManagementSystem' database
USE TaxiManagementSystem;
GO

-- Switch to the 'sample' database
USE [sample];
GO

-- Drop table statements

-- ServiceRequest Table
DROP TABLE IF EXISTS ServiceRequest;
GO

-- RideRequest Table
DROP TABLE IF EXISTS RideRequest;
GO

-- Trip Estimate Table
DROP TABLE IF EXISTS TripEstimate;
GO

-- Feedback Table
DROP TABLE IF EXISTS Feedback;
GO

-- Driver Table
DROP TABLE IF EXISTS Driver;
GO

-- Customer Table
DROP TABLE IF EXISTS Customer;
GO

-- User Table
DROP TABLE IF EXISTS [User];
GO

-- InsuranceLogs Table
DROP TABLE IF EXISTS InsuranceLogs;
GO

-- Vehicle Table
DROP TABLE IF EXISTS Vehicle;
GO

-- Insurance Table
DROP TABLE IF EXISTS Insurance;
GO

-- Service Table
DROP TABLE IF EXISTS Service;
GO

-- Service Table
CREATE TABLE Service (
    ServiceId INT PRIMARY KEY,          -- Unique identifier for each service
    ServiceCompanyName VARCHAR(50),     -- Name of the company providing the service
    ServiceName VARCHAR(50),            -- Name of the service
    ServiceDetails VARCHAR(255)         -- Additional details or description of the service
);
GO

-- Insurance Table
CREATE TABLE Insurance (
    InsuranceId INT PRIMARY KEY,            -- Unique identifier for each insurance record
    InsuranceProvider VARCHAR(50),          -- Name of the insurance provider
    InsuranceCoverage VARCHAR(255),         -- Details of insurance coverage
    InsurancePremium DECIMAL(10, 2),        -- Cost of the insurance premium (monetary value with two decimal places)
    InsuranceDeductible DECIMAL(10, 2)      -- Deductible amount for the insurance (monetary value with two decimal places)
);
GO

-- Vehicle Table
CREATE TABLE Vehicle (
    VehicleId INT PRIMARY KEY,                                         -- Unique identifier for each vehicle
    VehicleType VARCHAR(50),                                           -- Type or model of the vehicle
    ServiceInfo VARCHAR(255),                                          -- Information about the vehicle's service history
    InsuranceInfo CHAR(1) CHECK (InsuranceInfo IN ('YES', 'NO'))       -- Check constraint for InsuranceInfo (Y for present, N for not present)
);
GO

-- User Table
CREATE TABLE [User] (
    UserID INT PRIMARY KEY,                                         -- Unique identifier for each user
    UserFName VARCHAR(50) NOT NULL,                                 -- User's first name
    UserLName VARCHAR(50) NOT NULL,                                 -- User's last name
    PhoneNumber VARCHAR(15) NOT NULL,                               -- User's phone number
    EmailId VARCHAR(255) NOT NULL,                                  -- User's email address
    DOB DATE,                                                       -- User's date of birth
    BankAccInfo VARCHAR(255) NOT NULL,                              -- User's bank account information
    UserType CHAR(1) NOT NULL CHECK (UserType IN ('D', 'C')),       -- Type of user (D for driver, C for customer)
);
GO

-- Customer Table
-- This table stores information about customers who use the service.
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,                             -- Unique identifier for each customer
    UserID INT FOREIGN KEY REFERENCES [User](UserID),       -- Foreign key referencing the User table to link with user information
    EncryptedPaymentInfo VARBINARY(MAX)                    -- Encrypted payment information for the customer
);
GO

-- Driver Table
-- This table stores information about drivers who provide services using vehicles.

CREATE TABLE Driver (
    DriverID INT PRIMARY KEY NOT NULL,                               -- Unique identifier for each driver
    UserID INT FOREIGN KEY REFERENCES [User](UserID),                -- Foreign key referencing the User table to link with user information
    VehicleID INT FOREIGN KEY REFERENCES Vehicle(VehicleID),         -- Foreign key referencing the Vehicle table to link with vehicle information
    LicenseInfo VARCHAR(255) NOT NULL,                               -- Driver's license information
);
GO

-- Feedback Table
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY NOT NULL,                            -- Unique identifier for each feedback record
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerId),     -- Foreign key referencing Customer table
    DriverID INT FOREIGN KEY REFERENCES Driver(DriverID),           -- Foreign key referencing Driver table
    Message VARCHAR(255) NOT NULL,                                   -- Feedback message
    Rating Float CHECK(Rating BETWEEN 0.0 AND 5.0) DEFAULT 0.0      -- Rating with a check constraint and default value
);
GO

-- Trip Estimate Table
CREATE TABLE TripEstimate (
    EstimationId INT PRIMARY KEY NOT NULL,                          -- Unique identifier for each trip estimate
    VehicleID INT FOREIGN KEY REFERENCES Vehicle(VehicleID),        -- Foreign key referencing Vehicle table
    CurrentTime DATETIME NOT NULL,                                  -- Timestamp of the trip estimate
    Cost DECIMAL(10, 2) NOT NULL                                    -- Estimated cost of the trip
);
GO

-- RideRequest Table
CREATE TABLE RideRequest (
    RequestId INT PRIMARY KEY NOT NULL,                                                 -- Unique identifier for each ride request
    EstimationID INT FOREIGN KEY REFERENCES TripEstimate(EstimationId),                 -- Foreign key referencing TripEstimate table
    VehicleID INT FOREIGN KEY REFERENCES Vehicle(VehicleID),                            -- Foreign key referencing Vehicle table
    DriverID INT FOREIGN KEY REFERENCES Driver(DriverID),                               -- Foreign key referencing Driver table
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),                         -- Foreign key referencing Customer table
    RequestType VARCHAR(50) NOT NULL,                                                   -- Type of the ride request
    ReqDateTime DATETIME NOT NULL,                                                      -- Timestamp of the ride request
    PickUpLocationLatitude DECIMAL(10, 6) NOT NULL,                                     -- Latitude of the pickup location
    PickUpLocationLongitude DECIMAL(10, 6) NOT NULL,                                    -- Longitude of the pickup location
    DestinationLocationLatitude DECIMAL(10, 6) NOT NULL,                                -- Latitude of the destination location
    DestinationLocationLongitude DECIMAL(10, 6) NOT NULL,                               -- Longitude of the destination location
    TripType VARCHAR(50) NOT NULL CHECK (TripType IN ('City Cab', 'Out Station Cab')),  -- Type of the trip
    TripCompletionFlag BIT NOT NULL,                                                    -- Flag indicating trip completion status
    PickUpLocation VARCHAR(50) NOT NULL,                                                -- Textual description of the pickup location
    DestinationLocation VARCHAR(50) NOT NULL                                            -- Textual description of the destination location
);
GO

-- ServiceRequest Table
CREATE TABLE ServiceRequest (
    SerReqId INT PRIMARY KEY NOT NULL,                             -- Unique identifier for each service request
    VehicleId INT FOREIGN KEY REFERENCES Vehicle(VehicleID),       -- Foreign key referencing Vehicle table
    ServiceId INT FOREIGN KEY REFERENCES Service(ServiceID),       -- Foreign key referencing Service table
    ReqDateTime DATETIME NOT NULL,                                 -- Timestamp of the service request
    ServiceDueDate DATE NOT NULL,                                  -- Due date for the requested service
    PreviousServiceDate DATE NOT NULL                              -- Date of the previous service for the vehicle
);
GO

-- InsuranceLogs Table
CREATE TABLE InsuranceLogs (
    VehicleID INT FOREIGN KEY REFERENCES Vehicle(VehicleID),            -- Foreign key referencing Vehicle table
    InsuranceId INT FOREIGN KEY REFERENCES Insurance(InsuranceId),      -- Foreign key referencing Insurance table
    InsuranceStartDate DATE NOT NULL,                                   -- Start date of the insurance coverage
    InsuranceEndDate DATE NOT NULL                                      -- End date of the insurance coverage
);
GO

-- Create an AFTER INSERT Trigger (Details to be specified based on use case)
-- This trigger will be executed automatically after an INSERT operation on a specific table.
-- It can be customized to perform specific actions or validations.
-- GO is used to terminate the batch and execute the statements.

-- Example Trigger Structure:
-- CREATE TRIGGER [TriggerName]
-- ON [TableName]
-- AFTER INSERT
-- AS
-- BEGIN
--     -- Trigger Logic Here
-- END;
-- GO

-- Indexes
-- Create an index on RideRequest table for faster retrieval of records based on CustomerID
CREATE INDEX idx_CustomerID ON RideRequest(CustomerID);

-- Create an index on RideRequest table for faster retrieval of records based on DriverID
CREATE INDEX idx_DriverID ON RideRequest(DriverID);

-- Create an index on Feedback table for faster retrieval of records based on DriverID
CREATE INDEX idx_DriverID_Feedback ON Feedback(DriverID);

-- Create an index on ServiceRequest table for faster retrieval of records based on VehicleID
CREATE INDEX idx_VehicleID_ServiceRequest ON ServiceRequest(VehicleID);

-- Create an index on InsuranceLogs table for faster retrieval of records based on InsuranceId
CREATE INDEX idx_InsuranceId_InsuranceLogs ON InsuranceLogs(InsuranceId);

-- Create a Master Key for Encryption
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'AmeySatwe23';

-- Create a Certificate to Protect the Master Key
CREATE CERTIFICATE MyCertificate
   WITH SUBJECT = 'My Column Encryption Certificate';

-- Create a Symmetric Key for Column Encryption
CREATE SYMMETRIC KEY MySymmetricKey
   WITH ALGORITHM = AES_256
   ENCRYPTION BY CERTIFICATE MyCertificate;
GO

-- Stored procedure GetDriverStatistics
-- The stored procedure is used to retrieve statistics for a specific driver
CREATE PROCEDURE GetDriverStatistics
    @DriverId INT
AS
BEGIN
    -- Selecting driver details, total trips, average feedback, and latest trip details
    SELECT 
        D.DriverID,                                             -- Driver's unique identifier
        U.UserFName + ' ' + U.UserLName AS DriverName,          -- Concatenating first and last name for a complete name
        COUNT(RR.RequestId) AS TotalTrips,                      -- Count of total trips made by the driver
        AVG(F.Rating) AS AverageFeedbackRating,                 -- Average feedback rating received by the driver (commenting out for now)
        MAX(RR.ReqDateTime) AS LatestTripDateTime,              -- Date and time of the latest trip made by the driver
        MAX(RR.DestinationLocation) AS LatestTripDestination    -- Destination of the latest trip made by the driver
    FROM Driver D
        -- Joining with the User table to get driver's name
        JOIN [User] U ON D.UserID = U.UserID
        -- Left joining with RideRequest to include drivers with no trips
        LEFT JOIN RideRequest RR ON D.DriverID = RR.DriverID
        -- Left joining with Feedback to include drivers with no feedback
        LEFT JOIN Feedback F ON D.DriverID = F.DriverID
    WHERE D.DriverID = @DriverId
    -- Grouping results by driver for aggregate functions
    GROUP BY D.DriverID, U.UserFName, U.UserLName;
END;

-- Execute the GetDriverStatistics stored procedure to retrieve statistics for a specific driver with DriverID = 1
EXEC GetDriverStatistics 1;

-- Stored procedure GetUpcomingServiceRequests
-- The stored procedure is used to retrieve upcoming service requests
CREATE PROCEDURE GetUpcomingServiceRequests
AS
BEGIN
    -- Selecting details for upcoming service requests
    SELECT 
        SR.SerReqId,                                        -- Unique identifier for the service request
        V.VehicleType,                                      -- Type or model of the vehicle
        U.UserFName + ' ' + U.UserLName AS CustomerName,    -- Concatenating first and last name for a complete customer name
        SR.ReqDateTime AS RequestDateTime,                  -- Date and time when the service request was made
        SR.ServiceDueDate AS DueDate,                       -- Due date for the upcoming service
        SR.PreviousServiceDate AS LastServiceDate           -- Date of the previous service for the vehicle
    FROM ServiceRequest SR
        -- Joining with Vehicle table to get vehicle details
        JOIN Vehicle V ON SR.VehicleId = V.VehicleId
        -- Joining with User table to get customer details
        JOIN [User] U ON V.VehicleId = U.UserID
    -- Filtering only upcoming service requests    
    WHERE SR.ServiceDueDate > GETDATE();
END;

-- Execute the GetUpcomingServiceRequests stored procedure to retrieve details for upcoming service requests
EXEC GetUpcomingServiceRequests;

-- Stored procedure spCalculateCustomerLoyaltyDiscount
-- The stored procedure is used to calculate loyalty discount for a customer based on the number of rides in the last year
CREATE PROCEDURE spCalculateCustomerLoyaltyDiscount 
    @CustomerId INT
AS
BEGIN
    -- Declare variables to store the number of rides and the calculated discount percentage
    DECLARE @NumRides INT
    DECLARE @DiscountPercent INT 
    
    -- Count the number of rides for the specified customer in the last year
    SELECT @NumRides = COUNT(*)
    FROM RideRequest r
    INNER JOIN Customer c ON r.CustomerID = c.CustomerID
    WHERE c.CustomerID = @CustomerId
        AND r.ReqDateTime BETWEEN DATEADD(YEAR, -1, GETDATE()) AND GETDATE()
            
    -- Calculate the loyalty discount percentage based on the number of rides
    SET @DiscountPercent = 
        CASE 
            WHEN @NumRides > 10 THEN 20
            WHEN @NumRides BETWEEN 5 AND 10 THEN 10
            ELSE 0
        END
        
    -- Select the customer ID and the calculated loyalty discount percentage
    SELECT @CustomerId AS CustomerId, @DiscountPercent AS LoyaltyDiscountPercentage  
END;

-- Execute the spCalculateCustomerLoyaltyDiscount stored procedure to calculate loyalty discount for a specific customer (CustomerID = 1)
EXEC spCalculateCustomerLoyaltyDiscount 1;

-- Stored procedure DecryptPaymentInfo
-- The stored procedure is used to decrypt payment information for a specific customer
CREATE PROCEDURE DecryptPaymentInfo
    @CustomerID INT   -- Unique identifier for the customer
AS
BEGIN
    -- Open the symmetric key for decryption using the specified certificate
    OPEN SYMMETRIC KEY MySymmetricKey DECRYPTION BY CERTIFICATE MyCertificate;

    -- Select the customer ID and decrypted payment information
    SELECT 
        CustomerID,
        CONVERT(VARCHAR(MAX), DECRYPTBYKEY(EncryptedPaymentInfo)) AS DecryptedPaymentInfo
    FROM 
        Customer
    WHERE 
        CustomerID = @CustomerID;

    -- Close the symmetric key after use
    CLOSE SYMMETRIC KEY MySymmetricKey;
END;

-- UDF ServiceDueinDays
-- The user-defined function to calculate the number of days remaining until a service is due
CREATE FUNCTION ServiceDueinDays
(
    @ReqDateTime DATETIME,    -- Date and time of the service request
    @ServiceDueDate DATETIME   -- Due date for the requested service
)
RETURNS INT
AS
BEGIN
    -- Declare a variable to store the number of days remaining
    DECLARE @NoOfDays INT

    -- Calculate the number of days remaining until the service is due
    SET @NoOfDays = DATEDIFF(DAY, @ServiceDueDate, @ReqDateTime)

    -- Return the calculated number of days
    RETURN @NoOfDays;
END;

-- Using the ServiceDueinDays user-defined function to
-- Select all columns from the ServiceRequest table and calculate the number of days remaining until service is due.
-- Alias the calculated column as "Service due in days"
SELECT 
    sr.*, 
    dbo.ServiceDueinDays(sr.ServiceDueDate, sr.ReqDateTime) AS "Service due in days"
FROM 
    ServiceRequest sr;

-- UDF CustomerCategory
-- The user-defined function to categorize customers based on their age groups
CREATE FUNCTION CustomerCategory
(
    @DateOfBirth DATETIME   -- Date of birth of the customer
)
RETURNS VARCHAR(20)
AS
BEGIN
    -- Declare variables to store the age in years and the customer category
    DECLARE @AgeInYears INT
    DECLARE @Category VARCHAR(20);

    -- Calculate the age of the customer in years
    SET @AgeInYears = DATEDIFF(YEAR, @DateOfBirth, GETDATE());

    -- Categorize the customer based on age
    SELECT @Category = 
        CASE 
            WHEN @AgeInYears < 18 THEN 'Under 18'
            WHEN @AgeInYears BETWEEN 18 AND 25 THEN 'Young Adult'
            WHEN @AgeInYears BETWEEN 26 AND 40 THEN 'Adult'
            WHEN @AgeInYears BETWEEN 41 AND 60 THEN 'Middle Aged'
            ELSE 'Senior Citizen'
        END;

    -- Return the calculated customer category
    RETURN @Category;
END;

-- Using the CustomerCategory user-defined function.
-- Selecting customer details including full name, phone number, date of birth, and categorizing them by age
SELECT 
    u.UserFName + ' ' + u.UserLName AS "Customer Full Name",   -- Concatenating first and last name for the full name
    u.PhoneNumber AS "Customer Phone Number",                  -- Phone number of the customer
    u.DOB AS "Date of Birth",                                  -- Date of birth of the customer
    dbo.CustomerCategory(u.DOB) AS "Customer Category"         -- Categorizing the customer by age using the user-defined function
FROM  Customer c 
JOIN  [User] u ON c.UserID = u.UserID;

-- View to get CustomerRideHistoryView
CREATE VIEW CustomerRideHistoryView AS
    SELECT
        -- Concatenate the user's first name and last name to form the full name
        users.UserFName + ' ' + users.UserLName AS "Customer Full Name",
        
        -- Count the total number of rides for each customer
        COUNT(trip.Cost) AS "Total Rides",
        
        -- Sum the total cost spent on rides for each customer
        SUM(trip.Cost) AS "Total Ride Spend"
        
        -- AVG(trip.Cost) AS "Average Cost per Ride" -- Commented out as not currently used
    FROM
        -- Join the User table to get customer information
        [User] users
        JOIN Customer cust ON users.UserID = cust.CustomerID
        
        -- Left join to include customers who may not have made any ride requests
        LEFT JOIN RideRequest ride ON cust.CustomerID = ride.CustomerID
        
        -- Join the TripEstimate table to get information about each ride
        JOIN TripEstimate trip ON ride.EstimationID = trip.EstimationId
    WHERE
        -- Filter for completed trips (TripCompletionFlag = 1)
        ride.TripCompletionFlag = 1
    GROUP BY
        -- Group the results by customer full name to aggregate information for each customer
        users.UserFName + ' ' + users.UserLName;

-- Retrieve data from the CustomerRideHistoryView
SELECT *
FROM CustomerRideHistoryView
ORDER BY "Total Ride Spend" DESC;

-- View to get ServiceRequest Details
CREATE VIEW ServiceRequestDetailsView AS
    -- Selecting columns from Vehicle, ServiceRequest, and Service tables
    SELECT
        v.VehicleId,
        v.VehicleType,
        s.ServiceDetails,
        s.ServiceName,
        s.ServiceCompanyName
    FROM
        -- Using RIGHT JOIN to include Vehicle records even if there are no matching ServiceRequest records
        Vehicle v
    RIGHT JOIN ServiceRequest sr ON sr.VehicleId = v.VehicleId
    JOIN [Service] s ON sr.ServiceId = s.ServiceId;

-- Retrieve data from the ServiceRequestDetailsView
SELECT *
FROM ServiceRequestDetailsView;

-- View to get CustomerAndVehicle Details
-- Create a view to combine customer and vehicle information for easy retrieval
CREATE VIEW CustomerAndVehicleView AS
SELECT
    C.CustomerId,                                -- Unique identifier for each customer
    U.UserFName+' '+U.UserLName AS CustomerName, -- Concatenating first and last name for the customer's full name
    V.VehicleId,                                 -- Unique identifier for each vehicle
    V.VehicleType,                               -- Type or model of the vehicle
    V.ServiceInfo AS VehicleServiceInfo          -- Information about the vehicle's service history
FROM
    Customer C
JOIN
    [User] U ON C.UserID = U.UserID              -- Joining with the User table to get customer details
JOIN
    Vehicle V ON C.CustomerId = V.VehicleId;     -- Joining with the Vehicle table to get vehicle details

-- Retrieve data from the CREATE VIEW CustomerAndVehicleView
SELECT *
FROM CustomerAndVehicleView;

-- View to get VehicleRequested Details
-- Create a view to display vehicle statistics, specifically the count of requested vehicles
CREATE VIEW VehicleRequestedView AS
SELECT 
    v.VehicleType,                                -- Type or model of the vehicle
    COUNT(nrr.VehicleID) AS "Count of Vehicle Requested"  -- Count of vehicles requested (completed trips)
FROM 
    Vehicle v
LEFT JOIN 
    (SELECT r.* FROM RideRequest r WHERE r.TripCompletionFlag = 1) nrr 
    ON v.VehicleId = nrr.VehicleID
GROUP BY 
    v.VehicleType;

-- Retrieve data from the CREATE VIEW VehicleRequestedView
SELECT *
FROM VehicleRequestedView;

/* Delete all the data from all the tables */
-- Delete all data from the RideRequest table
DELETE FROM RideRequest;

-- Delete all data from the Feedback table
DELETE FROM Feedback;

-- Delete all data from the Driver table
DELETE FROM Driver;

-- Delete all data from the ServiceRequest table
DELETE FROM ServiceRequest;

-- Delete all data from the InsuranceLogs table
DELETE FROM InsuranceLogs;

-- Delete all data from the TripEstimate table
DELETE FROM TripEstimate;

-- Delete all data from the Customer table
DELETE FROM Customer;

-- Delete all data from the [User] table
DELETE FROM [User];

-- Delete all data from the Vehicle table
DELETE FROM Vehicle;

-- Delete all data from the Insurance table
DELETE FROM Insurance;

-- Delete all data from the Service table
DELETE FROM Service;


/* INSERT STATEMENTS */

-- Inserting Data in Service Table
INSERT INTO Service (ServiceId, ServiceCompanyName, ServiceName, ServiceDetails)
VALUES
    (1, 'Express Oil Change', 'Express Oil Change', 'Scheduled maintenance and inspection'),
    (2, 'Coolant Experts', 'Interior Detailing', 'Quick oil change with minimal waiting time'),
    (3, 'Sunshine Detailing', 'Oil Change', 'Thorough inspection of transmission components'),
    (4, 'Brake Master', 'Express Oil Change', 'Replacement of worn-out brake components'),
    (5, 'Electro Tune', 'Coolant Flush', 'Exterior and interior cleaning services'),
    (6, 'Speedy Repairs', 'Coolant Flush', 'Thorough inspection of transmission components'),
    (7, 'QuickOil', 'Oil Change', 'Thorough inspection of transmission components'),
    (8, 'Express Oil Change', 'Oil Change', 'Scheduled maintenance and inspection'),
    (9, 'XYZ Repairs', 'Electrical System Check', 'Replacement of worn-out brake components'),
    (10, 'Brake Master', 'Brake Replacement', 'Scheduled maintenance and inspection'),
    (11, 'XYZ Repairs', 'Oil Change', 'Scheduled maintenance and inspection'),
    (12, 'ABC Service Company', 'Car Wash', 'Exterior and interior cleaning services'),
    (13, 'XYZ Repairs', 'Express Oil Change', 'Quick oil change with minimal waiting time'),
    (14, 'Speedy Repairs', 'Regular Maintenance', 'Detailed inspection of brake system'),
    (15, 'Electro Tune', 'Interior Detailing', 'Fast and efficient oil change service'),
    (16, 'Electro Tune', 'Regular Maintenance', 'Scheduled maintenance and inspection'),
    (17, 'Express Oil Change', 'Electrical System Check', 'Scheduled maintenance and inspection'),
    (18, 'Coolant Experts', 'Transmission Check', 'Check and repair electrical components'),
    (19, 'Brake Master', 'Brake Replacement', 'Deep cleaning of the vehicle interior'),
    (20, 'Electro Tune', 'Regular Maintenance', 'Professional coolant system flushing'),
    (21, 'Brake Master', 'Car Wash', 'Fast and efficient oil change service'),
    (22, 'Sunshine Detailing', 'Brake Replacement', 'Fast and efficient oil change service'),
    (23, 'QuickOil', 'Car Wash', 'Scheduled maintenance and inspection'),
    (24, 'XYZ Repairs', 'Regular Maintenance', 'Check and repair electrical components'),
    (25, 'Speedy Repairs', 'Coolant Flush', 'Replacement of worn-out brake components'),
    (26, 'Sunshine Detailing', 'Car Wash', 'Professional coolant system flushing'),
    (27, 'Coolant Experts', 'Oil Change', 'Detailed inspection of brake system'),
    (28, 'Speedy Repairs', 'Transmission Check', 'Check and repair electrical components'),
    (29, 'Brake Master', 'Transmission Check', 'Scheduled maintenance and inspection'),
    (30, 'Speedy Repairs', 'Electrical System Check', 'Scheduled maintenance and inspection'),
    (31, 'Express Oil Change', 'Coolant Flush', 'Fast and efficient oil change service'),
    (32, 'Speedy Repairs', 'Car Wash', 'Check and repair electrical components'),
    (33, 'ABC Service Company', 'Regular Maintenance', 'Replacement of worn-out brake components'),
    (34, 'Electro Tune', 'Car Wash', 'Replacement of worn-out brake components'),
    (35, 'Brake Master', 'Brake Inspection', 'Deep cleaning of the vehicle interior'),
    (36, 'QuickOil', 'Regular Maintenance', 'Thorough inspection of transmission components'),
    (37, 'ABC Service Company', 'Car Wash', 'Fast and efficient oil change service'),
    (38, 'Sunshine Detailing', 'Interior Detailing', 'Replacement of worn-out brake components'),
    (39, 'Electro Tune', 'Brake Inspection', 'Replacement of worn-out brake components'),
    (40, 'ABC Service Company', 'Transmission Check', 'Detailed inspection of brake system'),
    (41, 'Brake Master', 'Oil Change', 'Replacement of worn-out brake components'),
    (42, 'Coolant Experts', 'Coolant Flush', 'Deep cleaning of the vehicle interior'),
    (43, 'Express Oil Change', 'Coolant Flush', 'Deep cleaning of the vehicle interior'),
    (44, 'ABC Service Company', 'Interior Detailing', 'Exterior and interior cleaning services'),
    (45, 'XYZ Repairs', 'Electrical System Check', 'Deep cleaning of the vehicle interior'),
    (46, 'Sunshine Detailing', 'Brake Inspection', 'Thorough inspection of transmission components'),
    (47, 'Sparkle Wash', 'Interior Detailing', 'Fast and efficient oil change service'),
    (48, 'Coolant Experts', 'Coolant Flush', 'Fast and efficient oil change service'),
    (49, 'QuickOil', 'Express Oil Change', 'Thorough inspection of transmission components'),
    (50, 'ABC Service Company', 'Transmission Check', 'Fast and efficient oil change service'),
    (51, 'Coolant Experts', 'Regular Maintenance', 'Fast and efficient oil change service'),
    (52, 'ABC Service Company', 'Car Wash', 'Exterior and interior cleaning services'),
    (53, 'Coolant Experts', 'Brake Inspection', 'Check and repair electrical components'),
    (54, 'Coolant Experts', 'Oil Change', 'Replacement of worn-out brake components'),
    (55, 'Sparkle Wash', 'Brake Inspection', 'Scheduled maintenance and inspection'),
    (56, 'Coolant Experts', 'Brake Inspection', 'Thorough inspection of transmission components'),
    (57, 'QuickOil', 'Express Oil Change', 'Replacement of worn-out brake components'),
    (58, 'Coolant Experts', 'Oil Change', 'Professional coolant system flushing'),
    (59, 'Electro Tune', 'Express Oil Change', 'Replacement of worn-out brake components'),
    (60, 'Sparkle Wash', 'Regular Maintenance', 'Quick oil change with minimal waiting time'),
    (61, 'Sunshine Detailing', 'Transmission Check', 'Replacement of worn-out brake components'),
    (62, 'Coolant Experts', 'Express Oil Change', 'Exterior and interior cleaning services'),
    (63, 'ABC Service Company', 'Express Oil Change', 'Detailed inspection of brake system'),
    (64, 'QuickOil', 'Coolant Flush', 'Fast and efficient oil change service'),
    (65, 'Sparkle Wash', 'Brake Replacement', 'Scheduled maintenance and inspection'),
    (66, 'Express Oil Change', 'Interior Detailing', 'Quick oil change with minimal waiting time'),
    (67, 'XYZ Repairs', 'Electrical System Check', 'Thorough inspection of transmission components'),
    (68, 'Electro Tune', 'Regular Maintenance', 'Quick oil change with minimal waiting time'),
    (69, 'XYZ Repairs', 'Brake Replacement', 'Fast and efficient oil change service'),
    (70, 'Express Oil Change', 'Regular Maintenance', 'Exterior and interior cleaning services'),
    (71, 'ABC Service Company', 'Brake Replacement', 'Quick oil change with minimal waiting time'),
    (72, 'ABC Service Company', 'Express Oil Change', 'Replacement of worn-out brake components'),
    (73, 'Brake Master', 'Brake Inspection', 'Professional coolant system flushing'),
    (74, 'XYZ Repairs', 'Coolant Flush', 'Scheduled maintenance and inspection'),
    (75, 'Coolant Experts', 'Oil Change', 'Detailed inspection of brake system'),
    (76, 'Electro Tune', 'Electrical System Check', 'Professional coolant system flushing'),
    (77, 'ABC Service Company', 'Brake Replacement', 'Scheduled maintenance and inspection'),
    (78, 'Coolant Experts', 'Brake Inspection', 'Professional coolant system flushing'),
    (79, 'QuickOil', 'Car Wash', 'Exterior and interior cleaning services'),
    (80, 'QuickOil', 'Electrical System Check', 'Exterior and interior cleaning services'),
    (81, 'ABC Service Company', 'Oil Change', 'Deep cleaning of the vehicle interior'),
    (82, 'Sunshine Detailing', 'Regular Maintenance', 'Professional coolant system flushing'),
    (83, 'Express Oil Change', 'Oil Change', 'Exterior and interior cleaning services'),
    (84, 'Speedy Repairs', 'Oil Change', 'Deep cleaning of the vehicle interior'),
    (85, 'XYZ Repairs', 'Transmission Check', 'Exterior and interior cleaning services'),
    (86, 'Sparkle Wash', 'Interior Detailing', 'Deep cleaning of the vehicle interior'),
    (87, 'QuickOil', 'Regular Maintenance', 'Detailed inspection of brake system'),
    (88, 'QuickOil', 'Interior Detailing', 'Scheduled maintenance and inspection'),
    (89, 'QuickOil', 'Oil Change', 'Deep cleaning of the vehicle interior'),
    (90, 'Electro Tune', 'Interior Detailing', 'Fast and efficient oil change service'),
    (91, 'XYZ Repairs', 'Interior Detailing', 'Deep cleaning of the vehicle interior'),
    (92, 'Electro Tune', 'Interior Detailing', 'Thorough inspection of transmission components'),
    (93, 'Speedy Repairs', 'Interior Detailing', 'Replacement of worn-out brake components'),
    (94, 'Sunshine Detailing', 'Electrical System Check', 'Replacement of worn-out brake components'),
    (95, 'QuickOil', 'Interior Detailing', 'Thorough inspection of transmission components'),
    (96, 'XYZ Repairs', 'Express Oil Change', 'Deep cleaning of the vehicle interior'),
    (97, 'Express Oil Change', 'Express Oil Change', 'Detailed inspection of brake system'),
    (98, 'ABC Service Company', 'Brake Inspection', 'Detailed inspection of brake system'),
    (99, 'QuickOil', 'Regular Maintenance', 'Exterior and interior cleaning services'),
    (100, 'QuickOil', 'Brake Inspection', 'Scheduled maintenance and inspection');

-- Inserting Data in Insurance Table
INSERT INTO Insurance (InsuranceId, InsuranceProvider, InsuranceCoverage, InsurancePremium, InsuranceDeductible)
VALUES
    (1, 'FastCover Insurance', 'Full Coverage', 697, 36),
    (2, 'XYZ Insurance', 'Liability Coverage', 417, 37),
    (3, 'Guardian Insurers', 'Comprehensive Coverage', 547, 32),
    (4, 'SureSafety Insurance', 'Roadside Assistance', 861, 96),
    (5, 'Guardian Insurers', 'Full Coverage', 303, 14),
    (6, 'Shield Protect', 'Liability Coverage', 676, 67),
    (7, 'SecureRide Insurance', 'Medical Payments Coverage', 635, 39),
    (8, 'Guardian Shield', 'Liability Coverage', 669, 69),
    (9, 'Swift Assurance', 'Comprehensive Coverage', 104, 87),
    (10, 'Swift Assurance', 'Personal Injury Protection', 956, 72),
    (11, 'Guardian Insurers', 'Medical Payments Coverage', 421, 78),
    (12, 'Guardian Insurers', 'Full Coverage', 845, 25),
    (13, 'Shield Protect', 'Full Coverage', 915, 51),
    (14, 'XYZ Insurance', 'Full Coverage', 987, 19),
    (15, 'XYZ Insurance', 'Liability Coverage', 782, 58),
    (16, 'FastCover Insurance', 'Personal Injury Protection', 595, 35),
    (17, 'Shield Protect', 'Collision Coverage', 283, 62),
    (18, 'FastCover Insurance', 'Uninsured Motorist Coverage', 839, 61),
    (19, 'SafeDrive Assurance', 'Medical Payments Coverage', 579, 60),
    (20, 'Swift Assurance', 'Roadside Assistance', 244, 68),
    (21, 'FastCover Insurance', 'Medical Payments Coverage', 503, 19),
    (22, 'Guardian Shield', 'Collision Coverage', 997, 64),
    (23, 'FastCover Insurance', 'Roadside Assistance', 135, 66),
    (24, 'SafeDrive Assurance', 'Personal Injury Protection', 158, 87),
    (25, 'SafeDrive Assurance', 'Rental Car Coverage', 160, 11),
    (26, 'SecureRide Insurance', 'Personal Injury Protection', 491, 79),
    (27, 'Swift Assurance', 'Rental Car Coverage', 671, 72),
    (28, 'Shield Protect', 'Full Coverage', 374, 76),
    (29, 'Guardian Insurers', 'Rental Car Coverage', 610, 87),
    (30, 'Swift Assurance', 'Liability Coverage', 957, 33),
    (31, 'XYZ Insurance', 'Liability Coverage', 397, 56),
    (32, 'SafeDrive Assurance', 'Collision Coverage', 233, 96),
    (33, 'TotalProtect Insurers', 'Personal Injury Protection', 486, 30),
    (34, 'Guardian Insurers', 'Uninsured Motorist Coverage', 273, 36),
    (35, 'TotalProtect Insurers', 'Full Coverage', 280, 65),
    (36, 'SureSafety Insurance', 'Full Coverage', 208, 98),
    (37, 'Guardian Shield', 'Collision Coverage', 807, 64),
    (38, 'SafeDrive Assurance', 'Uninsured Motorist Coverage', 803, 83),
    (39, 'TotalProtect Insurers', 'Uninsured Motorist Coverage', 855, 100),
    (40, 'SafeDrive Assurance', 'Full Coverage', 676, 98),
    (41, 'FastCover Insurance', 'Collision Coverage', 453, 62),
    (42, 'SureSafety Insurance', 'Rental Car Coverage', 169, 20),
    (43, 'SecureRide Insurance', 'Rental Car Coverage', 224, 21),
    (44, 'FastCover Insurance', 'Comprehensive Coverage', 370, 49),
    (45, 'FastCover Insurance', 'Medical Payments Coverage', 610, 47),
    (46, 'Swift Assurance', 'Full Coverage', 894, 95),
    (47, 'XYZ Insurance', 'Collision Coverage', 151, 33),
    (48, 'FastCover Insurance', 'Full Coverage', 650, 23),
    (49, 'Shield Protect', 'Medical Payments Coverage', 198, 69),
    (50, 'TotalProtect Insurers', 'Comprehensive Coverage', 739, 59),
    (51, 'XYZ Insurance', 'Liability Coverage', 285, 85),
    (52, 'SureSafety Insurance', 'Underinsured Motorist Coverage', 524, 14),
    (53, 'SafeDrive Assurance', 'Roadside Assistance', 665, 27),
    (54, 'XYZ Insurance', 'Liability Coverage', 712, 94),
    (55, 'Shield Protect', 'Comprehensive Coverage', 341, 53),
    (56, 'TotalProtect Insurers', 'Collision Coverage', 371, 51),
    (57, 'TotalProtect Insurers', 'Uninsured Motorist Coverage', 814, 63),
    (58, 'Guardian Shield', 'Full Coverage', 464, 84),
    (59, 'Swift Assurance', 'Liability Coverage', 541, 73),
    (60, 'XYZ Insurance', 'Liability Coverage', 709, 16),
    (61, 'SafeDrive Assurance', 'Medical Payments Coverage', 190, 89),
    (62, 'XYZ Insurance', 'Rental Car Coverage', 208, 48),
    (63, 'XYZ Insurance', 'Collision Coverage', 753, 55),
    (64, 'SafeDrive Assurance', 'Roadside Assistance', 751, 85),
    (65, 'SafeDrive Assurance', 'Full Coverage', 530, 62),
    (66, 'Swift Assurance', 'Personal Injury Protection', 360, 11),
    (67, 'FastCover Insurance', 'Uninsured Motorist Coverage', 557, 40),
    (68, 'Guardian Shield', 'Collision Coverage', 114, 44),
    (69, 'Swift Assurance', 'Underinsured Motorist Coverage', 705, 86),
    (70, 'SureSafety Insurance', 'Uninsured Motorist Coverage', 265, 33),
    (71, 'FastCover Insurance', 'Roadside Assistance', 171, 35),
    (72, 'Guardian Shield', 'Rental Car Coverage', 607, 14),
    (73, 'XYZ Insurance', 'Personal Injury Protection', 934, 68),
    (74, 'SureSafety Insurance', 'Collision Coverage', 338, 54),
    (75, 'TotalProtect Insurers', 'Collision Coverage', 840, 70),
    (76, 'XYZ Insurance', 'Full Coverage', 139, 44),
    (77, 'Shield Protect', 'Collision Coverage', 681, 35),
    (78, 'SecureRide Insurance', 'Medical Payments Coverage', 641, 96),
    (79, 'XYZ Insurance', 'Medical Payments Coverage', 507, 67),
    (80, 'Shield Protect', 'Uninsured Motorist Coverage', 254, 45),
    (81, 'XYZ Insurance', 'Medical Payments Coverage', 612, 18),
    (82, 'XYZ Insurance', 'Roadside Assistance', 423, 79),
    (83, 'XYZ Insurance', 'Liability Coverage', 570, 13),
    (84, 'Guardian Shield', 'Roadside Assistance', 517, 34),
    (85, 'SafeDrive Assurance', 'Personal Injury Protection', 182, 52),
    (86, 'Shield Protect', 'Roadside Assistance', 326, 21),
    (87, 'Guardian Insurers', 'Liability Coverage', 579, 45),
    (88, 'Guardian Shield', 'Personal Injury Protection', 715, 45),
    (89, 'Swift Assurance', 'Medical Payments Coverage', 625, 23),
    (90, 'Shield Protect', 'Full Coverage', 194, 68),
    (91, 'Guardian Insurers', 'Collision Coverage', 481, 71),
    (92, 'Guardian Shield', 'Uninsured Motorist Coverage', 787, 71),
    (93, 'Swift Assurance', 'Liability Coverage', 632, 41),
    (94, 'XYZ Insurance', 'Personal Injury Protection', 172, 71),
    (95, 'Swift Assurance', 'Personal Injury Protection', 434, 38),
    (96, 'FastCover Insurance', 'Roadside Assistance', 329, 39),
    (97, 'SecureRide Insurance', 'Rental Car Coverage', 693, 42),
    (98, 'SafeDrive Assurance', 'Liability Coverage', 503, 30),
    (99, 'Shield Protect', 'Comprehensive Coverage', 684, 18),
    (100, 'SafeDrive Assurance', 'Rental Car Coverage', 659, 73);

-- Inserting Data in Vehicle Table
INSERT INTO Vehicle (VehicleId, VehicleType, ServiceInfo, InsuranceInfo)
VALUES
    (1, 'Electric Car', 'Family-friendly model', 'YES'),
    (2, 'Hatchback', 'Fuel-efficient model', 'NO'),
    (3, 'Compact', 'Luxury vehicle maintenance', 'YES'),
    (4, 'Electric Car', 'Specialized care', 'NO'),
    (5, 'Hatchback', 'Heavy-duty maintenance', 'YES'),
    (6, 'Convertible', 'Family-friendly model', 'NO'),
    (7, 'Truck', 'Regularly serviced', 'YES'),
    (8, 'Limousine', 'Regularly serviced', 'NO'),
    (9, 'Convertible', 'Fuel-efficient model', 'YES'),
    (10, 'Motorcycle', 'Fuel-efficient model', 'NO'),
    (11, 'Compact', 'Heavy-duty maintenance', 'YES'),
    (12, 'Limousine', 'Heavy-duty maintenance', 'NO'),
    (13, 'Electric Car', 'Luxury vehicle maintenance', 'YES'),
    (14, 'Sedan', 'Monthly check-ups', 'NO'),
    (15, 'Hatchback', 'Heavy-duty maintenance', 'YES'),
    (16, 'Compact', 'Heavy-duty maintenance', 'NO'),
    (17, 'Limousine', 'Battery system inspection', 'YES'),
    (18, 'Hatchback', 'Specialized care', 'NO'),
    (19, 'Truck', 'Battery system inspection', 'YES'),
    (20, 'Compact', 'Specialized care', 'NO'),
    (21, 'Motorcycle', 'Specialized care', 'YES'),
    (22, 'Limousine', 'Specialized care', 'NO'),
    (23, 'Truck', 'Fuel-efficient model', 'YES'),
    (24, 'Limousine', 'Bi-annual check-ups', 'NO'),
    (25, 'Limousine', 'Bi-annual check-ups', 'YES'),
    (26, 'Motorcycle', 'Specialized care', 'NO'),
    (27, 'Hatchback', 'Family-friendly model', 'YES'),
    (28, 'Minivan', 'Bi-annual check-ups', 'NO'),
    (29, 'Convertible', 'Battery system inspection', 'YES'),
    (30, 'Electric Car', 'Family-friendly model', 'NO'),
    (31, 'Sedan', 'Battery system inspection', 'YES'),
    (32, 'SUV', 'Heavy-duty maintenance', 'NO'),
    (33, 'SUV', 'Luxury vehicle maintenance', 'YES'),
    (34, 'Compact', 'Heavy-duty maintenance', 'NO'),
    (35, 'Minivan', 'Specialized care', 'YES'),
    (36, 'Convertible', 'Monthly check-ups', 'NO'),
    (37, 'Sedan', 'Specialized care', 'YES'),
    (38, 'Convertible', 'Regularly serviced', 'NO'),
    (39, 'Limousine', 'Regularly serviced', 'YES'),
    (40, 'SUV', 'Heavy-duty maintenance', 'NO'),
    (41, 'Convertible', 'Luxury vehicle maintenance', 'YES'),
    (42, 'Motorcycle', 'Regularly serviced', 'NO'),
    (43, 'Minivan', 'Specialized care', 'YES'),
    (44, 'Sedan', 'Specialized care', 'NO'),
    (45, 'Electric Car', 'Bi-annual check-ups', 'YES'),
    (46, 'Hatchback', 'Heavy-duty maintenance', 'NO'),
    (47, 'Convertible', 'Bi-annual check-ups', 'YES'),
    (48, 'Minivan', 'Specialized care', 'NO'),
    (49, 'Sedan', 'Bi-annual check-ups', 'YES'),
    (50, 'Convertible', 'Heavy-duty maintenance', 'NO'),
    (51, 'SUV', 'Battery system inspection', 'YES'),
    (52, 'Limousine', 'Battery system inspection', 'NO'),
    (53, 'Motorcycle', 'Fuel-efficient model', 'YES'),
    (54, 'Limousine', 'Regularly serviced', 'NO'),
    (55, 'Limousine', 'Monthly check-ups', 'YES'),
    (56, 'Sedan', 'Battery system inspection', 'NO'),
    (57, 'Sedan', 'Battery system inspection', 'YES'),
    (58, 'SUV', 'Luxury vehicle maintenance', 'NO'),
    (59, 'Motorcycle', 'Monthly check-ups', 'YES'),
    (60, 'Truck', 'Monthly check-ups', 'NO'),
    (61, 'Motorcycle', 'Bi-annual check-ups', 'YES'),
    (62, 'Hatchback', 'Specialized care', 'NO'),
    (63, 'Truck', 'Specialized care', 'YES'),
    (64, 'Hatchback', 'Bi-annual check-ups', 'NO'),
    (65, 'Truck', 'Family-friendly model', 'YES'),
    (66, 'Limousine', 'Battery system inspection', 'NO'),
    (67, 'Minivan', 'Luxury vehicle maintenance', 'YES'),
    (68, 'SUV', 'Monthly check-ups', 'NO'),
    (69, 'Motorcycle', 'Specialized care', 'YES'),
    (70, 'Hatchback', 'Regularly serviced', 'NO'),
    (71, 'SUV', 'Monthly check-ups', 'YES'),
    (72, 'Motorcycle', 'Luxury vehicle maintenance', 'NO'),
    (73, 'Sedan', 'Regularly serviced', 'YES'),
    (74, 'Electric Car', 'Fuel-efficient model', 'NO'),
    (75, 'Truck', 'Specialized care', 'YES'),
    (76, 'Limousine', 'Luxury vehicle maintenance', 'NO'),
    (77, 'Truck', 'Luxury vehicle maintenance', 'YES'),
    (78, 'Compact', 'Specialized care', 'NO'),
    (79, 'Sedan', 'Battery system inspection', 'YES'),
    (80, 'Minivan', 'Specialized care', 'NO'),
    (81, 'SUV', 'Luxury vehicle maintenance', 'YES'),
    (82, 'Electric Car', 'Specialized care', 'NO'),
    (83, 'Truck', 'Regularly serviced', 'YES'),
    (84, 'SUV', 'Luxury vehicle maintenance', 'NO'),
    (85, 'Limousine', 'Specialized care', 'YES'),
    (86, 'Electric Car', 'Battery system inspection', 'NO'),
    (87, 'Minivan', 'Fuel-efficient model', 'YES'),
    (88, 'Limousine', 'Specialized care', 'NO'),
    (89, 'Hatchback', 'Bi-annual check-ups', 'YES'),
    (90, 'Minivan', 'Specialized care', 'NO'),
    (91, 'Hatchback', 'Regularly serviced', 'YES'),
    (92, 'SUV', 'Bi-annual check-ups', 'NO'),
    (93, 'Truck', 'Specialized care', 'YES'),
    (94, 'Truck', 'Heavy-duty maintenance', 'NO'),
    (95, 'Minivan', 'Family-friendly model', 'YES'),
    (96, 'Sedan', 'Specialized care', 'NO'),
    (97, 'Limousine', 'Specialized care', 'YES'),
    (98, 'Motorcycle', 'Battery system inspection', 'NO'),
    (99, 'SUV', 'Regularly serviced', 'YES'),
    (100, 'Compact', 'Monthly check-ups', 'NO');

-- Inserting Data in [User] Table
INSERT INTO [User] (UserID, UserFName, UserLName, PhoneNumber, EmailId, DOB, BankAccInfo, UserType)
VALUES    (1, 'Jonis', 'Conyers', '383-180-6352', 'jconyers0@google.ca', '11/14/2005', 'Bank XXXX-XXXX-XXXX', 'D'),
    (2, 'Karylin', 'Furminger', '291-920-3229', 'kfurminger1@shop-pro.jp', '2/11/2019', 'Bank GGGG-9876-5432', 'C'),
    (3, 'Jaime', 'McKennan', '250-495-3365', 'jmckennan2@admin.ch', '7/31/2006', 'Bank ABCD-1234-5678', 'D'),
    (4, 'Morton', 'Ballinghall', '948-572-4150', 'mballinghall3@vinaora.com', '4/9/2008', 'Bank GGGG-9876-5432', 'D'),
    (5, 'Noemi', 'Ayars', '964-860-7680', 'nayars4@yale.edu', '9/2/2013', 'Bank XXXX-XXXX-XXXX', 'D'),
    (6, 'Vergil', 'Greatbank', '679-279-7753', 'vgreatbank5@techcrunch.com', null, 'Bank IIII-2345-6789', 'D'),
    (7, 'Essa', 'Wabersinke', '949-724-7902', 'ewabersinke6@intel.com', '8/23/2016', 'Bank FFFF-1234-5678', 'C'),
    (8, 'Nicol', 'Simonel', '230-998-8985', 'nsimonel7@gnu.org', '12/9/2013', 'Bank GGGG-9876-5432', 'C'),
    (9, 'Laural', 'Cushworth', '240-498-1880', 'lcushworth8@360.cn', '4/18/2010', 'Bank YYYY-YYYY-YYYY', 'D'),
    (10, 'Kyle', 'Willatts', '408-503-8443', 'kwillatts9@hao123.com', '10/4/2008', 'Bank GGGG-9876-5432', 'D'),
    (11, 'Wallas', 'Baggally', '121-796-5500', 'wbaggallya@marriott.com', '1/14/2016', 'Bank YYYY-YYYY-YYYY', 'D'),
    (12, 'Jorie', 'Stanway', '828-213-5454', 'jstanwayb@howstuffworks.com', '4/4/2009', 'Bank ABCD-1234-5678', 'C'),
    (13, 'Agnola', 'Labrom', '157-102-0310', 'alabromc@gizmodo.com', '10/19/2001', 'Bank XXXX-XXXX-XXXX', 'C'),
    (14, 'Vernen', 'Belfit', '354-166-0503', 'vbelfitd@nbcnews.com', '2/21/2007', 'Bank WXYZ-5678-9012', 'C'),
    (15, 'Kristofor', 'Mantz', '978-613-2653', 'kmantze@so-net.ne.jp', '6/28/2011', 'Bank YYYY-YYYY-YYYY', 'C'),
    (16, 'Jerrine', 'Fiske', '400-705-8312', 'jfiskef@home.pl', null, 'Bank FFFF-1234-5678', 'C'),
    (17, 'Clem', 'Purves', '272-896-2718', 'cpurvesg@godaddy.com', '8/1/2013', 'Bank FFFF-1234-5678', 'D'),
    (18, 'Letitia', 'Drewry', '124-925-0849', 'ldrewryh@cloudflare.com', null, 'Bank IIII-2345-6789', 'C'),
    (19, 'Giacopo', 'Khan', '108-748-3938', 'gkhani@google.com', '10/12/2008', 'Bank XXXX-XXXX-XXXX', 'D'),
    (20, 'Nickie', 'Cokly', '600-893-2617', 'ncoklyj@ask.com', '11/5/2003', 'Bank FFFF-1234-5678', 'C'),
    (21, 'Gwenore', 'Messum', '635-473-3417', 'gmessumk@google.ru', '3/25/2008', 'Bank XXXX-XXXX-XXXX', 'C'),
    (22, 'Leonanie', 'Naisbit', '198-616-2063', 'lnaisbitl@sun.com', null, 'Bank YYYY-YYYY-YYYY', 'D'),
    (23, 'Madge', 'Hodjetts', '719-614-0884', 'mhodjettsm@ebay.co.uk', '1/26/2014', 'Bank GGGG-9876-5432', 'C'),
    (24, 'Marilyn', 'Brooks', '447-650-0471', 'mbrooksn@blogs.com', '7/3/2009', 'Bank FFFF-1234-5678', 'C'),
    (25, 'Archibald', 'Baldry', '864-843-8518', 'abaldryo@home.pl', '4/6/2011', 'Bank EEEE-5678-9012', 'D'),
    (26, 'Nissa', 'Lewington', '433-409-3087', 'nlewingtonp@google.ru', null, 'Bank WXYZ-5678-9012', 'C'),
    (27, 'Lois', 'Pashen', '420-546-4786', 'lpashenq@tmall.com', null, 'Bank XXXX-XXXX-XXXX', 'D'),
    (28, 'Clayson', 'Youde', '860-853-7337', 'cyouder@hc360.com', '9/23/2012', 'Bank FFFF-1234-5678', 'D'),
    (29, 'Jacquelynn', 'Acres', '421-523-9954', 'jacress@tinyurl.com', '7/28/2020', 'Bank XXXX-XXXX-XXXX', 'C'),
    (30, 'Taylor', 'Themann', '122-598-8251', 'tthemannt@surveymonkey.com', '11/16/2019', 'Bank WXYZ-5678-9012', 'D'),
    (31, 'Elle', 'Minithorpe', '651-985-2473', 'eminithorpeu@amazon.co.jp', '12/23/2004', 'Bank GGGG-9876-5432', 'C'),
    (32, 'Aland', 'Bhar', '644-483-1668', 'abharv@adobe.com', '6/23/2022', 'Bank YYYY-YYYY-YYYY', 'D'),
    (33, 'Carolus', 'Holbarrow', '812-812-2386', 'cholbarroww@patch.com', '3/19/2000', 'Bank EEEE-5678-9012', 'C'),
    (34, 'Vallie', 'Douch', '799-519-1142', 'vdouchx@army.mil', null, 'Bank EEEE-5678-9012', 'C'),
    (35, 'Lyssa', 'Seven', '436-524-3618', 'lseveny@timesonline.co.uk', '12/18/2018', 'Bank WXYZ-5678-9012', 'C'),
    (36, 'Dee', 'Howsan', '449-395-0015', 'dhowsanz@hatena.ne.jp', '1/17/2008', 'Bank EEEE-5678-9012', 'C'),
    (37, 'Beilul', 'Dorot', '806-850-2671', 'bdorot10@wordpress.org', '5/24/2014', 'Bank YYYY-YYYY-YYYY', 'D'),
    (38, 'Dur', 'MacRedmond', '968-504-7583', 'dmacredmond11@freewebs.com', null, 'Bank YYYY-YYYY-YYYY', 'D'),
    (39, 'Natty', 'Sellan', '936-455-5579', 'nsellan12@opera.com', null, 'Bank HHHH-3456-7890', 'C'),
    (40, 'Charisse', 'McGuigan', '421-456-4990', 'cmcguigan13@addthis.com', '4/9/2011', 'Bank GGGG-9876-5432', 'C'),
    (41, 'Nadiya', 'Ciccotto', '173-495-9294', 'nciccotto14@chronoengine.com', '6/24/2017', 'Bank HHHH-3456-7890', 'D'),
    (42, 'Giralda', 'Flintoft', '783-699-8263', 'gflintoft15@amazon.co.uk', null, 'Bank IIII-2345-6789', 'C'),
    (43, 'Thor', 'Guidini', '588-348-5164', 'tguidini16@businesswire.com', '12/17/2010', 'Bank GGGG-9876-5432', 'D'),
    (44, 'Berrie', 'McCroft', '307-553-4702', 'bmccroft17@huffingtonpost.com', '12/4/2005', 'Bank EEEE-5678-9012', 'D'),
    (45, 'Lezley', 'Clemenceau', '140-862-1804', 'lclemenceau18@nhs.uk', '10/31/2013', 'Bank YYYY-YYYY-YYYY', 'D'),
    (46, 'Jermain', 'Reimer', '726-226-9139', 'jreimer19@desdev.cn', '2/21/2012', 'Bank EEEE-5678-9012', 'C'),
    (47, 'Nataline', 'Swatton', '647-738-7630', 'nswatton1a@is.gd', '11/18/2012', 'Bank EEEE-5678-9012', 'D'),
    (48, 'Saunder', 'Hayhurst', '101-250-4833', 'shayhurst1b@flickr.com', '12/4/2017', 'Bank GGGG-9876-5432', 'C'),
    (49, 'Gibbie', 'Cawdery', '716-801-7581', 'gcawdery1c@ycombinator.com', null, 'Bank YYYY-YYYY-YYYY', 'C'),
    (50, 'Vitia', 'Pennick', '851-427-0355', 'vpennick1d@cdbaby.com', '5/9/2005', 'Bank XXXX-XXXX-XXXX', 'C'),
    (51, 'Constantin', 'Cleen', '824-273-9789', 'ccleen1e@live.com', '12/7/2008', 'Bank XXXX-XXXX-XXXX', 'C'),
    (52, 'Gayel', 'Landman', '449-799-6246', 'glandman1f@discovery.com', '11/25/2014', 'Bank WXYZ-5678-9012', 'C'),
    (53, 'Hilario', 'Sargent', '355-660-4831', 'hsargent1g@twitter.com', '3/2/2003', 'Bank WXYZ-5678-9012', 'C'),
    (54, 'Alexandrina', 'Petroulis', '585-897-6439', 'apetroulis1h@theglobeandmail.com', '2/1/2007', 'Bank ABCD-1234-5678', 'D'),
    (55, 'Marty', 'Pimblott', '921-878-7585', 'mpimblott1i@usda.gov', '4/17/2009', 'Bank ZZZZ-ZZZZ-ZZZZ', 'D'),
    (56, 'Alli', 'Carabet', '962-470-8639', 'acarabet1j@amazon.co.uk', '5/29/2008', 'Bank ZZZZ-ZZZZ-ZZZZ', 'C'),
    (57, 'Stanislaw', 'Kitchenham', '249-858-4247', 'skitchenham1k@sfgate.com', '5/23/2022', 'Bank WXYZ-5678-9012', 'C'),
    (58, 'Harper', 'Itzkov', '609-943-1996', 'hitzkov1l@shutterfly.com', null, 'Bank WXYZ-5678-9012', 'C'),
    (59, 'Cherrita', 'Duffree', '903-165-9189', 'cduffree1m@amazon.de', '12/1/2004', 'Bank FFFF-1234-5678', 'C'),
    (60, 'Constantino', 'Ganter', '628-932-7819', 'cganter1n@cnbc.com', '3/17/2015', 'Bank FFFF-1234-5678', 'C'),
    (61, 'Boniface', 'Henfre', '308-591-7171', 'bhenfre1o@fotki.com', '5/25/2003', 'Bank ZZZZ-ZZZZ-ZZZZ', 'C'),
    (62, 'Farica', 'Benard', '633-998-0035', 'fbenard1p@mozilla.org', '9/19/2005', 'Bank YYYY-YYYY-YYYY', 'C'),
    (63, 'Felice', 'Eastman', '525-781-4837', 'feastman1q@state.gov', '2/11/2011', 'Bank YYYY-YYYY-YYYY', 'D'),
    (64, 'Alphonse', 'Ivanichev', '491-248-4256', 'aivanichev1r@mozilla.com', '5/6/2008', 'Bank ZZZZ-ZZZZ-ZZZZ', 'D'),
    (65, 'Krystalle', 'Naisby', '231-436-4050', 'knaisby1s@google.nl', '5/3/2003', 'Bank YYYY-YYYY-YYYY', 'C'),
    (66, 'Edmund', 'Corneliussen', '570-742-3138', 'ecorneliussen1t@360.cn', '3/14/2011', 'Bank IIII-2345-6789', 'C'),
    (67, 'Pip', 'Gainseford', '394-295-3835', 'pgainseford1u@mayoclinic.com', '6/8/2017', 'Bank XXXX-XXXX-XXXX', 'C'),
    (68, 'Lauritz', 'Taberner', '360-388-1975', 'ltaberner1v@theguardian.com', null, 'Bank IIII-2345-6789', 'D'),
    (69, 'Frasquito', 'Stitcher', '365-932-2531', 'fstitcher1w@livejournal.com', '12/20/2014', 'Bank WXYZ-5678-9012', 'D'),
    (70, 'Ilyse', 'Wehnerr', '539-587-7419', 'iwehnerr1x@tripadvisor.com', null, 'Bank IIII-2345-6789', 'C'),
    (71, 'Mercedes', 'Fannin', '922-110-2959', 'mfannin1y@apache.org', '6/10/2009', 'Bank YYYY-YYYY-YYYY', 'C'),
    (72, 'Lexine', 'Rase', '554-699-4130', 'lrase1z@statcounter.com', null, 'Bank GGGG-9876-5432', 'C'),
    (73, 'Claybourne', 'Olanda', '560-946-1592', 'colanda20@google.es', null, 'Bank FFFF-1234-5678', 'D'),
    (74, 'Eduino', 'Pawnsford', '728-555-6188', 'epawnsford21@dion.ne.jp', '8/14/2014', 'Bank FFFF-1234-5678', 'C'),
    (75, 'Jandy', 'Limming', '371-842-0296', 'jlimming22@amazon.co.uk', '9/9/2008', 'Bank WXYZ-5678-9012', 'C'),
    (76, 'Jillene', 'Ogdahl', '839-961-1144', 'jogdahl23@networkadvertising.org', '9/6/2007', 'Bank ZZZZ-ZZZZ-ZZZZ', 'D'),
    (77, 'Gwenora', 'Czajkowska', '941-525-0066', 'gczajkowska24@de.vu', '1/30/2003', 'Bank FFFF-1234-5678', 'D'),
    (78, 'Brina', 'Condit', '642-382-1893', 'bcondit25@bluehost.com', '8/7/2004', 'Bank ZZZZ-ZZZZ-ZZZZ', 'C'),
    (79, 'Sydelle', 'O''Flannery', '604-515-1295', 'soflannery26@addthis.com', '10/26/2014', 'Bank XXXX-XXXX-XXXX', 'D'),
    (80, 'Micheal', 'Burchall', '145-750-5731', 'mburchall27@elegantthemes.com', '1/23/2001', 'Bank IIII-2345-6789', 'C'),
    (81, 'Jacklyn', 'Champniss', '480-675-0578', 'jchampniss28@meetup.com', '5/30/2004', 'Bank HHHH-3456-7890', 'D'),
    (82, 'Charlene', 'Litchfield', '330-419-4853', 'clitchfield29@usnews.com', '12/5/2015', 'Bank HHHH-3456-7890', 'C'),
    (83, 'Carena', 'Scrange', '345-284-5745', 'cscrange2a@cnn.com', '11/15/2022', 'Bank EEEE-5678-9012', 'D'),
    (84, 'Sari', 'Dreye', '657-662-3601', 'sdreye2b@usgs.gov', '12/1/2018', 'Bank XXXX-XXXX-XXXX', 'D'),
    (85, 'Chevy', 'Iuorio', '501-511-4069', 'ciuorio2c@ebay.com', '2/27/2005', 'Bank ZZZZ-ZZZZ-ZZZZ', 'D'),
    (86, 'Nancie', 'Goodisson', '443-382-9775', 'ngoodisson2d@godaddy.com', '5/4/2018', 'Bank EEEE-5678-9012', 'C'),
    (87, 'Alys', 'Tarbett', '937-527-5232', 'atarbett2e@cmu.edu', '11/25/2004', 'Bank IIII-2345-6789', 'D'),
    (88, 'Lizzy', 'Whitley', '652-152-9900', 'lwhitley2f@simplemachines.org', '8/14/2015', 'Bank IIII-2345-6789', 'C'),
    (89, 'Sam', 'Huncoot', '140-156-1520', 'shuncoot2g@scientificamerican.com', '2/22/2017', 'Bank XXXX-XXXX-XXXX', 'C'),
    (90, 'Karyl', 'Voice', '127-239-2216', 'kvoice2h@friendfeed.com', '7/9/2023', 'Bank EEEE-5678-9012', 'C'),
    (91, 'Zorah', 'Greenshields', '831-833-6808', 'zgreenshields2i@ameblo.jp', '10/4/2003', 'Bank EEEE-5678-9012', 'C'),
    (92, 'Bree', 'Stangoe', '482-997-8989', 'bstangoe2j@fc2.com', null, 'Bank IIII-2345-6789', 'D'),
    (93, 'Ossie', 'Biskupski', '445-347-3559', 'obiskupski2k@ow.ly', '8/8/2002', 'Bank WXYZ-5678-9012', 'C'),
    (94, 'Augustine', 'Empringham', '994-139-1001', 'aempringham2l@xrea.com', null, 'Bank IIII-2345-6789', 'D'),
    (95, 'Fred', 'Aleswell', '431-847-4512', 'faleswell2m@booking.com', '11/14/2020', 'Bank ABCD-1234-5678', 'D'),
    (96, 'Ricard', 'Olivey', '569-635-8443', 'rolivey2n@businessweek.com', '4/9/2000', 'Bank EEEE-5678-9012', 'D'),
    (97, 'Jedediah', 'Carlozzi', '956-734-7858', 'jcarlozzi2o@dyndns.org', '6/12/2000', 'Bank XXXX-XXXX-XXXX', 'C'),
    (98, 'Elizabet', 'Shearmur', '357-836-1788', 'eshearmur2p@dropbox.com', '8/15/2019', 'Bank ZZZZ-ZZZZ-ZZZZ', 'D'),
    (99, 'Bartholomeo', 'Sommerville', '149-737-2640', 'bsommerville2q@loc.gov', '10/15/2003', 'Bank EEEE-5678-9012', 'D'),
    (100, 'Julianne', 'Tapley', '613-673-3515', 'jtapley2r@hubpages.com', '3/17/2015', 'Bank YYYY-YYYY-YYYY', 'C');

-- Inserting Data in Customer Table
INSERT INTO Customer (CustomerId, UserID, EncryptedPaymentInfo)
VALUES
    (1, 9,CONVERT(varbinary(MAX),'Credit Card - XXXX-XXXX-XXXX-XXXX')),
    (2, 6,CONVERT(varbinary(MAX),'PayPal - user@example.com')),
    (3, 54,CONVERT(varbinary(MAX),'Debit Card - YYYY-YYYY-YYYY-YYYY')),
    (4, 50,CONVERT(varbinary(MAX),'Bank Transfer - Account: XXXXXXXX')),
    (5, 26,CONVERT(varbinary(MAX),'Routing: YYYYYYYY')),
    (6, 24,CONVERT(varbinary(MAX),'Cash on Delivery')),
    (7, 11,CONVERT(varbinary(MAX),'Credit Card - ZZZZ-ZZZZ-ZZZZ-ZZZZ')),
    (8, 33,CONVERT(varbinary(MAX),'Debit Card - KKKK-KKKK-KKKK-KKKK')),
    (9, 31,CONVERT(varbinary(MAX),'PayPal - user2@example.com')),
    (10, 26,CONVERT(varbinary(MAX),'Bank Transfer - Account: QQQQ-QQQQ-QQQQ')),
    (11, 16,CONVERT(varbinary(MAX),'Routing: WWWW-WWWW-WWWW')),
    (12, 59,CONVERT(varbinary(MAX),'Cash on Delivery')),
    (13, 14,CONVERT(varbinary(MAX),'Credit Card - XXXX-XXXX-XXXX-XXXX')),
    (14, 31,CONVERT(varbinary(MAX),'PayPal - user@example.com')),
    (15, 47,CONVERT(varbinary(MAX),'Debit Card - YYYY-YYYY-YYYY-YYYY')),
    (16, 54,CONVERT(varbinary(MAX),'Bank Transfer - Account: XXXXXXXX')),
    (17, 13,CONVERT(varbinary(MAX),'Routing: YYYYYYYY')),
    (18, 9,CONVERT(varbinary(MAX),'Cash on Delivery')),
    (19, 53,CONVERT(varbinary(MAX),'Credit Card - ZZZZ-ZZZZ-ZZZZ-ZZZZ')),
    (20, 7,CONVERT(varbinary(MAX),'Debit Card - KKKK-KKKK-KKKK-KKKK')),
    (21, 3,CONVERT(varbinary(MAX),'PayPal - user2@example.com')),
    (22, 41,CONVERT(varbinary(MAX),'Bank Transfer - Account: QQQQ-QQQQ-QQQQ')),
    (23, 9,CONVERT(varbinary(MAX),'Routing: WWWW-WWWW-WWWW')),
    (24, 55,CONVERT(varbinary(MAX),'Cash on Delivery')),
    (25, 29,CONVERT(varbinary(MAX),'Credit Card - XXXX-XXXX-XXXX-XXXX')),
    (26, 42,CONVERT(varbinary(MAX),'PayPal - user@example.com')),
    (27, 33,CONVERT(varbinary(MAX),'Debit Card - YYYY-YYYY-YYYY-YYYY')),
    (28, 1,CONVERT(varbinary(MAX),'Bank Transfer - Account: XXXXXXXX')),
    (29, 42,CONVERT(varbinary(MAX),'Routing: YYYYYYYY')),
    (30, 6,CONVERT(varbinary(MAX),'Cash on Delivery')),
    (31, 14,CONVERT(varbinary(MAX),'Credit Card - ZZZZ-ZZZZ-ZZZZ-ZZZZ')),
    (32, 19,CONVERT(varbinary(MAX),'Debit Card - KKKK-KKKK-KKKK-KKKK')),
    (33, 15,CONVERT(varbinary(MAX),'PayPal - user2@example.com')),
    (34, 11,CONVERT(varbinary(MAX),'Bank Transfer - Account: QQQQ-QQQQ-QQQQ')),
    (35, 16,CONVERT(varbinary(MAX),'Routing: WWWW-WWWW-WWWW')),
    (36, 20,CONVERT(varbinary(MAX),'Cash on Delivery')),
    (37, 14,CONVERT(varbinary(MAX),'Credit Card - XXXX-XXXX-XXXX-XXXX')),
    (38, 33,CONVERT(varbinary(MAX),'PayPal - user@example.com')),
    (39, 1,CONVERT(varbinary(MAX),'Debit Card - YYYY-YYYY-YYYY-YYYY')),
    (40, 4,CONVERT(varbinary(MAX),'Bank Transfer - Account: XXXXXXXX')),
    (41, 13,CONVERT(varbinary(MAX),'Routing: YYYYYYYY')),
    (42, 20,CONVERT(varbinary(MAX),'Cash on Delivery')),
    (43, 1,CONVERT(varbinary(MAX),'Credit Card - ZZZZ-ZZZZ-ZZZZ-ZZZZ')),
    (44, 56,CONVERT(varbinary(MAX),'Debit Card - KKKK-KKKK-KKKK-KKKK')),
    (45, 55,CONVERT(varbinary(MAX),'PayPal - user2@example.com')),
    (46, 35,CONVERT(varbinary(MAX),'Bank Transfer - Account: QQQQ-QQQQ-QQQQ')),
    (47, 6,CONVERT(varbinary(MAX),'Routing: WWWW-WWWW-WWWW')),
    (48, 60,CONVERT(varbinary(MAX),'Cash on Delivery')),
    (49, 25,CONVERT(varbinary(MAX),'Credit Card - XXXX-XXXX-XXXX-XXXX')),
    (50, 23,CONVERT(varbinary(MAX),'PayPal - user@example.com')),
    (51, 59,CONVERT(varbinary(MAX),'Debit Card - YYYY-YYYY-YYYY-YYYY')),
    (52, 29,CONVERT(varbinary(MAX),'Bank Transfer - Account: XXXXXXXX')),
    (53, 54,CONVERT(varbinary(MAX),'Routing: YYYYYYYY')),
    (54, 55,CONVERT(varbinary(MAX),'Cash on Delivery')),
    (55, 13,CONVERT(varbinary(MAX),'Credit Card - ZZZZ-ZZZZ-ZZZZ-ZZZZ')),
    (56, 43,CONVERT(varbinary(MAX),'Debit Card - KKKK-KKKK-KKKK-KKKK')),
    (57, 3,CONVERT(varbinary(MAX),'PayPal - user2@example.com')),
    (58, 55,CONVERT(varbinary(MAX),'Bank Transfer - Account: QQQQ-QQQQ-QQQQ')),
    (59, 47,CONVERT(varbinary(MAX),'Routing: WWWW-WWWW-WWWW')),
    (60, 25,CONVERT(varbinary(MAX),'Cash on Delivery'));

-- Inserting Data in Driver Table
INSERT INTO Driver (DriverID, UserID, VehicleID, LicenseInfo)
VALUES
    (1, 99, 33, 'DL3S2X1'),
    (2, 78, 97, 'DL6Y3S5'),
    (3, 61, 39, 'DL9N5E7'),
    (4, 64, 48, 'DL6B2T7'),
    (5, 62, 13, 'DL3S2X1'),
    (6, 62, 53, 'DL3S2X1'),
    (7, 98, 60, 'DL3S7A6'),
    (8, 82, 67, 'DL3F2C7'),
    (9, 69, 95, 'DL8L2U6'),
    (10, 81, 66, 'DL6Y9G2'),
    (11, 82, 78, 'DL3F1H7'),
    (12, 82, 62, 'DL4F3V6'),
    (13, 68, 85, 'DL5A4G8'),
    (14, 86, 100, 'DL1E9B4'),
    (15, 63, 4, 'DL5G8C4'),
    (16, 74, 85, 'DL2L7V9'),
    (17, 63, 28, 'DL3H5L7'),
    (18, 85, 97, 'DL5A4G8'),
    (19, 97, 73, 'DL5K7Y3'),
    (20, 79, 75, 'DL4Q1S8'),
    (21, 85, 21, 'DL4P7B3'),
    (22, 78, 20, 'DL5H7J4'),
    (23, 89, 39, 'DL4X1A5'),
    (24, 89, 29, 'DL9G5R1'),
    (25, 66, 74, 'DL6B2T7'),
    (26, 73, 26, 'DL6Y9G2'),
    (27, 94, 95, 'DL1J6R9'),
    (28, 71, 30, 'DL4R2L5'),
    (29, 99, 45, 'DL1G8E6'),
    (30, 74, 23, 'DL4P7B3'),
    (31, 68, 13, 'DL4R2L5'),
    (32, 96, 93, 'DL7Z3P8'),
    (33, 83, 10, 'DL6Y3S5'),
    (34, 72, 55, 'DL8U2P4'),
    (35, 89, 49, 'DL1V4T9'),
    (36, 71, 21, 'DL8X3L5'),
    (37, 85, 11, 'DL1J4W2'),
    (38, 66, 85, 'DL9G5R1'),
    (39, 98, 24, 'DL4Q1S8'),
    (40, 73, 67, 'DL5H8G7');

-- Inserting Data in Feedback Table
INSERT INTO Feedback (FeedbackID, CustomerID, DriverID, Message,Rating)
VALUES
    (1, 9, 84, 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', 0.8),
    (2, 33, 62, 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 2.9),
    (3, 19, 87, 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', 4.1),
    (4, 59, 99, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', 2.3),
    (5, 37, 66, 'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 1.6),
    (6, 7, 99, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', 0.6),
    (7, 40, 63, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 3.9),
    (8, 26, 63, 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.', 4.5),
    (9, 53, 87, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.', 1.4),
    (10, 45, 79, 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.', 4.8),
    (11, 1, 73, 'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', 3.8),
    (12, 28, 74, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 2.3),
    (13, 19, 95, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 2.2),
    (14, 10, 74, 'Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 2.5),
    (15, 51, 82, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.', 0.1),
    (16, 11, 81, 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio.', 2.9),
    (17, 11, 69, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.', 4.7),
    (18, 4, 88, 'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.', 4.7),
    (19, 41, 82, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', 4.2),
    (20, 36, 80, 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio. Curabitur convallis.', 1.6),
    (21, 34, 62, 'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue.', 3.2),
    (22, 11, 83, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 0.7),
    (23, 23, 99, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', 1.4),
    (24, 56, 86, 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus.', 0.6),
    (25, 41, 97, 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', 2.3),
    (26, 33, 97, 'Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.', 1.7),
    (27, 11, 78, 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.', 3.6),
    (28, 2, 81, 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', 2.8),
    (29, 41, 64, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.', 3.9),
    (30, 54, 66, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', 1.1),
    (31, 29, 78, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis.', 1.4),
    (32, 38, 87, 'In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 2.0),
    (33, 22, 76, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', 4.1),
    (34, 49, 66, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', 3.0),
    (35, 20, 67, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', 4.3),
    (36, 17, 62, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique.', 0.3),
    (37, 34, 99, 'Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', 2.3),
    (38, 30, 84, 'Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', 4.8),
    (39, 32, 96, 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 2.1),
    (40, 4, 98, 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio.', 2.8),
    (41, 12, 86, 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.', 3.1),
    (42, 44, 80, 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.', 1.0),
    (43, 43, 67, 'Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.', 0.7),
    (44, 38, 96, 'Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', 0.8),
    (45, 59, 86, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', 3.9),
    (46, 12, 89, 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', 3.2),
    (47, 34, 79, 'In congue. Etiam justo. Etiam pretium iaculis justo.', 3.6),
    (48, 6, 74, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', 2.2),
    (49, 5, 67, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 4.8),
    (50, 45, 89, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', 2.9),
    (51, 37, 82, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 3.0),
    (52, 18, 94, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 3.3),
    (53, 14, 78, 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 3.4),
    (54, 23, 79, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', 0.9),
    (55, 11, 63, 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 3.9),
    (56, 45, 63, 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 4.1),
    (57, 48, 71, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla.', 3.3),
    (58, 7, 75, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio.', 1.3),
    (59, 45, 72, 'Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus.', 1.4),
    (60, 47, 65, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 1.0),
    (61, 50, 68, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', 4.2),
    (62, 10, 67, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', 1.2),
    (63, 24, 72, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.', 3.2),
    (64, 60, 62, 'Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 1.6),
    (65, 16, 76, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', 2.9),
    (66, 45, 77, 'Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 1.8),
    (67, 17, 77, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', 3.9),
    (68, 58, 75, 'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', 1.4),
    (69, 54, 61, 'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', 4.8),
    (70, 2, 73, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', 4.4),
    (71, 9, 84, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero.', 0.2),
    (72, 13, 79, 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 4.5),
    (73, 23, 87, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.', 3.9),
    (74, 35, 99, 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', 4.9),
    (75, 7, 89, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.', 1.9),
    (76, 55, 100, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 4.1),
    (77, 49, 75, 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum.', 2.8),
    (78, 50, 72, 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.', 2.4),
    (79, 37, 86, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.', 4.2),
    (80, 49, 80, 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 4.3),
    (81, 5, 81, 'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', 3.2),
    (82, 48, 95, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla.', 3.3),
    (83, 21, 95, 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat.', 3.5),
    (84, 19, 79, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', 4.3),
    (85, 8, 89, 'Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', 4.2),
    (86, 49, 81, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 0.5),
    (87, 33, 93, 'Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', 2.8),
    (88, 37, 73, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', 2.3),
    (89, 37, 71, 'Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 4.6),
    (90, 7, 87, 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.', 1.5),
    (91, 4, 88, 'In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.', 3.8),
    (92, 46, 77, 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.', 0.3),
    (93, 55, 77, 'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', 1.1),
    (94, 5, 66, 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis.', 1.1),
    (95, 51, 62, 'Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 1.8),
    (96, 23, 80, 'Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', 1.7),
    (97, 4, 63, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', 0.3),
    (98, 20, 79, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio.', 1.9),
    (99, 2, 61, 'Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 4.2),
    (100, 4, 99, 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 2.4);

-- Inserting Data in TripEstimate Table
INSERT INTO TripEstimate (EstimationId, VehicleID, CurrentTime, Cost)
VALUES
    (1, 6, '2023-01-09 16:18:32', 136.79),
    (2, 42, '2023-03-31 17:03:57', 212.58),
    (3, 100, '2023-06-06 16:23:58', 80.01),
    (4, 77, '2023-11-05 21:36:50', 161.23),
    (5, 79, '2023-01-31 02:53:36', 92.44),
    (6, 7, '2023-01-29 15:31:10', 95.26),
    (7, 20, '2023-02-24 21:57:42', 167.70),
    (8, 5, '2023-08-24 19:07:02', 143.82),
    (9, 33, '2023-04-14 14:20:42', 204.31),
    (10, 64, '2023-02-22 17:43:18', 118.61),
    (11, 78, '2023-01-07 06:39:50', 127.48),
    (12, 94, '2023-01-09 07:37:57', 55.50),
    (13, 65, '2023-06-22 10:35:58', 31.12),
    (14, 44, '2023-01-27 20:37:01', 164.01),
    (15, 22, '2023-11-19 06:43:08', 68.95),
    (16, 59, '2023-01-25 21:52:32', 193.36),
    (17, 40, '2023-03-30 16:19:16', 136.09),
    (18, 59, '2023-03-24 01:40:43', 41.68),
    (19, 95, '2023-12-15 13:48:12', 244.25),
    (20, 67, '2023-01-12 13:58:02', 206.91),
    (21, 100, '2023-07-01 01:08:34', 1.45),
    (22, 33, '2023-06-28 03:03:33', 150.44),
    (23, 14, '2023-07-30 22:24:36', 118.65),
    (24, 96, '2023-06-15 07:12:05', 59.52),
    (25, 6, '2023-09-11 00:47:59', 230.44),
    (26, 14, '2023-05-15 01:57:45', 2.86),
    (27, 63, '2023-08-30 04:56:51', 227.01),
    (28, 12, '2023-06-09 01:51:17', 79.88),
    (29, 53, '2023-06-30 19:47:43', 3.01),
    (30, 73, '2023-08-27 22:44:20', 164.24);

-- Inserting Data in RideRequest Table
INSERT INTO RideRequest (RequestId, EstimationID, VehicleID,DriverID, CustomerID,RequestType, ReqDateTime, 
    PickUpLocationLatitude, PickUpLocationLongitude, DestinationLocationLatitude, 
    DestinationLocationLongitude, TripType, TripCompletionFlag, PickUpLocation, DestinationLocation)
VALUES
    (1, 20, 2, 19, 20, 'Out Station Cab', '2023-11-29 10:38:38', 13.674033, 108.9502232, 41.186564, 111.308664, 'Out Station Cab', 1, '29 Sunnyside Circle', '3 Fulton Plaza'),
    (2, 11, 34, 8, 20, 'City Cab', '2023-03-08 15:45:21', 34.90994, 109.73445, -6.9218452, 112.867154, 'Out Station Cab', 1, '8032 Armistice Road', '9 Montana Place'),
    (3, 9, 30, 29, 57, 'City Cab', '2023-04-02 23:36:52', 16.3763389, 102.1287289, 48.2465578, 31.4060472, 'Out Station Cab', 1, '75312 Eastwood Center', '03284 Lotheville Way'),
    (4, 22, 85, 11, 49, 'City Cab', '2023-11-17 16:48:51', 39.864867, 79.069332, 39.3221782, -9.342559, 'City Cab', 0, '9 Bluejay Street', '2542 Corben Center'),
    (5, 28, 86, 7, 59, 'City Cab', '2023-07-15 04:01:17', 34.058401, 107.319116, 43.4945737, 5.8978018, 'City Cab', 0, '89 Center Trail', '39003 Rieder Alley'),
    (6, 29, 40, 29, 57, 'Out Station Cab', '2023-04-19 19:41:18', -7.0386444, 107.9692467, -23.7082237, -46.415128, 'City Cab', 0, '48 Carpenter Road', '109 Division Place'),
    (7, 27, 38, 4, 1, 'City Cab', '2023-03-29 03:33:44', 44.4353271, 34.1121629, 54.939518, 37.4014986, 'Out Station Cab', 1, '25 Old Gate Pass', '713 Mccormick Circle'),
    (8, 5, 57, 27, 22, 'Out Station Cab', '2023-10-15 15:55:57', -8.3647, 123.5718, 41.7268086, 129.6850661, 'City Cab', 1, '0 Charing Cross Crossing', '597 Mariners Cove Pass'),
    (9, 23, 93, 32, 5, 'City Cab', '2023-12-17 12:03:20', 41.529235, -8.5859581, 44.7416079, 18.2727658, 'City Cab', 0, '4 Sherman Court', '367 Stoughton Street'),
    (10, 29, 23, 10, 46, 'Out Station Cab', '2023-02-26 02:25:47', 23.365556, 116.70345, -31.7436794, -65.0052144, 'Out Station Cab', 1, '291 Memorial Point', '6 Talmadge Lane'),
    (11, 18, 73, 33, 26, 'City Cab', '2023-05-26 17:36:54', 45.159309, 14.5440221, 15.5406754, 37.8777561, 'Out Station Cab', 1, '0849 Coolidge Avenue', '96 Bluejay Drive'),
    (12, 4, 88, 32, 54, 'City Cab', '2023-07-25 08:04:24', 48.3226457, 31.5187617, 7.0241972, 79.9020405, 'City Cab', 1, '8 Ohio Plaza', '416 Ridgeway Avenue'),
    (13, 2, 87, 5, 17, 'Out Station Cab', '2023-12-08 01:59:26', 42.0649631, -8.3756082, 40.0982704, 139.9803194, 'Out Station Cab', 1, '4 Talisman Hill', '0 Eastlawn Alley'),
    (14, 16, 92, 18, 18, 'Out Station Cab', '2023-11-21 01:36:04', 13.2997024, 7.79873, 22.928305, 113.207187, 'Out Station Cab', 0, '5424 Schurz Point', '60 Bartillon Street'),
    (15, 12, 81, 31, 9, 'Out Station Cab', '2023-10-19 20:12:17', 48.1495982, 24.2824443, 52.0322082, 29.222313, 'Out Station Cab', 0, '7547 Lotheville Alley', '0 Sheridan Center'),
    (16, 27, 82, 12, 58, 'City Cab', '2023-05-22 04:45:38', 38.093189, 114.478864, 29.295, 47.93306, 'City Cab', 1, '823 Union Parkway', '8 Morningstar Way'),
    (17, 10, 55, 3, 33, 'City Cab', '2023-02-01 18:36:08', 11.5484585, 8.8583309, 7.18028, 122.22028, 'Out Station Cab', 0, '2927 Kropf Way', '8393 Service Crossing'),
    (18, 9, 36, 40, 23, 'Out Station Cab', '2023-04-17 20:49:51', 29.270311, 88.880492, 3.3663183, -59.7977761, 'Out Station Cab', 1, '04 Warrior Plaza', '33764 Lindbergh Center'),
    (19, 22, 51, 5, 53, 'Out Station Cab', '2023-09-07 07:38:12', 15.3569408, 120.5288453, 6.1244023, 100.3674801, 'City Cab', 0, '3 Leroy Circle', '14373 Mandrake Crossing'),
    (20, 25, 73, 5, 18, 'Out Station Cab', '2023-09-07 00:08:50', -7.1546275, 108.7660364, 41.6338439, 25.3777119, 'Out Station Cab', 1, '8 Merchant Terrace', '9327 5th Drive'),
    (21, 28, 20, 16, 13, 'City Cab', '2023-11-05 17:00:09', 40.7582228, -73.9704871, 30.921373, 118.784812, 'Out Station Cab', 0, '330 Walton Hill', '61018 Declaration Center'),
    (22, 26, 38, 34, 37, 'City Cab', '2023-09-08 03:51:36', 29.5320522, 35.0063209, 10.1310658, 106.3311197, 'City Cab', 0, '27 Barnett Way', '64 Welch Terrace'),
    (23, 20, 62, 31, 37, 'Out Station Cab', '2023-04-09 12:13:15', 37.6703123, 140.6062909, 32.231566, 35.214616, 'City Cab', 0, '4499 Eastwood Circle', '65859 Hudson Street'),
    (24, 14, 8, 35, 1, 'City Cab', '2023-10-04 09:39:42', 32.224808, 110.228747, 46.465362, 124.670305, 'Out Station Cab', 1, '66252 Petterle Alley', '54 Main Crossing'),
    (25, 14, 16, 9, 37, 'Out Station Cab', '2023-09-01 12:07:26', 41.4242264, -8.6722459, -28.2750463, 26.1477598, 'Out Station Cab', 0, '3 Merrick Park', '43 Center Street'),
    (26, 29, 94, 26, 16, 'City Cab', '2023-01-23 20:36:40', 18.594395, -72.3074326, 45.4949897, 16.7305754, 'Out Station Cab', 0, '84 Jackson Avenue', '9 Moland Alley'),
    (27, 3, 86, 23, 6, 'Out Station Cab', '2023-04-30 07:04:53', 4.5775693, 28.3987842, -33.4891416, 151.3248343, 'City Cab', 1, '6059 Graceland Trail', '12 Dakota Parkway'),
    (28, 9, 53, 32, 24, 'City Cab', '2023-03-22 02:27:06', -37.9707308, -57.6258993, 48.6059152, -4.1166788, 'City Cab', 0, '31 Steensland Plaza', '93482 Troy Junction'),
    (29, 5, 35, 22, 57, 'Out Station Cab', '2023-12-03 20:59:18', 29.422658, -98.4869905, 53.6094246, 18.5697311, 'Out Station Cab', 1, '47988 Helena Terrace', '516 Center Court'),
    (30, 19, 95, 16, 28, 'Out Station Cab', '2023-02-09 02:21:33', 12.4525749, 7.3071075, 41.9310069, 25.5327587, 'Out Station Cab', 0, '93 Carberry Way', '227 Kim Circle');


-- Inserting Data in ServiceRequest Table
INSERT INTO ServiceRequest (SerReqId, VehicleId, ServiceId, ReqDateTime, ServiceDueDate, PreviousServiceDate)
VALUES
    (1, 41, 3, '10/12/2023', '8/7/2023', '2/12/2022'),
    (2, 36, 83, '7/10/2023', '8/29/2023', '6/10/2022'),
    (3, 35, 23, '4/2/2023', '2/23/2023', '9/26/2022'),
    (4, 84, 13, '4/28/2023', '7/23/2023', '9/24/2022'),
    (5, 42, 23, '6/2/2023', '8/11/2023', '1/8/2022'),
    (6, 85, 3, '9/15/2023', '12/3/2023', '12/8/2022'),
    (7, 34, 82, '10/7/2023', '11/21/2023', '4/25/2022'),
    (8, 96, 75, '2/6/2023', '3/1/2023', '3/23/2022'),
    (9, 91, 56, '10/30/2023', '3/3/2023', '11/15/2022'),
    (10, 62, 5, '9/13/2023', '5/29/2023', '10/16/2022'),
    (11, 52, 53, '8/27/2023', '3/18/2023', '8/19/2022'),
    (12, 65, 60, '10/8/2023', '8/19/2023', '5/2/2022'),
    (13, 26, 82, '6/27/2023', '12/10/2023', '10/29/2022'),
    (14, 61, 83, '8/24/2023', '2/5/2023', '5/30/2022'),
    (15, 4, 82, '12/2/2022', '10/31/2023', '2/1/2022'),
    (16, 1, 15, '3/11/2023', '10/2/2023', '9/28/2022'),
    (17, 72, 62, '7/12/2023', '8/29/2023', '7/7/2022'),
    (18, 14, 100, '1/24/2023', '4/20/2023', '9/11/2022'),
    (19, 3, 81, '8/30/2023', '5/6/2023', '6/20/2022'),
    (20, 87, 16, '9/10/2023', '9/12/2023', '4/27/2022'),
    (21, 67, 64, '7/19/2023', '12/27/2023', '5/26/2022'),
    (22, 59, 59, '1/11/2023', '6/7/2023', '9/30/2022'),
    (23, 6, 36, '8/3/2023', '5/27/2023', '5/11/2022'),
    (24, 10, 39, '9/21/2023', '10/22/2023', '3/7/2022'),
    (25, 69, 84, '5/12/2023', '5/6/2023', '9/1/2022'),
    (26, 4, 98, '7/23/2023', '3/9/2023', '8/13/2022'),
    (27, 58, 87, '12/9/2022', '4/9/2023', '12/6/2022'),
    (28, 76, 92, '2/7/2023', '11/13/2023', '5/1/2022'),
    (29, 92, 69, '2/16/2023', '6/16/2023', '4/3/2022'),
    (30, 76, 60, '10/31/2023', '3/29/2023', '12/24/2022'),
    (31, 44, 3, '4/10/2023', '8/2/2023', '3/2/2022'),
    (32, 91, 86, '5/17/2023', '7/16/2023', '1/31/2022'),
    (33, 1, 47, '1/1/2023', '8/9/2023', '8/30/2022'),
    (34, 47, 50, '10/17/2023', '12/17/2023', '4/29/2022'),
    (35, 17, 63, '6/4/2023', '3/4/2023', '4/10/2022'),
    (36, 32, 97, '8/8/2023', '2/4/2023', '6/9/2022'),
    (37, 36, 37, '4/10/2023', '12/21/2023', '10/7/2022'),
    (38, 16, 13, '9/19/2023', '2/28/2023', '10/24/2022'),
    (39, 57, 73, '9/11/2023', '10/31/2023', '8/21/2022'),
    (40, 23, 70, '6/22/2023', '3/1/2023', '11/13/2022'),
    (41, 11, 77, '6/14/2023', '10/3/2023', '5/17/2022'),
    (42, 54, 58, '4/26/2023', '8/22/2023', '12/21/2022'),
    (43, 49, 2, '11/21/2023', '7/23/2023', '3/5/2022'),
    (44, 45, 25, '9/2/2023', '11/17/2023', '12/28/2022'),
    (45, 94, 40, '9/6/2023', '5/21/2023', '5/7/2022'),
    (46, 99, 98, '2/26/2023', '12/22/2023', '2/27/2022'),
    (47, 100, 21, '2/2/2023', '11/22/2023', '9/5/2022'),
    (48, 26, 94, '4/15/2023', '5/12/2023', '1/31/2022'),
    (49, 74, 83, '1/21/2023', '11/30/2023', '1/22/2022'),
    (50, 78, 70, '5/29/2023', '2/14/2023', '6/11/2022'),
    (51, 8, 18, '1/18/2023', '2/22/2023', '9/8/2022'),
    (52, 93, 32, '8/19/2023', '7/25/2023', '11/8/2022'),
    (53, 54, 56, '9/1/2023', '9/16/2023', '11/23/2022'),
    (54, 55, 62, '3/8/2023', '9/12/2023', '10/28/2022'),
    (55, 22, 84, '11/17/2023', '11/27/2023', '12/28/2022'),
    (56, 41, 43, '7/31/2023', '2/15/2023', '1/20/2022'),
    (57, 53, 79, '5/30/2023', '6/19/2023', '10/8/2022'),
    (58, 72, 41, '3/29/2023', '7/12/2023', '1/23/2022'),
    (59, 51, 70, '12/23/2022', '3/22/2023', '8/2/2022'),
    (60, 76, 88, '12/9/2022', '3/18/2023', '11/22/2022'),
    (61, 93, 63, '3/29/2023', '11/1/2023', '3/1/2022'),
    (62, 78, 73, '6/7/2023', '8/1/2023', '3/2/2022'),
    (63, 41, 52, '11/28/2022', '3/23/2023', '7/14/2022'),
    (64, 24, 44, '8/5/2023', '5/19/2023', '10/22/2022'),
    (65, 16, 30, '4/25/2023', '12/19/2023', '6/12/2022'),
    (66, 55, 83, '9/9/2023', '9/19/2023', '6/26/2022'),
    (67, 60, 61, '6/13/2023', '5/18/2023', '6/30/2022'),
    (68, 40, 8, '11/1/2023', '3/27/2023', '6/11/2022'),
    (69, 34, 91, '7/10/2023', '7/31/2023', '7/11/2022'),
    (70, 66, 34, '11/11/2023', '11/29/2023', '7/13/2022'),
    (71, 9, 70, '7/28/2023', '6/25/2023', '5/25/2022'),
    (72, 25, 78, '8/3/2023', '11/12/2023', '3/21/2022'),
    (73, 76, 10, '2/1/2023', '5/20/2023', '12/15/2022'),
    (74, 59, 10, '9/8/2023', '9/22/2023', '5/24/2022'),
    (75, 43, 99, '6/8/2023', '11/18/2023', '12/31/2021'),
    (76, 82, 76, '7/14/2023', '8/11/2023', '11/3/2022'),
    (77, 92, 61, '4/29/2023', '12/20/2023', '5/13/2022'),
    (78, 88, 88, '2/11/2023', '12/7/2023', '3/7/2022'),
    (79, 81, 6, '6/2/2023', '4/3/2023', '6/4/2022'),
    (80, 34, 43, '11/30/2022', '10/10/2023', '12/30/2022'),
    (81, 34, 1, '1/4/2023', '10/21/2023', '10/20/2022'),
    (82, 77, 85, '7/30/2023', '12/11/2023', '11/7/2022'),
    (83, 20, 8, '5/27/2023', '10/10/2023', '10/6/2022'),
    (84, 21, 95, '2/16/2023', '11/1/2023', '2/19/2022'),
    (85, 21, 95, '5/9/2023', '10/4/2023', '4/3/2022'),
    (86, 9, 44, '12/4/2022', '6/2/2023', '12/14/2022'),
    (87, 38, 77, '6/7/2023', '7/9/2023', '7/19/2022'),
    (88, 17, 99, '1/6/2023', '4/13/2023', '12/25/2022'),
    (89, 24, 25, '4/6/2023', '8/21/2023', '12/7/2022'),
    (90, 46, 8, '11/10/2023', '5/25/2023', '2/4/2022'),
    (91, 56, 69, '4/19/2023', '8/28/2023', '9/7/2022'),
    (92, 64, 71, '5/25/2023', '9/25/2023', '5/22/2022'),
    (93, 82, 81, '10/5/2023', '9/18/2023', '12/6/2022'),
    (94, 75, 74, '9/30/2023', '12/31/2022', '4/6/2022'),
    (95, 75, 79, '5/2/2023', '8/4/2023', '9/19/2022'),
    (96, 17, 2, '11/20/2023', '6/16/2023', '8/5/2022'),
    (97, 15, 96, '9/7/2023', '6/17/2023', '11/23/2022'),
    (98, 29, 38, '5/22/2023', '1/2/2023', '10/21/2022'),
    (99, 3, 56, '5/30/2023', '6/10/2023', '8/6/2022'),
    (100, 16, 87, '1/27/2023', '6/19/2023', '7/31/2022');

-- Inserting Data in InsuranceLogs Table
INSERT INTO InsuranceLogs (VehicleID, InsuranceId, InsuranceStartDate, InsuranceEndDate)
VALUES
    (22, 93, '5/5/2023', '12/2/2024'),
    (41, 31, '6/15/2023', '9/14/2024'),
    (17, 46, '4/8/2023', '6/19/2024'),
    (64, 86, '7/8/2023', '12/19/2024'),
    (72, 93, '10/16/2023', '2/15/2024'),
    (97, 54, '4/3/2023', '7/31/2024'),
    (92, 43, '7/18/2023', '12/21/2024'),
    (38, 49, '8/20/2023', '6/4/2024'),
    (12, 24, '6/23/2023', '3/29/2024'),
    (24, 2, '2/18/2023', '3/4/2024'),
    (71, 43, '10/29/2023', '9/19/2024'),
    (15, 72, '11/18/2023', '8/12/2024'),
    (42, 86, '5/22/2023', '7/10/2024'),
    (35, 32, '5/23/2023', '9/9/2024'),
    (35, 57, '4/2/2023', '8/26/2024'),
    (1, 79, '9/14/2023', '9/14/2024'),
    (65, 72, '5/22/2023', '1/31/2024'),
    (52, 71, '7/30/2023', '9/7/2024'),
    (91, 77, '11/27/2023', '12/29/2024'),
    (20, 84, '1/20/2023', '8/13/2024'),
    (90, 38, '12/31/2022', '9/22/2024'),
    (71, 13, '3/20/2023', '5/29/2024'),
    (42, 93, '10/30/2023', '11/26/2024'),
    (98, 53, '1/6/2023', '7/4/2024'),
    (92, 23, '1/4/2023', '7/17/2024'),
    (26, 44, '5/24/2023', '6/13/2024'),
    (49, 53, '8/3/2023', '8/19/2024'),
    (25, 53, '7/22/2023', '6/7/2024'),
    (10, 68, '12/18/2023', '10/3/2024'),
    (47, 1, '7/24/2023', '2/8/2024'),
    (61, 99, '3/22/2023', '7/3/2024'),
    (66, 7, '6/21/2023', '4/26/2024'),
    (64, 46, '3/3/2023', '9/12/2024'),
    (23, 77, '1/24/2023', '8/2/2024'),
    (97, 57, '9/11/2023', '7/20/2024'),
    (22, 65, '3/7/2023', '3/13/2024'),
    (92, 36, '5/3/2023', '4/18/2024'),
    (61, 15, '12/6/2023', '6/16/2024'),
    (24, 96, '7/16/2023', '10/29/2024'),
    (14, 61, '9/7/2023', '4/15/2024'),
    (90, 84, '9/8/2023', '8/14/2024'),
    (79, 99, '12/16/2023', '12/4/2024'),
    (27, 73, '4/22/2023', '12/3/2024'),
    (59, 79, '9/7/2023', '2/26/2024'),
    (13, 51, '10/21/2023', '11/27/2024'),
    (97, 22, '12/13/2023', '8/5/2024'),
    (83, 68, '10/13/2023', '10/6/2024'),
    (85, 80, '12/31/2022', '3/4/2024'),
    (95, 53, '9/10/2023', '2/2/2024'),
    (10, 33, '8/4/2023', '2/2/2024'),
    (92, 77, '6/12/2023', '8/14/2024'),
    (71, 63, '8/10/2023', '2/23/2024'),
    (93, 51, '12/3/2023', '3/16/2024'),
    (84, 25, '8/28/2023', '12/30/2024'),
    (44, 2, '12/17/2023', '3/15/2024'),
    (55, 82, '11/10/2023', '6/9/2024'),
    (18, 91, '4/7/2023', '3/27/2024'),
    (31, 73, '11/8/2023', '4/10/2024'),
    (90, 57, '9/30/2023', '2/5/2024'),
    (4, 44, '9/11/2023', '5/8/2024'),
    (8, 89, '1/4/2023', '3/24/2024'),
    (1, 46, '6/5/2023', '11/16/2024'),
    (35, 61, '12/12/2023', '2/3/2024'),
    (60, 46, '4/1/2023', '4/21/2024'),
    (12, 26, '7/10/2023', '7/29/2024'),
    (11, 46, '10/31/2023', '7/29/2024'),
    (95, 1, '8/26/2023', '3/16/2024'),
    (69, 66, '4/13/2023', '7/19/2024'),
    (1, 52, '2/10/2023', '4/24/2024'),
    (38, 87, '4/28/2023', '4/23/2024'),
    (51, 21, '11/28/2023', '8/14/2024'),
    (59, 6, '5/16/2023', '10/22/2024'),
    (90, 6, '3/20/2023', '4/20/2024'),
    (9, 19, '12/21/2023', '1/26/2024'),
    (27, 99, '9/15/2023', '11/5/2024'),
    (27, 81, '11/20/2023', '6/27/2024'),
    (91, 34, '5/27/2023', '12/3/2024'),
    (60, 17, '7/8/2023', '6/17/2024'),
    (66, 57, '3/2/2023', '11/18/2024'),
    (64, 27, '10/27/2023', '10/29/2024'),
    (10, 61, '12/19/2023', '9/8/2024'),
    (25, 73, '7/9/2023', '9/11/2024'),
    (83, 63, '9/1/2023', '7/21/2024'),
    (28, 55, '5/20/2023', '6/15/2024'),
    (21, 81, '9/9/2023', '12/5/2024'),
    (29, 59, '12/29/2023', '11/10/2024'),
    (28, 79, '3/31/2023', '8/23/2024'),
    (40, 1, '3/5/2023', '4/19/2024'),
    (9, 50, '12/14/2023', '1/20/2024'),
    (70, 87, '11/21/2023', '8/27/2024'),
    (40, 78, '10/4/2023', '8/17/2024'),
    (8, 91, '11/20/2023', '9/23/2024'),
    (19, 73, '3/9/2023', '8/28/2024'),
    (81, 89, '11/27/2023', '1/17/2024'),
    (64, 78, '6/4/2023', '5/3/2024'),
    (36, 19, '9/15/2023', '6/9/2024'),
    (96, 44, '3/14/2023', '9/15/2024'),
    (30, 96, '8/15/2023', '3/26/2024'),
    (41, 86, '11/19/2023', '12/13/2024'),
    (48, 71, '3/9/2023', '12/17/2024');

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