-- Inserting Data in Service Table
use TaxiManagementSystem;
go

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
