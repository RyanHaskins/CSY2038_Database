--CSY2038 PR1 Assignment - QUERIES

/*
Group 1
Josh Challand - 14414449
Julius Prakelis - 16430034
Ryan Haskins - 16442673
Tony Eardley - 14417434
*/

--Tony Login CSY2038_296@student/CSY2038_296
--Josh Login CSY2038_249@student/CSY2038_249
--Ryan Login CSY2038_286@student/16442673
--Julius Login - CSY2038_251@student/CSY2038_251

--@E:\scripts\queries.sql

/* Useful Commands
SET WRAP OFF;
CLEAR COLUMNS;
*/



/* ******************************
*								*
*		Queries		*
*								*
*********************************/
--Lists the booking with the highest cost with functions (CEIL, FLOOR, ROUND, TRUNC) - Formatted with headings
COLUMN booking_id HEADING 'Booking'
COLUMN CEIL(cost) HEADING 'CEIL'
COLUMN FLOOR(cost) HEADING 'FLOOR'
COLUMN ROUND(cost) HEADING 'ROUND'
COLUMN TRUNC(cost) HEADING 'TRUNC'
SELECT booking_id, CEIL(cost), FLOOR(cost), ROUND(cost), TRUNC(cost), cost
FROM bookings
WHERE cost = (
	SELECT MAX(cost)
	FROM bookings
);
--Test - Expected Results '2880000' to be the MAX cost
--SELECT MAX(cost)
--FROM bookings;
-- Result -- success: 
-- 1 row returned with the max cost
	
	
	
--Lists customer rooms located in cities where designers are located within the UK
COLUMN customer_id HEADING 'Customer ID'
COLUMN booking_id HEADING 'Booking ID' 
COLUMN address.street HEADING 'Street' FORMAT A25
COLUMN address.city HEADING 'City' FORMAT A15
COLUMN address.country HEADING 'Country' FORMAT A10
SELECT cr.customer_id, cr.booking_id, cr.address.street, cr.address.city, cr.address.country
FROM customer_rooms cr
WHERE cr.address.city IN (
	SELECT d.address.city
	FROM designers d
	WHERE d.address.country = 'UK'
);
--Test - Expected Result = 3 rows selected
--SELECT d.address.city
--FROM designers d;
--SELECT cr.address.city
--FROM customer_rooms cr;
--Result -success:
-- List of the cities as expected is returned



--Pulls through designers id and show their ratings 
COLUMN d.designer_id HEADING 'Designer ID'
COLUMN AVG(t.rating) HEADING 'Rating'
SELECT d.designer_id, AVG(t.rating)
FROM designers d
LEFT JOIN testimonials t
ON d.designer_id = t.designer_id
GROUP BY d.designer_id;
--Test Expected result will be to pull through all the designers id's and their ratings  
-- Results: List of designers returned with and without rating



--Will pull through all designers id first and last name and will show if they have any bookings 
COLUMN booking_id HEADING 'Booking ID'
COLUMN designer_id HEADING 'Designer ID'
COLUMN firstname HEADING 'First Name' FORMAT A10
COLUMN lastname HEADING 'Last Name' FORMAT A20
SELECT d.designer_id, d.firstname, d.lastname, b.booking_id, b.completed
FROM designers d
LEFT JOIN bookings b
ON b.designer_id = d.designer_id;
--Expected result - mix of designers with and without bookings assigned to them. 
--Results - success: 6 rows returned 
--List of designers with and without bookings returned



--Pulls through designer id name and their social networking sites --
COLUMN designer_id HEADING 'Designer ID'
COLUMN firstname HEADING 'First Name'
COLUMN lastname HEADING 'Last Name'
COLUMN contact FORMAT A30
SELECT d.designer_id, d.firstname, d.lastname, s.contact
FROM designers d, TABLE(d.social_media) s;
--Expected result - list all the different social networking url's for each designer
--Result - success:
--9 rows returned.
--Listing all social media contact details



--Pull through designers and their address --
COLUMN designer_id HEADING 'Designer ID'
COLUMN firstname HEADING 'First Name' FORMAT A10
COLUMN lastname HEADING 'Last Name' FORMAT A10
COLUMN address.house_number HEADING 'House No.' FORMAT A5
COLUMN address.street HEADING 'Street' FORMAT A20
COLUMN address.city HEADING 'City' FORMAT A10
COLUMN address.postcode HEADING 'Postcode' FORMAT A10
SELECT d.designer_id, d.firstname, d.lastname, d.address.house_number, d.address.street, d.address.city, d.address.postcode
FROM designers d
ORDER BY designer_id;
--Expected results - show the designers name id and address details. 
--Result - success: 
--List of designer ID and all address details returned



--DREF Query getting the address and matching it to the customer
COLUMN customer_id HEADING 'Customer ID'
COLUMN DEREF(address) HEADING 'Address'
SELECT customer_id, DEREF(address) 
FROM customer_rooms
WHERE customer_id IN (
	SELECT customer_id
	FROM customers
	WHERE customer_id = '20000001'
);
--Expected result - query will display the customer address = 20000000
--Result - success:
--List of customer addresses with the matching ID returned

	
	
--Pulling through every customers emergency details using  a varray query with dot notation
COLUMN customer_id HEADING 'Customer ID'
COLUMN firstname HEADING 'Firstname'
COLUMN lastname HEADING 'Lastname'
COLUMN contact_type HEADING 'Contact Type'	
COLUMN contact_info HEADING 'Contact Number'
SELECT c.customer_id, c.firstname, c.lastname, co.contact_type, co.contact_info
FROM customers c, TABLE(c.contact) co
WHERE co.contact_type = 'EMERGENCY';
--Expected result - list all customers and their emergency contact details
--Result - success:
--List of all customers and emergency contact details returned



--Shows all customer_id's that have a customer_room and a Booking
COLUMN customer_id HEADING 'Customer ID'
SELECT customer_id FROM customers
INTERSECT
SELECT customer_id FROM customer_rooms
MINUS 
SELECT booking_id FROM customer_rooms;
--Expected result: will display customers that have a customer room and a booking allocated to them
--Result - success:
--List of customer ID`s returned