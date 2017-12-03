create table Airport 
as 
select * from dw_oft.Airports1;

create table Airline 
as 
select * from dw_oft.Airlines1;

create table Route 
as 
select * from dw_oft.Routes1;

create table Aircraft 
as 
select * from dw_oft.Aircrafts1;

create table Provides 
as 
select * from dw_oft.Provides1;

create table Flight 
as 
select * from dw_oft.Flights1;

create table Passenger 
as 
select * from dw_oft.Passengers1;

create table Transaction 
as 
select * from dw_oft.Transactions1;

create table Airline_Service 
as 
select * from DW_OFT.AIRLINE_SERVICES1;

-- Data Exploration
--Data cleaning for route table

--Total Records
Select count(*) from ROUTE;
--58445

-- Checking whether source airport id is null
Select COUNT(*) from ROUTE where SOURCEAIRPORTID is null;
--0

--Checking total number of source airport  
Select COUNT(*) from ROUTE where SOURCEAIRPORTID is not null;
--58445

-- Checking whether destination airport id is null
Select COUNT(*) from ROUTE where DESTAIRPORTID is null;
--0

--Checking total number of destination airport
Select COUNT(*) from ROUTE where DESTAIRPORTID is not null;
--58445

--Checking whether source and destination airport id are same
Select COUNT(*) from ROUTE where DESTAIRPORTID = SOURCEAIRPORTID;
--0

--Conclusion 
--source airport id and destination airport id is not null in routes
--source airport id is not same as destination airport id in any row

--Checking for 0 distance travelled 
Select COUNT(*) from ROUTE where distance = 0;
--0

--Checking for 0 service cost 
Select COUNT(*) from ROUTE where SERVICECOST = 0;
--0

--Conclusion no distance and service cost is zero so value is present

-- Checking negative values for distance
select * from ROUTE where DISTANCE <= 0;
-- Found one value with negative distance. We are deleting the record having routeid = -1

-- Checking negative values for servicecost
select * from ROUTE where SERVICECOST <= 0;
-- Found one value with negative servicecost. We are deleting the record having routeid = -1

-- Checking negative values for routeid
select * from ROUTE where ROUTEID <= 0;
-- Found one value with negative routeID. We are deleting the record having routeid = -1

--Deleting the record with routeid = -1
delete from ROUTE where ROUTEID = -1;

-- Checking negative values for routeid
select count(*) from ROUTE where ROUTEID <= 0;
-- No record found with negative values

-- Checking whether any source airport id does not match airport id
Select count(*) from ROUTE where SOURCEAIRPORTID not IN (Select a.AIRPORTID from airport a);
--0

-- Checking whether any destination airport id does not match airport id
Select count(*) from ROUTE where DESTAIRPORTID not IN (Select a.AIRPORTID from airport a);
--0

--Checking whether airline id in route is matching airline id in airline table
Select count(*) from ROUTE where AIRLINEID not IN (Select a.AIRLINEID from AIRLINE a);
--1
-- fetching that 1 record
Select * from ROUTE where AIRLINEID not IN (Select a.AIRLINEID from AIRLINE a);

--Validating the record with airlineid = 9999
Select count(*) from AIRLINE where AIRLINEID = 9999;
--0
--The row with airline id = 9999 does not exist so we delete this record as it is invalid

--Deleting the record from routes table with airlineid = 9999
delete from ROUTE where AIRLINEID = 9999;
--1 row deleted

--Validating if the record still exists
Select count(*) from ROUTE where AIRLINEID not IN (Select a.AIRLINEID from AIRLINE a);
--0

--checking route id is unique
Select distinct count(*) from ROUTE;
--58443

Select count(*) from ROUTE;
--58443

--Checking whether there is any route is without airline 
Select COUNT(*) from ROUTE where AIRLINEID is not null;
--58443

--Doing data cleaning for airport
Select COUNT(*) from AIRPORT where AIRPORTID is  null;
--0

Select COUNT(*) from AIRPORT where AIRPORTID is  not null;
--7738

-- Checking negative values for airlineid
select * from AIRPORT where AIRPORTID <= 0;
-- found five value having arlineid = -1,-2,-3,-4,-5

--Deleting the records from airport table with AIRPORTID = -1,-2,-3,-4,-5
delete from AIRPORT where AIRPORTID = -1 or AIRPORTID = -2 or AIRPORTID = -3 or AIRPORTID = -4 or AIRPORTID = -5;
--5 rows deleted

-- Checking for deleted values for airportid
select count(*) from AIRPORT where AIRPORTID <= 0;
-- 0

--Checking airline_service
select count(*) from AIRLINE_SERVICE;
-- 11

-- checking whether there is any null values 
Select COUNT(*) from AIRLINE_SERVICE where SERVICEID is  null;
-- 0

-- checking for any Repetitions is any name values 
select distinct count(name) from AIRLINE_SERVICE;
-- 11

-- Checking negative values for serviceid
select count(*) from AIRLINE_SERVICE where SERVICEID <= 0;
-- 0

-- Checking Airline

