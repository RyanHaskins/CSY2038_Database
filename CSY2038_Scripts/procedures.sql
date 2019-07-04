--CSY2038 PR1 Assignment - PROCEDURES

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

--@E:\scripts\procedures.sql

/* Useful Commands
COLUMN object_name FORMAT A20;
COLUMN object_type FORMAT A20;
SELECT object_name, object_type FROM user_objects;
*/



/* ******************************
*								*
*		Create Procedures			*
*								*
*********************************/
--Procedure takes in a designers id and the age at which they plan to retire, it then stores the designers date of birth using a query. the  dob and age they plan to retire is send to a function which returns the number of months they have left until retirement.*/
CREATE OR REPLACE PROCEDURE proc_retire_param 
(in_designer_id designers.designer_id%TYPE, in_retire_age NUMBER)
IS
	vn_months_left NUMBER(3);
	vd_dob DATE;
BEGIN

	SELECT dob
	INTO vd_dob
	FROM designers
	WHERE designer_id = in_designer_id;

	vn_months_left := func_retire_age(vd_dob, in_retire_age);
	
	DBMS_OUTPUT.PUT_LINE(in_designer_id || ' has ' || vn_months_left || ' months until retirement.');
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE( in_designer_id || ' does not exist within the database as a designer.');
	
END proc_retire_param;
/
SHOW ERRORS

--test proc_retire_param
--EXEC proc_retire_param(10000000, 67);
--300 months until retirement. 
--Success
--EXEC proc_retire_param(10000000, 60);
--216 months until retirement. 
--EXEC proc_retire_param(40000000, 57);
--40000000 does not exist within the database as a designer.
--EXEC proc_retire_param(10000000, 0);
--Designer is able to retire.
--10000000 has  months until retirement.



--Procedure takes in a rating and creates a cursor which queries all ratings in testimonials which are greater than the input rating. The procedure then opens the cursors and checks if a row was found, displayingand appropriate message. If a row was found it loops through the results displaying the relevant information from the results found.
CREATE OR REPLACE PROCEDURE proc_higher_rate 
(in_rating testimonials.rating%Type) 
IS	

	CURSOR cur_higher_rate IS
	SELECT t.rating, d.designer_id
	FROM testimonials t 
	JOIN designers d
	ON t.designer_id = d.designer_id
	WHERE rating > in_rating;
	
	rec_cur_higher_rate cur_higher_rate%ROWTYPE;

BEGIN
	OPEN cur_higher_rate;
	FETCH cur_higher_rate INTO rec_cur_higher_rate;
	
	IF cur_higher_rate%NOTFOUND
		THEN
			DBMS_OUTPUT.PUT_LINE('There are no designers with a rating higher than ' || in_rating);
		ELSE
			DBMS_OUTPUT.PUT_LINE('Designers with a rating higher than ' || in_rating);
	END IF;
	
	WHILE cur_higher_rate%FOUND
			LOOP
				DBMS_OUTPUT.PUT_LINE(cur_higher_rate%ROWCOUNT || ' Designer ID: ' || rec_cur_higher_rate.designer_id ||
				' Designers Rating: ' || rec_cur_higher_rate.rating);
				FETCH cur_higher_rate INTO rec_cur_higher_rate;
			END LOOP;
	
	CLOSE cur_higher_rate;
	
END proc_higher_rate;
/
SHOW ERRORS

--test proc_higher_rate
--EXEC proc_higher_rate(5);
--Designers with a rating higher than 5
--1 Designer ID: 10000001 Designers Rating: 7
--2 Designer ID: 10000001 Designers Rating: 7
--3 Designer ID: 10000001 Designers Rating: 10
--4 Designer ID: 10000003 Designers Rating: 6
--Success
--SELECT designer_id, rating FROM testimonials WHERE rating > 5;
--   10000001          7
--   10000001          7
--   10000001         10
--   10000003          6
--Success



--Procedure takes in a total area and booking id. The booking id is then used in two queries that extracted the designers pay rate and average rating via joins and the AVG function into two variables. The total area, pay rate, and average rating are then passed to a function which returns a total cost which is used to update the booking associated with the booking id with a new cost.
CREATE OR REPLACE PROCEDURE proc_booking_cost 
(in_total_area NUMBER, in_booking_id bookings.booking_id%TYPE) 
IS
	vn_total_cost bookings.cost%TYPE;
	vn_pay_rate designers.pay_rate%TYPE;
	vn_avg_rat testimonials.rating%TYPE;
BEGIN
	
	SELECT d.pay_rate
	INTO vn_pay_rate
	FROM designers d
	JOIN bookings b
	ON d.designer_id = b.designer_id
	WHERE b.booking_id = in_booking_id;
	
	SELECT AVG(t.rating)
	INTO vn_avg_rat
	FROM testimonials t
	JOIN designers d
	ON t.designer_id = d.designer_id
	JOIN bookings b
	ON d.designer_id = b.designer_id
	WHERE b.booking_id = in_booking_id
	GROUP BY t.designer_id;

	vn_total_cost := func_booking_cost(in_total_area, vn_pay_rate, vn_avg_rat);

	UPDATE bookings 
	SET cost = vn_total_cost
	WHERE booking_id = in_booking_id;
	
END proc_booking_cost;
/
SHOW ERRORS



