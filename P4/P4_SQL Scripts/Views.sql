use TaxiManagementSystem
go

-- View to get Customer Ride History
CREATE VIEW CustomerRideHistoryView AS
	SELECT users.UserFName+' '+users.UserLName as "Customer Full Name",
			count(trip.Cost) as "Total Rides",
		   sum(trip.Cost) as "Total Ride Spend"
		   --Avg(trip.Cost) as "Average Cost per Ride"
	FROM [User] users JOIN Customer cust on users.UserID = cust.CustomerID  LEFT JOIN  RideRequest ride on cust.CustomerID = ride.CustomerID  join TripEstimate trip on ride.EstimationID = trip.EstimationId
	WHERE ride.TripCompletionFlag = 1
	GROUP BY users.UserFName+' '+users.UserLName;
	

select * from CustomerRideHistoryView order by "Total Ride Spend" desc;

--View to get ServiceRequest Details
CREATE VIEW ServiceRequestDetailsView As
SELECT v.VehicleId, v.VehicleType, s.ServiceDetails, s.ServiceName, s.ServiceCompanyName
FROM ServiceRequest  sr  RIGHT JOIN Vehicle v ON sr.VehicleId = v.VehicleId JOIN [Service] s ON sr.ServiceId = s.ServiceId;

select * from ServiceRequestDetailsView;

CREATE VIEW CustomerAndVehicleView AS
SELECT
    C.CustomerId,
    U.UserFName+' '+U.UserLName CustomerName,
    V.VehicleId,
    V.VehicleType,
    V.ServiceInfo AS VehicleServiceInfo
FROM
    Customer C
JOIN
    [User] U ON C.UserID = U.UserID
JOIN
    Vehicle V ON C.CustomerId = V.VehicleId;

select * from CustomerAndVehicleView;

--- view for vehicle stats
CREATE VIEW  VehicleRequestedView AS
SELECT v.VehicleType, count(nrr.VehicleID) "Count of Vehicle Requested"
FROM Vehicle v LEFT JOIN (SELECT r.* FROM RideRequest r WHERE r.TripCompletionFlag = 1) nrr on v.VehicleId = nrr.VehicleID
GROUP BY v.VehicleType;

select * from VehicleRequestedView;