-- Checking for number of records in airline 
Select COUNT(*) from AIRLINE;
--5987 records

-- Checking for null values in AirlineID
Select COUNT(*) from AIRLINE where AIRLINEID is null;
-- 0

-- Checking negative values for airlineid
select * from AIRLINE where AIRLINEID <= 0;
-- found one value having arlineid = -1

-- deleting one record having airlineID = -1
Delete from AIRLINE where AIRLINEID = -1;
-- 1 row deleted.

-- Verifying the records having a negative airlineId no more exists
select count(*) from AIRLINE where AIRLINEID <= 0;
-- 0

--checking provides

-- Checking for the number of records in Provides
select count(*) from PROVIDES;
-- 20981

--Checking for any unmatched airline and service IDs from airline and airline_service 
Select count(*) from PROVIDES where AIRLINEID not IN (Select a.AIRLINEID
from AIRLINE a);
-- 0

-- Checking for any serviceID that does not exist in Airline_Service table
Select count(*) from PROVIDES where SERVICEID not IN (Select s.SERVICEID
from AIRLINE_SERVICE s);
-- 0

-- Checking negative values for serviceid
select count(*) from PROVIDES where SERVICEID <= 0;
-- found 0 value having ServiceID 

-- Checking negative values for airlineID
select count(*) from PROVIDES where AIRLINEID <= 0;
-- found 0 value having AirlineID 

-- Checking Flights
select count(*) from FLIGHT;
--50002

--checking for null values
select count(*) from FLIGHT where ROUTEID is null;
--0

select count(*) from FLIGHT where AIRCRAFTID is null;
--0

select count(*) from FLIGHT where FLIGHTID is null;
--0

-- Checking for unmatched values for routeid 
Select count(*) from FLIGHT where ROUTEID not IN (Select r.ROUTEID from ROUTE r);
--0

-- Checking for unmatched values for aircraftID
Select count(*) from FLIGHT where AIRCRAFTID not IN (Select a.IATACODE from AIRCRAFT a);
--2

--fetching 2 invalid rows
Select * from FLIGHT where AIRCRAFTID not IN (Select a.IATACODE from AIRCRAFT a);
--We are deleting these two rows as they have invalid aircraftIDs

-- found 2 rows with 5137 as aircraftID not present in aircraft table
select count(*) from AIRCRAFT where IATACODE = '5137';
--0

--Deleting the two records with aircraftID = 5137 from flight table
delete from FLIGHT where AIRCRAFTID = '5137';
--2 rows deleted

--Validating if there still exists invalid aircraftID in flight
Select count(*) from FLIGHT where AIRCRAFTID not IN (Select a.IATACODE from AIRCRAFT a);
--0

--Do we have to check the flight timings with respect to time zone?????????
select * from FLIGHT where DEPARTTIME > ARRIVALTIME;

--checking for negative fares
Select count(*) from FLIGHT where fare <= 0;
--0

-- Checking invalid values for FlightID
Select count(*) from FLIGHT where FLIGHTID LIKE '-%';
-- 0

--Checking for negative values for routeid
Select count(*) from FLIGHT where ROUTEID <= 0;
--0

--Checking for invalid values for aircraftid
Select count(*) from FLIGHT where AIRCRAFTID LIKE '-%';
-- 0

--Checking aircraft
select count(*) from AIRCRAFT;
-- 357

--checking for negative values
select count(*) from AIRCRAFT where IATACODE like '-%';
-- 0




--checking for invalid wakecategory
select * from AIRCRAFT where WAKECATEGORY not in ('M','H','L');
-- 4 rows
-- Confused if we should delete these
-- Some rows are with model as null.. will it matter?

select * from AIRCRAFT where MODEL LIKE '-%';
--We found 5 rows with - in front.. should we remove the rows or update them by removing -




select count(*) from AIRCRAFT where MANUFACTURER LIKE '-%';
--found zero rows

--Checking passenger
select count(*) from PASSENGER;
-- 10004 records found but assignment specification tells that we have records of 10000 passengers

-- Checking for negative values of PASSID
select * from PASSENGER where PASSID <= 0;
-- found 0 rows

-- Checking for negative values in Age
select count(*) from PASSENGER where AGE < 0;
-- 5 rows

--fetching 5 records
select * from PASSENGER where AGE < 0;
-- we are deleting these records as age cannot be negative.

--Deleting 5 records
Delete from PASSENGER where age < 0;
-- 5 rows deleted

--Validating if any other records with negative age value exits
select count(*) from PASSENGER where AGE < 0;
--0

-- Checking for 0 values in Age
select count(*) from PASSENGER where AGE = 0;
-- found 149 rows but we are keeping these values as infant can also travel
 
-- Checking transaction

-- Checking for values
select count(*) from TRANSACTION;
-- 25005 records found.

-- Checking for unmatched PassId values
Select count(*) from TRANSACTION where PASSID not IN (Select p.PASSID
from PASSENGER p);
-- found 0 rows.

