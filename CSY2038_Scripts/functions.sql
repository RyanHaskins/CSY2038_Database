--CSY2038 PR1 Assignment - FUNCTIONS

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

--@E:\scripts\functions.sql

/* Useful Commands
COLUMN object_name FORMAT A20;
COLUMN object_type FORMAT A20;
SELECT object_name, object_type FROM user_objects;
*/

SET SERVEROUTPUT ON;



/* ******************************
*								*
*		Create Functions			*
*								*
*********************************/
--Function determines the months left until retirement based upon the dob and retirement age passed in its parameters.
CREATE OR REPLACE FUNCTION func_retire_age 
(in_dob designers.dob%TYPE, in_retire_age NUMBER)
RETURN NUMBER IS
	vn_age NUMBER(2) := FLOOR(MONTHS_BETWEEN(SYSDATE, in_dob)/12);
	vn_months_left NUMBER(3);
BEGIN
	IF vn_age > in_retire_age
		THEN
			DBMS_OUTPUT.PUT_LINE( 'Designer is able to retire.');
			RETURN 0;
		ELSE
			vn_months_left := MOD(in_retire_age, vn_age)*12;
	END IF;
	
	RETURN vn_months_left;
END func_retire_age;
/
SHOW ERRORS



--Function takes in the total area of a room, a pay rate of a designer, and average rating of said designer. The function then uses the three arguements to generate a total cost which is return to the calling routine.
CREATE OR REPLACE FUNCTION func_booking_cost 
(in_total_area NUMBER, in_pay_rate designers.pay_rate%TYPE, in_avg_rate testimonials.rating%TYPE) 
RETURN NUMBER IS
	out_vn_total_cost NUMBER(8);
BEGIN
	out_vn_total_cost := in_total_area * ((in_pay_rate * 0.025)*(in_avg_rate*0.1));

	RETURN out_vn_total_cost;
END func_booking_cost;
/
SHOW ERRORS;



--Function calculates and returns the total area based upon two parameters passed if which are assumed to be measurements.
CREATE OR REPLACE FUNCTION func_total_area
(in_length customer_rooms.room_length%TYPE, in_width customer_rooms.room_width%TYPE)
RETURN NUMBER IS
	out_vn_total_area NUMBER(10);
BEGIN
	out_vn_total_area := in_length * in_width;
	
	RETURN out_vn_total_area;
END func_total_area;
/
SHOW ERRORS;