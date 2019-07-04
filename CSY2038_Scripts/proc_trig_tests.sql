--CSY2038 PR1 Assignment - proc_trig_tests

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

--@E:\scripts\proc_trig_tests.sql

/* Useful Commands
SET WRAP OFF;
CLEAR COLUMNS;
*/



/* ******************************
*								*
*		Procedure Test(s)		*
*								*
*********************************/
--test proc_retire_param
EXEC proc_retire_param(10000000, 67);
--300 months until retirement. 
--Success
EXEC proc_retire_param(10000000, 60);
--216 months until retirement. 
EXEC proc_retire_param(40000000, 57);
--40000000 does not exist within the database as a designer.
EXEC proc_retire_param(10000000, 0);
--Designer is able to retire.
--10000000 has  months until retirement.



--test proc_higher_rate
EXEC proc_higher_rate(5);
--Designers with a rating higher than 5
--1 Designer ID: 10000001 Designers Rating: 7
--2 Designer ID: 10000001 Designers Rating: 7
--3 Designer ID: 10000001 Designers Rating: 10
--4 Designer ID: 10000003 Designers Rating: 6
--Success
SELECT designer_id, rating FROM testimonials WHERE rating > 5;
--   10000001          7
--   10000001          7
--   10000001         10
--   10000003          6
--Success



/* ******************************
*								*
*		Trigger Test(s)			*
*								*
*********************************/
--test trig_designer
INSERT INTO designers (designer_id, firstname, lastname, dob)
VALUES (designers_seq.NEXTVAL, 'JOSH', 'LAND', '26-JAN-1995');
--You are adding JOSH who is 23 years old. - Success
UPDATE designers SET lastname = 'CHALLAND'
WHERE designer_id = 10000005;
--252 months until retirement. - Success
DELETE FROM designers WHERE designer_id = 10000005;
--You are deleting JOSH. - Success



--test trig_booking_cost
--booking_id: 40000000
SELECT booking_id FROM bookings WHERE booking_id = 40000000;
--original cost: 766.75
SELECT cost FROM bookings WHERE booking_id = 40000000;
--desinger_id: 10000000
--SELECT designer_id FROM bookings WHERE booking_id = 40000000;
--pay_rate: 9 
--SELECT pay_rate FROM designers WHERE designer_id = 10000000;
INSERT INTO testimonials (testimonial_id, designer_id, rating)
VALUES (testimonials_seq.NEXTVAL, 10000000, 5);
--avg(rating): 5  --select AVG(rating) from testimonials where designer_id = 10000000;
--New cost: 281
INSERT INTO customer_rooms (customer_room_id, customer_id, booking_id, room_width, room_length)
VALUES (customer_rooms_seq.NEXTVAL, 20000000, 40000000, 50, 50);
SELECT booking_id, cost FROM bookings;
--BOOKING_ID       COST
  ---------- ----------
--  40000000        281
--SUCCESS