-- Checking for unmatched FlightID values
Select count(*) from TRANSACTION where FLIGHTID not IN (Select f.FLIGHTID
from FLIGHT f);
-- 5 values found

--fetching those 5 records
Select * from TRANSACTION where FLIGHTID not IN (Select f.FLIGHTID
from FLIGHT f);
-- we are deleting these 5 values 

--Checking for these values in flight table
select * from FLIGHT where FLIGHTID like 'GHOST%';
--0

--Deleting these 5 records
delete from TRANSACTION where FLIGHTID like 'GHOST%';
--5 rows deleted

--Validating if the transaction table is now cleaned
Select count(*) from TRANSACTION where FLIGHTID not IN (Select f.FLIGHTID
from FLIGHT f);
--0

-- Checking for negative values in Totalpaid
select count(*) from TRANSACTION where TOTALPAID <= 0;
-- found 0 rows

-- Checking for negative values in Discount ???? 
select count(*) from TRANSACTION where DISCOUNT < 0;
-- found 0 rows

-- Checking for booking date between 2006-09
select count(*) from TRANSACTION where to_char(BOOKINGDATE,'YYYY') < '2006' OR to_char(BOOKINGDATE,'YYYY') > '2009';
-- 0 rows

select * from AIRLINE;
Select * from AIRCRAFT;
Select * from ROUTE;
Select * from Airport;
select * from PASSENGER;
select * from TRANSACTION;
select * from PROVIDES;
select * from AIRLINE_SERVICE;
select * from FLIGHT;

--Creating Source Dimension
Create table source_dim as
Select distinct a.AIRPORTID as source_id, a.city, a.country, a.DST
from AIRPORT a, ROUTE r
where a.AIRPORTID = r.SOURCEAIRPORTID
order by a.AIRPORTID;

--Creating Destination Dimension
Create table destination_dim as
Select distinct a.AIRPORTID as destination_id, a.city, a.country,a.DST
from AIRPORT a, ROUTE r
where a.AIRPORTID = r.DESTAIRPORTID
order by a.AIRPORTID;

--Creating Passenger_Type Dimension (children,Teenager,Young, Adult)
Create table passenger_type_dim
(passTypeID number,
 passTypeDesc varchar2 (20),
 beginAge number,
 endAge number
 );

Select max(age) from PASSENGER;
--87

--Inserting values into passenger type dimension
Insert into passenger_type_dim values (1, 'Children', 0, 10);
Insert into passenger_type_dim values (2, 'Teenager', 11, 17);
Insert into passenger_type_dim values (3, 'Young Adult', 18, 35);
Insert into passenger_type_dim values (4, 'Middle Adult', 36, 60);
--Add a assumption for max age 87 so we hav taken 99
Insert into passenger_type_dim values (5, 'Senior Adult', 61, 99);

--Creating Nationlity Dimension
Create table nationality_dim as
Select distinct p.NATIONALITY
from PASSENGER p;

--Create travel class Dimension
Create table travel_class_dim
(travelID number,
 classTypeDesc varchar2 (20)
 );

-- Inserting values into travel class dimension
Insert into travel_class_dim values (1, 'Business Class');
Insert into travel_class_dim values (2, 'First Class');
Insert into travel_class_dim values (3, 'Economy Class');


--Create flight distance dimension
Create table Flight_distance_dim
(flightDistanceId number,
 flightDistanceDesc varchar2 (20),
 minimumDistance number,
 maximumDistance number
 );

--Inserting data into flight Distance dimension
Insert into Flight_distance_dim values (1, 'Small', 0,1199);
Insert into Flight_distance_dim values (2, 'Medium', 1200,4000);
Insert into Flight_distance_dim values (3, 'Large', 4001,10000);
Insert into Flight_distance_dim values (4, 'Very Large', 10001,19999);

--Create Airline dimension
Create Table Airline_dim As
Select a.AIRLINEID, a.NAME, a.COUNTRY, a.ACTIVE, round(1.0/count(p.SERVICEID),2) As
WeightFactor , LISTAGG (p.SERVICEID, '_') Within Group (Order By
p.SERVICEID) As ServiceGroupList
From Airline a, Provides p
Where a.AIRLINEID = p.AIRLINEID
Group By a.AIRLINEID, a.NAME, a.COUNTRY, a.ACTIVE;

--Create flight_type dimension
Create table Flight_Type_dim
(flightTypeId number,
 flightTypeDesc varchar2 (20)
 );
  
--Insert data into flight type dimension
Insert into Flight_Type_dim values (1, 'Domestic');
Insert into Flight_Type_dim values (2, 'International');

--Creating Airline service dimension
Create table Airline_Service_dim
AS
Select * from AIRLINE_SERVICE;

--Creating provides bridge table
Create table Provides_bridge
AS
Select * from PROVIDES;

--Create time dimension
Create table time_dim as
Select distinct to_char(Flightdate,'MM') || to_char(Flightdate, 'YYYY') || to_char(Flightdate, 'DAY')as timeId, to_char(Flightdate, 'YYYY') as yearNo,
to_char(Flightdate,'MM') as monthName,
to_char(Flightdate, 'DAY') as weekDay from flight
order by yearNo;

--Create temporary passtransfact table
Create table temp_passtransfact as
Select r.sourceairportid, r.DESTAIRPORTID, p.nationality, ar.airlineid, count(p.passid) as TotalNumberOfPassengers,
  sum(p.age) as TotalAgeOfPassengers, count(t.passid) as TotalNumberOfTransactions, sum(t.totalpaid) as SumOfTotalPaid,
  sum(r.Distance) as TotalTravelDistance, sum(f.fare) as TotalFlightFare, p.AGE, f.fare, t.TOTALPAID, r.DISTANCE, a1.COUNTRY as SourceCountry, 
  a2.country as DestCountry, f.FLIGHTDATE
from Route r, airport a1, airport a2, flight f, transaction t, passenger p, airline ar
where r.sourceairportid = a1.AIRPORTID and
  r.DESTAIRPORTID = a2.AIRPORTID and
  r.routeid = f.routeid and f.flightid = t.flightid and
  p.passid = t.passid and
  ar.AIRLINEID = r.AIRLINEID
group by r.sourceairportid, r.DESTAIRPORTID, p.nationality, ar.airlineid, p.AGE, f.FARE, t.TOTALPAID, r.distance, a1.COUNTRY, a2.country, f.FLIGHTDATE;


--Alter for passenger type
Alter table temp_passtransfact
add(passTypeID number);

--update for passenger type
update temp_passtransfact
set passTypeID =1
where Age >= 0
and Age <= 10;

update temp_passtransfact
set passTypeID =2
where Age >= 11
and Age <= 17;

update temp_passtransfact
set passTypeID =3
where Age >= 18
and Age <= 35;

update temp_passtransfact
set passTypeID =4
where Age >= 36
and Age <= 60;

update temp_passtransfact
set passTypeID =5
where Age >= 61
and Age <= 99;

-- Alter travel class dimension
Alter table temp_passtransfact
add(travelID number);

-- Update queries for travel class dimension

update temp_passtransfact
set TRAVELID = 1
where TOTALPAID >= 1.8*FARE;

update temp_passtransfact
set TRAVELID = 2
where TOTALPAID >= 1.3*FARE
and TOTALPAID < 1.8*FARE;

update temp_passtransfact
set TRAVELID = 3
where TOTALPAID < 1.3*FARE;

-- Alter table for Flight Distance Dim
Alter table temp_passtransfact
add(flightDistanceid number);

-- Update queries for Flight Distance Dim

update temp_passtransfact
set FLIGHTDISTANCEID = 1
where DISTANCE >= 0
AND DISTANCE <= 1199;

update temp_passtransfact
set FLIGHTDISTANCEID = 2
where DISTANCE >= 1200
AND DISTANCE <= 4000;

update temp_passtransfact
set FLIGHTDISTANCEID = 3
where DISTANCE >= 4001
AND DISTANCE <= 10000;

update temp_passtransfact
set FLIGHTDISTANCEID = 4
where DISTANCE >= 10001
AND DISTANCE <= 19999;

-- Alter table for Flight Type Dim
Alter table temp_passtransfact
add(flightTypeid number);

-- Update queries for Flight Type Dim

update temp_passtransfact
set flightTypeid = 1
where SOURCECOUNTRY = DESTCOUNTRY;

update temp_passtransfact
set flightTypeid = 2
where SOURCECOUNTRY != DESTCOUNTRY;

Create table passtransfact as
Select f.passtypeid, f.NATIONALITY, f.TRAVELID, f.FLIGHTDISTANCEID, f.FLIGHTTYPEID, 
        to_char(f.Flightdate,'MM') || to_char(f.Flightdate, 'YYYY') || to_char(f.Flightdate, 'DAY')as timeId,
        f.SOURCEAIRPORTID, f.DESTAIRPORTID, f.AIRLINEID, f.TOTALNUMBEROFPASSENGERS, f.TOTALAGEOFPASSENGERS,
        sum (f.SUMOFTOTALPAID - f.TOTALFLIGHTFARE) as TotalProfit, f.TOTALNUMBEROFTRANSACTIONS, f.SUMOFTOTALPAID, 
        f.TOTALTRAVELDISTANCE, f.TOTALFLIGHTFARE
from temp_passtransfact f
group by f.passtypeid, f.NATIONALITY, f.TRAVELID, f.FLIGHTDISTANCEID, f.FLIGHTTYPEID, 
        to_char(f.Flightdate,'MM') || to_char(f.Flightdate, 'YYYY') || to_char(f.Flightdate, 'DAY'),
        f.SOURCEAIRPORTID, f.DESTAIRPORTID, f.AIRLINEID, f.TOTALNUMBEROFPASSENGERS, f.TOTALAGEOFPASSENGERS,
        f.TOTALNUMBEROFTRANSACTIONS, f.SUMOFTOTALPAID, 
        f.TOTALTRAVELDISTANCE, f.TOTALFLIGHTFARE;
        
--Fact Table 2

Create table Routesfact as
Select r.sourceairportid, r.DESTAIRPORTID, ar.airlineid, count(r.ROUTEID) as TotalNumberOfRoutes,
  sum(r.SERVICECOST) as TotalServiceCost, sum (r.DISTANCE) as TotalRouteDistance
from Route r, airport a1, airport a2, airline ar
where r.sourceairportid = a1.AIRPORTID and
  r.DESTAIRPORTID = a2.AIRPORTID and
  ar.AIRLINEID = r.AIRLINEID
group by r.sourceairportid, r.DESTAIRPORTID, ar.airlineid;

--Queries to show the data of each created table
select * from PASSENGER_TYPE_DIM;
select * from NATIONALITY_DIM;
select * from TRAVEL_CLASS_DIM;
select * from FLIGHT_DISTANCE_DIM;
select * from FLIGHT_TYPE_DIM;
select * from TIME_DIM;
select * from SOURCE_DIM;
select * from DESTINATION_DIM;
select * from AIRLINE_DIM;
select * from PROVIDES_BRIDGE;
select * from AIRLINE_SERVICE_DIM;
select * from PASSTRANSFACT;
select * from ROUTESFACT;


--Query 1 Show All
--What is the total number of passengers who departed from cities of Australia each year?

Select t.YEARNO as Year, s.city as Source_City, sum(f.TOTALNUMBEROFPASSENGERS) as Total_Number_Of_Passengers
from source_dim s, passtransfact f, time_dim t
where s.SOURCE_ID = f.SOURCEAIRPORTID and
t.TIMEID = f.TIMEID and
s.COUNTRY = 'Australia'
group by t.YEARNO, s.city 
order by t.YEARNO, s.city;

--Query 2 
-- Which are the top 3 airlines with maximum profit for Australia in the year 2007 and show whether they are active or not?

SELECT *
FROM
(SELECT a.Name, a.ACTIVE, SUM(f.TOTALPROFIT) AS Profit,
RANK() OVER (ORDER BY SUM(f.TOTALPROFIT) DESC ) AS
Airline_RANK
 FROM passtransfact f, AIRLINE_DIM a, TIME_DIM t
 WHERE f.TIMEID = t.TIMEID
AND f.AIRLINEID = a.AIRLINEID
AND a.Country = 'Australia'
AND t.YEARNO = 2007
GROUP BY a.Name, a.ACTIVE)
WHERE Airline_RANK <= 3;

--Query 3 
--Question: Calculate the top 5% of the total service cost of qantas airlines from different source cities?
SELECT *
FROM (
 SELECT
 s.CITY as source_city, ar.NAME,
 sum(f.TotalServiceCost) AS Total_Service_Cost,
 percent_rank() over
 (order by sum(f.TotalServiceCost) ) as "Percent Rank"
 FROM Routesfact f, source_dim s, AIRLINE_DIM ar
 WHERE f.SOURCEAIRPORTID = s.source_id
 AND f.AIRLINEID = ar.AIRLINEID
 AND ar.NAME = 'Qantas'
 GROUP BY s.CITY, ar.NAME
) WHERE "Percent Rank" >= 0.95; 


--Report 4 City-to-City Routes' Report
select decode(grouping(s.CITY),1,'Any City',s.CITY) as "Departure City",
decode(grouping(s.COUNTRY),1,'Any Country',s.COUNTRY) as "Departure Country",
decode(grouping(d.CITY),1,'Any City',d.CITY) as "Arrival City",
decode(grouping(d.COUNTRY),1,'Any Country',d.COUNTRY) as "Arrival Country",
sum(r.TOTALNUMBEROFROUTES) as "Number of routes", 
sum(r.TOTALROUTEDISTANCE)/sum(r.TOTALNUMBEROFROUTES) as "Average Distance"
from destination_dim d, source_dim s, routesfact r
where d.DESTINATION_ID= r.DESTAIRPORTID
and s.SOURCE_ID = r.SOURCEAIRPORTID
group by cube(s.CITY,s.COUNTRY,d.CITY, d.COUNTRY)
order by s.CITY,s.COUNTRY,d.CITY,d.COUNTRY; 

--Report 5 Airline's Report
SELECT t.YEARNO, ar.NAME, 
decode(grouping(ft.FLIGHTTYPEDESC),1,'All Flight Type',ft.FLIGHTTYPEDESC) AS FlightType, 
decode(grouping(s.COUNTRY),1,'Any Country',s.COUNTRY) AS SourceCountry, 
decode(grouping(d.COUNTRY),1,'Any Country',d.COUNTRY) AS DestinationCountry, 
sum(f.TOTALNUMBEROFTRANSACTIONS) AS "Number of Transactions", 
sum(f.TOTALPROFIT) AS "Average Agent Profit"
FROM passtransfact f, time_dim t, airline_dim ar, Flight_Type_dim ft, source_dim s, destination_dim d
WHERE f.TIMEID = t.TIMEID 
and f.AIRLINEID = ar.AIRLINEID
and f.FLIGHTTYPEID = ft.FLIGHTTYPEID
and f.SOURCEAIRPORTID = s.SOURCE_ID
and f.DESTAIRPORTID = d.DESTINATION_ID
GROUP by  t.YEARNO, ar.NAME, rollup(ft.FLIGHTTYPEDESC, s.COUNTRY, d.COUNTRY)
order by t.YEARNO, ar.NAME, ft.FLIGHTTYPEDESC, s.COUNTRY, d.COUNTRY;

--Report 6 Flight's Report
SELECT t.WEEKDAY,  
decode(grouping(ft.FLIGHTTYPEDESC),1,'All Flight Type',ft.FLIGHTTYPEDESC) AS FlightType,
decode(grouping(tr.CLASSTYPEDESC),1,'Any Class',tr.CLASSTYPEDESC) AS FlightClass,
decode(grouping(s.COUNTRY),1,'Any Country',s.COUNTRY) AS SourceCountry, 
decode(grouping(d.COUNTRY),1,'Any Country',d.COUNTRY) AS DestinationCountry, 
sum(f.TOTALNUMBEROFTRANSACTIONS) AS "Number of Transactions", 
(sum(f.SUMOFTOTALPAID)/ sum(f.TOTALNUMBEROFTRANSACTIONS)) AS "Average Paid Ticket (USD)"
FROM passtransfact f, time_dim t, TRAVEL_CLASS_DIM tr, Flight_Type_dim ft, source_dim s, destination_dim d
WHERE f.TIMEID = t.TIMEID 
and f.TRAVELID = tr.TRAVELID
and f.FLIGHTTYPEID = ft.FLIGHTTYPEID
and f.SOURCEAIRPORTID = s.SOURCE_ID
and f.DESTAIRPORTID = d.DESTINATION_ID
GROUP by  t.WEEKDAY,  rollup(ft.FLIGHTTYPEDESC,tr.CLASSTYPEDESC, s.COUNTRY, d.COUNTRY)
order by t.WEEKDAY, ft.FLIGHTTYPEDESC,tr.CLASSTYPEDESC, s.COUNTRY, d.COUNTRY;

--Report 7
--Question-- What is the total revenue generated in the month of September for each flight type per travel class?
SELECT t.YEARNO, t.MONTHNAME,
decode(grouping(ft.FLIGHTTYPEDESC),1,'All Flight Type',ft.FLIGHTTYPEDESC) AS FlightType,
decode(grouping(tr.CLASSTYPEDESC),1,'Any Class',tr.CLASSTYPEDESC) AS FlightClass,
sum(f.SUMOFTOTALPAID) as Total_Revenue
FROM TIME_DIM t, FLIGHT_TYPE_DIM ft, TRAVEL_CLASS_DIM tr, PASSTRANSFACT f
WHERE f.TIMEID = t.TIMEID
AND ft.FLIGHTTYPEID = f.FLIGHTTYPEID
AND tr.TRAVELID = f.TRAVELID
and t.YEARNO = 2007
and t.MONTHNAME = 09
GROUP BY CUBE(t.YEARNO, t.MONTHNAME, ft.FLIGHTTYPEDESC, tr.CLASSTYPEDESC)
Order by t.YEARNO, t.MONTHNAME;

--Report 8
--Question-- What is the total travel distance travelled by selected airlines ('China Eastern Airlines','IndiGo Airlines','Virgin America') 
--for each year per flight type
SELECT 
decode(grouping(t.YEARNO),1,'All Years',t.YEARNO) as Year,
decode(grouping(a.NAME),1,'All AirLines',a.NAME) AS AirlineName,
decode(grouping(ft.FLIGHTTYPEDESC),1,'All Types',ft.FLIGHTTYPEDESC) AS FlightType,
sum(f.TotalTravelDistance) as Total_Distance
FROM TIME_DIM t, AIRLINE_DIM a, FLIGHT_TYPE_DIM ft, PASSTRANSFACT f
WHERE f.TIMEID = t.TIMEID
AND ft.FLIGHTTYPEID = f.FLIGHTTYPEID
AND a.airlineid = f.airlineid
and a.name IN ('China Eastern Airlines','IndiGo Airlines','Virgin America')
GROUP BY ROLLUP(t.YEARNO, a.NAME, ft.FLIGHTTYPEDESC)
Order by t.YEARNO, a.NAME, ft.FLIGHTTYPEDESC;

--Report 9
--Question-- What are the total and cumulative monthly profits of small flight distance departing from Sydney airport in 2007?
SELECT t.yearNo, t.monthname, f.flightdistancedesc, s.city as source_city,
TO_CHAR (SUM(p.TotalProfit), '9,999,999,999') AS TotalProfit,
TO_CHAR (SUM(SUM(p.TotalProfit)) OVER
(ORDER BY t.yearNo, t.monthname, f.flightdistancedesc, s.city ROWS UNBOUNDED PRECEDING),
'9,999,999,999') AS CUM_profit
FROM time_dim t, passtransfact p, flight_distance_dim f, source_dim s
WHERE t.TIMEID = p.TIMEID
AND s.SOURCE_ID = p.SOURCEAIRPORTID
and f.FLIGHTDISTANCEID = p.FLIGHTDISTANCEID
AND t.YEARNO = 2007
AND f.FLIGHTDISTANCEDESC = 'Small'
and s.CITY = 'Sydney'
GROUP BY t.yearNo, t.monthname, f.flightdistancedesc, s.city; 

--Report 10
--Question--What are the total and moving 3 monthly transactions of Australian passengers in 2009?
SELECT t.YEARNO,t.MONTHNAME, n.NATIONALITY,
TO_CHAR (SUM(p.TotalNumberofTransactions), '9,999,999,999') AS TotalTransactions,
TO_CHAR (AVG(SUM(p.TotalNumberofTransactions)) OVER
(ORDER BY t.YEARNO,t.MONTHNAME, n.NATIONALITY
rows 2 preceding),
 '9,999,999,999') AS moving_3_month_avg
FROM TIME_DIM t, PASSTRANSFACT p, NATIONALITY_DIM n
WHERE t.TIMEID = p.TIMEID
AND n.NATIONALITY = p.NATIONALITY
AND t.YEARNO=2009
and n.NATIONALITY= 'Australian'
GROUP BY t.YEARNO,t.MONTHNAME, n.NATIONALITY; 

--Report 11 What are the total and cumulative monthly profits from Middle Adult passengers travelling by Southwest Airlines every year?

SELECT p.PASSTYPEDESC, a.NAME, t.YEARNO, t.MONTHNAME, 
TO_CHAR (SUM(f.TOTALPROFIT), '9,999,999,999') AS PROFIT,
TO_CHAR (SUM(SUM(f.TOTALPROFIT)) OVER
(PARTITION BY t.YEARNO ORDER BY p.PASSTYPEDESC, a.NAME, t.YEARNO, t.MONTHNAME desc
 ROWS UNBOUNDED PRECEDING),
'9,999,999,999') AS CUM_PROFIT
FROM PASSENGER_TYPE_DIM p, PASSTRANSFACT f, TIME_DIM t, AIRLINE_DIM a
WHERE p.passtypeid = f.passtypeid
AND t.TIMEID = f.TIMEID
AND a.AIRLINEID = f.AIRLINEID
AND a.NAME = 'Southwest Airlines'
AND p.PASSTYPEDESC = 'Middle Adult'
GROUP BY p.PASSTYPEDESC, a.NAME, t.YEARNO, t.MONTHNAME; 


--Report 12
--What are the total and moving 3 monthly number of passengers travelling in business class in flights departing from canada?

SELECT tr.CLASSTYPEDESC, s.COUNTRY, t.YEARNO,
TO_CHAR(SUM(f.TOTALNUMBEROFPASSENGERS)) AS "NumberOf Passengers",
TO_CHAR(AVG(SUM(f.TOTALNUMBEROFPASSENGERS)) OVER
(PARTITION BY t.YEARNO ORDER BY SUM(f.TOTALNUMBEROFPASSENGERS)  
 ROWS 2 PRECEDING)) AS MOVING_3_YEAR,
TO_CHAR (AVG(SUM(f.TOTALNUMBEROFPASSENGERS)) OVER
(partition by tr.classtypedesc ORDER BY sum(f.TOTALNUMBEROFPASSENGERS)   
 ROWS 2 PRECEDING)) AS MOVING_3_TravelClass
FROM PASSTRANSFACT f, TRAVEL_CLASS_DIM tr, SOURCE_DIM s, TIME_DIM t
WHERE t.TIMEID = f.TIMEID
AND tr.travelid = f.travelid
and s.source_id = f.sourceairportid
AND s.country = 'Canada'
GROUP BY tr.CLASSTYPEDESC, s.COUNTRY, t.YEARNO;

--Report 13
--Question-- What are the city ranks by total service cost of source airports in each country?
SELECT s.country,s.city,
TO_CHAR(SUM(TotalServiceCost)) AS TotalServiceCost,
RANK() OVER (PARTITION BY s.country
ORDER BY SUM(TotalServiceCost) DESC) AS RANK_BY_COUNTRY
FROM source_dim s, routesfact r
WHERE s.source_id=r.sourceairportid
GROUP BY s.country,s.city; 

--Report 14
-- What is the top 10% total revenue by nationality('Angolan','Australian','British','Bangladeshi','Chinese','Batswana') and travel class 

 
select * 
from (
 SELECT
n.NATIONALITY, tr.classtypedesc,
 sum(f.SUMOFTOTALPAID) as "Total Revenue",
  percent_rank() over
 (partition by n.nationality order by sum(f.SUMOFTOTALPAID)) as "Percent Rank by nationality",
 percent_rank() over
 (partition by tr.classtypedesc order by sum(f.SUMOFTOTALPAID)) as "Percent Rank by travel class"
 FROM PASSTRANSFACT f, TRAVEL_CLASS_DIM tr, NATIONALITY_DIM n
 WHERE tr.TRAVELID = f.TRAVELID
 and n.NATIONALITY = f.NATIONALITY
 and n.NATIONALITY IN ('Angolan','Australian','British','Bangladeshi','Chinese','Batswana')
 GROUP BY n.NATIONALITY, tr.classtypedesc
 ) where "Percent Rank by nationality" >= 0.9;
 
 
--Report 14
explain plan for
select * 
from (
 SELECT
n.NATIONALITY, tr.classtypedesc,
 sum(f.SUMOFTOTALPAID) as "Total Revenue",
  percent_rank() over
 (partition by n.nationality order by sum(f.SUMOFTOTALPAID)) as "Percent Rank by nationality",
 percent_rank() over
 (partition by tr.classtypedesc order by sum(f.SUMOFTOTALPAID)) as "Percent Rank by travel class"
 FROM PASSTRANSFACT f, TRAVEL_CLASS_DIM tr, NATIONALITY_DIM n
 WHERE tr.TRAVELID = f.TRAVELID
 and n.NATIONALITY = f.NATIONALITY
 and n.NATIONALITY IN ('Angolan','Australian','British','Bangladeshi','Chinese','Batswana')
 GROUP BY n.NATIONALITY, tr.classtypedesc
 ) where "Percent Rank by nationality" >= 0.9;
 
select * from table(dbms_xplan.display);
 
-- Report 13
Explain plan for
SELECT s.country,s.city,
TO_CHAR(SUM(TotalServiceCost)) AS TotalServiceCost,
RANK() OVER (PARTITION BY s.country
ORDER BY SUM(TotalServiceCost) DESC) AS RANK_BY_COUNTRY
FROM source_dim s, routesfact r
WHERE s.source_id=r.sourceairportid
GROUP BY s.country,s.city; 

select * from table(dbms_xplan.display);


--Report 12
Explain plan for
SELECT tr.CLASSTYPEDESC, s.COUNTRY, t.YEARNO,
TO_CHAR(SUM(f.TOTALNUMBEROFPASSENGERS)) AS "NumberOf Passengers",
TO_CHAR(AVG(SUM(f.TOTALNUMBEROFPASSENGERS)) OVER
(PARTITION BY t.YEARNO ORDER BY SUM(f.TOTALNUMBEROFPASSENGERS)  
 ROWS 2 PRECEDING)) AS MOVING_3_YEAR,
TO_CHAR (AVG(SUM(f.TOTALNUMBEROFPASSENGERS)) OVER
(partition by tr.classtypedesc ORDER BY sum(f.TOTALNUMBEROFPASSENGERS)   
 ROWS 2 PRECEDING)) AS MOVING_3_TravelClass
FROM PASSTRANSFACT f, TRAVEL_CLASS_DIM tr, SOURCE_DIM s, TIME_DIM t
WHERE t.TIMEID = f.TIMEID
AND tr.travelid = f.travelid
and s.source_id = f.sourceairportid
AND s.country = 'Canada'
GROUP BY tr.CLASSTYPEDESC, s.COUNTRY, t.YEARNO;

Select * from table(dbms_xplan.display);

--Report 11
Explain plan for
SELECT p.PASSTYPEDESC, a.NAME, t.YEARNO, t.MONTHNAME, 
TO_CHAR (SUM(f.TOTALPROFIT), '9,999,999,999') AS PROFIT,
TO_CHAR (SUM(SUM(f.TOTALPROFIT)) OVER
(PARTITION BY t.YEARNO ORDER BY p.PASSTYPEDESC, a.NAME, t.YEARNO, t.MONTHNAME desc
 ROWS UNBOUNDED PRECEDING),
'9,999,999,999') AS CUM_PROFIT
FROM PASSENGER_TYPE_DIM p, PASSTRANSFACT f, TIME_DIM t, AIRLINE_DIM a
WHERE p.passtypeid = f.passtypeid
AND t.TIMEID = f.TIMEID
AND a.AIRLINEID = f.AIRLINEID
AND a.NAME = 'Southwest Airlines'
AND p.PASSTYPEDESC = 'Middle Adult'
GROUP BY p.PASSTYPEDESC, a.NAME, t.YEARNO, t.MONTHNAME; 

Select * from table(dbms_xplan.display);

--Report 10
Explain plan for
SELECT t.YEARNO,t.MONTHNAME, n.NATIONALITY,
TO_CHAR (SUM(p.TotalNumberofTransactions), '9,999,999,999') AS TotalTransactions,
TO_CHAR (AVG(SUM(p.TotalNumberofTransactions)) OVER
(ORDER BY t.YEARNO,t.MONTHNAME, n.NATIONALITY
rows 2 preceding),
 '9,999,999,999') AS moving_3_month_avg
FROM TIME_DIM t, PASSTRANSFACT p, NATIONALITY_DIM n
WHERE t.TIMEID = p.TIMEID
AND n.NATIONALITY = p.NATIONALITY
AND t.YEARNO=2009
and n.NATIONALITY= 'Australian'
GROUP BY t.YEARNO,t.MONTHNAME, n.NATIONALITY; 

Select * from table(dbms_xplan.display);