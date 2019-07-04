--CSY2038_296@student/CSY2038_296

--@E:\EXTRAS.sql

/*###PLSQL_2_PROCEDURES###*/
--SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_add_customer IS
	vc_customer_name customers.firstname%TYPE := 'CUSTOMER';
BEGIN
	INSERT INTO customers (customer_id, firstname)
	VALUES (customers_seq.NEXTVAL, vc_customer_name);
END proc_add_customer;
/
SHOW ERRORS

/*test proc_add_customer*/
SELECT * FROM customers; 
-- 5 rows returned
EXEC proc_add_customer
SELECT * FROM customers; 
-- 6 rows returned
--Success
--DROP PROCEDURE proc_add_customer;

CREATE OR REPLACE PROCEDURE proc_delete_customer IS
	vn_customer_id customers.customer_id%TYPE;
BEGIN
	SELECT customers_seq.CURRVAL
	INTO vn_customer_id
	FROM DUAL;
	
	DELETE FROM customers
	WHERE customer_id = vn_customer_id;
END proc_delete_customer;
/
SHOW ERRORS

/*test proc_delete_customer*/
SELECT * FROM customers; 
--6 rows returned
EXEC proc_delete_customer;
SELECT * FROM customers; 
--5 rows returned
--Success
--DROP PROCEDURE proc_delete_customer;

CREATE OR REPLACE PROCEDURE proc_param_del_cu
(in_customer_id customers.customer_id%TYPE) IS
	
BEGIN
	DELETE FROM customers
	WHERE customer_id = in_customer_id;
END proc_param_del_cu;
/
SHOW ERRORS

/*test proc_param_del_cu*/
SELECT * FROM customers; 
--5 rows returned
EXEC proc_param_del_cu(20000005);
SELECT * FROM customers; 
--4 rows returned
--Success
--DROP PROCEDURE proc_param_del_cu;

--BONUS ACTIVTY
CREATE OR REPLACE PROCEDURE proc_firstname (in_firstname customers.firstname%TYPE) IS
	vn_length NUMBER(2);
	vn_counter NUMBER(2) := 1;
BEGIN
	DBMS_OUTPUT.PUT_LINE('----FIRSTNAME----');
	vn_length := LENGTH(in_firstname);
LOOP
	
	EXIT WHEN vn_counter = (vn_length + 1);
	DBMS_OUTPUT.PUT_LINE(SUBSTR(in_firstname, vn_counter, 1));
	vn_counter := vn_counter + 1;
END LOOP;
END proc_firstname;
/
SHOW ERRORS

/*test proc_firstname*/
EXEC proc_firstname('ARYA')
--Success
EXEC proc_firstname('SILVER')
--Success
--DROP PROCEDURE proc_firstname;

CREATE OR REPLACE PROCEDURE proc_middlename (in_middlename VARCHAR2) IS
	vn_length NUMBER(2);
	vn_counter NUMBER(2) := 1;
BEGIN
	DBMS_OUTPUT.PUT_LINE('----MIDDLENAME----');
	vn_length := LENGTH(in_middlename);
WHILE vn_counter <= vn_length LOOP
	DBMS_OUTPUT.PUT_LINE(SUBSTR(in_middlename, vn_counter, 1));
	vn_counter := vn_counter + 1;
END LOOP;
END proc_middlename;
/
SHOW ERRORS

/*test proc_middlename*/
EXEC proc_middlename('MARY-ANGEL')
--Success
EXEC proc_middlename('FLOWERS')
--Success
--DROP PROCEDURE proc_middlename;

CREATE OR REPLACE PROCEDURE proc_lastname (in_lastname customers.lastname%TYPE) IS
	vn_length NUMBER(2);
	vn_counter NUMBER(2) := 1;
BEGIN
	DBMS_OUTPUT.PUT_LINE('----LASTNAME----');
	vn_length := LENGTH(in_lastname);
FOR vn_counter IN 1 .. vn_length LOOP
	DBMS_OUTPUT.PUT_LINE(SUBSTR(in_lastname, vn_counter, 1));
END LOOP;
END proc_lastname;
/
SHOW ERRORS

/*test proc_lastname*/
EXEC proc_lastname('MAULE')
--Success
EXEC proc_lastname('EARDLEY')
--Success
--DROP PROCEDURE proc_lastname;

CREATE OR REPLACE PROCEDURE proc_fir_mid_las (in_firstname customers.firstname%TYPE, in_middlename VARCHAR2, in_lastname customers.lastname%TYPE) IS

BEGIN
	proc_firstname(in_firstname);
	proc_middlename(in_middlename);
	proc_lastname(in_lastname);
END proc_fir_mid_las;
/
SHOW ERRORS

/*test proc_fir_mid_las*/
EXEC proc_fir_mid_las('ARYA', 'MARY-ANGEL', 'MAULE')
--Success
EXEC proc_fir_mid_las('SILVER', 'FLOWERS', 'EARDLEY')
--Success
--DROP PROCEDURE proc_fir_mid_las;





/*###PLSQL_3_FUNCTIONS###*/
CREATE OR REPLACE FUNCTION func_designer_ct RETURN NUMBER IS
	vn_designer_ct NUMBER(3);
BEGIN
	SELECT COUNT(designer_id)
	INTO vn_designer_ct
	FROM designers;

	RETURN vn_designer_ct;
END func_designer_ct;
/
SHOW ERRORS

CREATE OR REPLACE PROCEDURE proc_func_designer IS
	vn_no_of_designers NUMBER(3);
BEGIN
	vn_no_of_designers := func_designer_ct;

	DBMS_OUTPUT.PUT_LINE('There are ' || vn_no_of_designers || ' designer(s) in the database.');
END proc_func_designer;
/
SHOW ERRORS

/*test proc_func_designer*/
EXEC proc_func_designer;
--Success
SELECT COUNT(designer_id) FROM designers;
--Success
--DROP PROCEDURE proc_func_designer;
--DROP FUNCTION func_designer_ct;

CREATE OR REPLACE FUNCTION func_pay_desn_ct (in_pay_rate designers.pay_rate%TYPE) RETURN NUMBER IS
	vn_designer_ct NUMBER(3);
BEGIN
	SELECT COUNT(designer_id)
	INTO vn_designer_ct
	FROM designers
	WHERE pay_rate > in_pay_rate;

	RETURN vn_designer_ct;
END func_pay_desn_ct;
/
SHOW ERRORS

CREATE OR REPLACE PROCEDURE proc_func_pay_desn(in_pay_rate designers.pay_rate%TYPE) IS
	vn_no_of_designers NUMBER(3);
BEGIN
	vn_no_of_designers := func_pay_desn_ct(in_pay_rate);

	DBMS_OUTPUT.PUT_LINE('There are ' || vn_no_of_designers || ' designer(s) in the database with a pay rate higher than ' || in_pay_rate || '.');
END proc_func_pay_desn;
/
SHOW ERRORS

/*test proc_func_pay_desn*/
EXEC proc_func_pay_desn(10);
--Success
SELECT COUNT(designer_id) FROM designers WHERE pay_rate > 10;
--Success
EXEC proc_func_pay_desn(5);
--Success
SELECT COUNT(designer_id) FROM designers WHERE pay_rate > 5;
--Success
--DROP PROCEDURE proc_func_pay_desn;
--DROP FUNCTION func_pay_desn_ct;

--BONUS ACTIVTY
CREATE OR REPLACE FUNCTION func_cus_username 
(in_customer_id customers.customer_id%TYPE)RETURN VARCHAR2 IS
	vc_firstname customers.firstname%TYPE;
	vc_lastname customers.lastname%TYPE;
	vc_username VARCHAR2(7);
	--Change to customers.username%TYPE;
BEGIN
	SELECT firstname
	INTO vc_firstname
	FROM customers
	WHERE customer_id = in_customer_id;
	
	SELECT lastname
	INTO vc_lastname
	FROM customers
	WHERE customer_id = in_customer_id;
	
	vc_username := CONCAT(SUBSTR(vc_firstname, 1, 2), SUBSTR(vc_lastname, 1, 5));
	
	RETURN vc_username;
END func_cus_username;
/
SHOW ERRORS

CREATE OR REPLACE PROCEDURE proc_func_cus_username 
(in_customer_id customers.customer_id%TYPE) IS
	vc_username VARCHAR2(7);
	--Change to customers.username%TYPE;
BEGIN
	vc_username := func_cus_username(in_customer_id);

	DBMS_OUTPUT.PUT_LINE('Customers: ' || in_customer_id || ' username set to ' || vc_username || '.');
	--Change to -¬
	--UPDATE customers 
	--SET username = vc_username
	--WHERE customer_id = in_customer_id;
END proc_func_cus_username;
/
SHOW ERRORS

/*test proc_func_cus_username*/
EXEC proc_func_cus_username(20000000);
SELECT customer_id, firstname, lastname
--Change to SELECT customer_id, username
FROM customers
WHERE customer_id = 20000000;
--DROP PROCEDURE proc_func_cus_username;
--DROP FUNCTION func_cus_username





/*###PLSQL_4_TRIGGERS###*/
CREATE OR REPLACE TRIGGER trig_ar_date_ck
BEFORE INSERT OR UPDATE OF arrival_date ON bookings
FOR EACH ROW
WHEN(NEW.arrival_date < SYSDATE)

BEGIN
	DBMS_OUTPUT.PUT_LINE('The arrival date cannot exist in the past');
	RAISE_APPLICATION_ERROR
	(-20000, 'ERROR - THE ARRIVAL DATE CAN NOT EXIST BEFORE TODAYS DATE! 
	ARRIVAL DATE: ' || :NEW.arrival_date || ' TODAYS DATE: ' || SYSDATE);
END trig_ar_date_ck;
/
SHOW ERRORS

/*test trig_ar_date_ck*/
INSERT INTO bookings (booking_id, designer_id, arrival_date)
VALUES (bookings_seq.NEXTVAL, 10000000, '01-JUN-2016');
--Throws error - Success
INSERT INTO bookings (booking_id, designer_id, arrival_date)
VALUES (bookings_seq.NEXTVAL, 10000000, '01-JUN-2019');
--Should not throw error - Success 
--DROP TRIGGER trig_ar_date_ck;

CREATE OR REPLACE TRIGGER trig_hire_date
AFTER INSERT OR UPDATE ON designers
FOR EACH ROW
WHEN (NEW.hire_date IS NOT NULL)
DECLARE
	vd_today designers.hire_date%TYPE := SYSDATE;
BEGIN
	IF (vd_today - (365*5)) >= :NEW.hire_date
		THEN
			DBMS_OUTPUT.PUT_LINE('Designer has been hired for or over 5 years.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('Designer has not been hired for more 5 years.');
	END IF;
END trig_hire_date;
/
SHOW ERRORS

/*test trig_hire_date*/
INSERT INTO designers (designer_id, hire_date)
VALUES (designers_seq.NEXTVAL, '01-JAN-2013');
--Trigger designer has been hired for over 5 years - Success
INSERT INTO designers (designer_id, hire_date)
VALUES (designers_seq.NEXTVAL, '01-JAN-2014');
--Trigger designer has not been hired for 5 years - Success
--DROP TRIGGER trig_hire_date;

--BONUS ACTIVITY
CREATE OR REPLACE TRIGGER trig_desn_dob_suc
BEFORE INSERT ON designers
FOR EACH ROW
WHEN ((MONTHS_BETWEEN(SYSDATE, NEW.dob)/12) > 18)

BEGIN
	DBMS_OUTPUT.PUT_LINE('Designer added.');
END trig_desn_dob_suc;
/
SHOW ERRORS

/*test trig_desn_dob_suc */
INSERT INTO designers (designer_id, dob)
VALUES (designers_seq.NEXTVAL, '01-JAN-2000');
--Designer added. - Success
--DROP TRIGGER trig_desn_dob_suc;

CREATE OR REPLACE TRIGGER trig_desn_dob_dec
BEFORE INSERT ON designers
FOR EACH ROW
WHEN ((MONTHS_BETWEEN(SYSDATE, NEW.dob)/12) < 18)

BEGIN
	DBMS_OUTPUT.PUT_LINE('Designer is too young.');
	RAISE_APPLICATION_ERROR
	(-20000, 'ERROR - THE DESIGNER IS TOO YOUNG!');
END trig_desn_dob_dec;
/
SHOW ERRORS

/*test trig_desn_dob_dec*/
INSERT INTO designers (designer_id, dob)
VALUES (designers_seq.NEXTVAL, '01-JAN-2010');
--ERROR - THE DESIGNER IS TOO YOUNG! - Success
--DROP TRIGGER trig_desn_dob_dec;





/*###PLSQL_4.5_COMBINED--IMPROVED###*/
/*Function determines the months left until retirement based upon the 
dob and retirement age passed in its parameters*/
CREATE OR REPLACE FUNCTION func_retire_age (in_dob designers.dob%TYPE, in_retire_age NUMBER)
RETURN NUMBER IS
	vn_age NUMBER(2) := FLOOR(MONTHS_BETWEEN(SYSDATE, in_dob)/12);
	vn_months_left NUMBER(3);
BEGIN
	
	vn_months_left := MOD(in_retire_age, vn_age)*12;
	
	RETURN vn_months_left;
END func_retire_age;
/
SHOW ERRORS

/*Trigger runs before insert, update or delete on the designers table 
taking appropriate action dependant on the action that triggered the trigger.
If inserting it displays the name of who is being inserts. If updating it
sends the dob of the record being updated to a function which returns the 
remaining months until retirements base on a hardcoded age of 67. If deleteing
it displays the name of who is being deleted.*/
CREATE OR REPLACE TRIGGER trig_designer 
BEFORE INSERT OR UPDATE OR DELETE ON designers
FOR EACH ROW
DECLARE
	vn_age NUMBER(2) := FLOOR(MONTHS_BETWEEN(SYSDATE, :NEW.dob)/12);
	vn_months_left NUMBER(3);
BEGIN
	IF (INSERTING OR UPDATING)
		THEN
			IF INSERTING
				THEN
					--INSERTING
					DBMS_OUTPUT.PUT_LINE('You are adding ' || :NEW.firstname|| ' who is ' || vn_age ||' years old.');
				ELSE
					--UPDATING
					vn_months_left := func_retire_age(:OLD.dob, 67);
					DBMS_OUTPUT.PUT_LINE(vn_months_left || ' months until retirement.');
			END IF;
		ELSE
			--DELETING
			DBMS_OUTPUT.PUT_LINE('You are deleting ' || :OLD.firstname || '.');
	END IF;
END trig_designer;
/
SHOW ERRORS

/*test trig_designer*/
INSERT INTO designers (designer_id, firstname, dob)
VALUES (designers_seq.NEXTVAL, 'JOSH', '26-JAN-1995');
--You are adding JOSH who is 23 years old. - Success
UPDATE designers SET lastname = 'CHALLAND'
WHERE designer_id = 10000021;
--252 months until retirement. - Success
DELETE FROM designers WHERE designer_id = 10000021;
--You are deleting JOSH. - Success

/*Procedure takes in a designers id and the age at which they plan to
retire, it then stores the designers date of birth using a query. the 
dob and age they plan to retire is send to a function which returns the 
number of months they have left until retirement.*/
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
	
	DBMS_OUTPUT.PUT_LINE(vn_months_left || ' months until retirement.');
	
END proc_retire_param;
/
SHOW ERRORS

/*test proc_retire_param*/
EXEC proc_retire_param(10000000, 67);
--300 months until retirement. - Success
EXEC proc_retire_param(10000000, 60);
--216 months until retirement. - Success

--DROP PROCEDURE proc_retire_param;
--DROP TRIGGER trig_designer;
--DROP FUNCTION func_retire_age;





/*###PLSQL_5_CURSORS###*/
CREATE OR REPLACE PROCEDURE proc_imp_cursor 
(in_firstname designers.firstname%Type) 
IS	

BEGIN
	DELETE FROM designers WHERE firstname = in_firstname;
	
	IF SQL%FOUND 
		THEN
			DBMS_OUTPUT.PUT_LINE(in_firstname || ' REMOVED.');
		ELSE 
			DBMS_OUTPUT.PUT_LINE(in_firstname || ' DOES NOT EXIST.');
	END IF;

END proc_imp_cursor;
/
SHOW ERRORS

/*test proc_imp_cursor*/
INSERT INTO designers (designer_id, firstname)
VALUES(99999999, 'CANDY');
EXEC proc_imp_cursor ('CANDY');
--CANDY REMOVED. - Success
EXEC proc_imp_cursor ('DAISY');
--DAISY DOES NOT EXIST. - Success
SELECT firstname FROM designers;
--NO CANDY OR DAISY IN TABLE - Success

--DROP PROCEDURE proc_imp_cursor;

CREATE OR REPLACE PROCEDURE proc_exp_cur_book_high 
(in_cost bookings.cost%Type) 
IS	

	CURSOR cur_book_mor IS
	SELECT b.booking_id, b.cost, b.order_date, d.firstname
	FROM bookings b
	JOIN designers d
	ON b.designer_id = d.designer_id
	WHERE cost > in_cost;
	
	rec_cur_book_mor cur_book_mor%ROWTYPE;
	vn_row_count NUMBER(2) := 0;

BEGIN
	DBMS_OUTPUT.PUT_LINE('Number bookings with a cost more than ' || in_cost);
	FOR rec_cur_book_mor IN cur_book_mor LOOP
		DBMS_OUTPUT.PUT_LINE(cur_book_mor%ROWCOUNT || ' Booking_id: ' || rec_cur_book_mor.booking_id ||
		' Booking cost: ' || rec_cur_book_mor.cost || ' Booking date: '
		|| rec_cur_book_mor.order_date || ' Designer firstname: ' ||
		rec_cur_book_mor.firstname);
		vn_row_count := vn_row_count + 1;
	END LOOP;
	
	IF vn_row_count = 0
		THEN
			DBMS_OUTPUT.PUT_LINE(vn_row_count || ' bookings cost more than ' || in_cost);
	END IF;

END proc_exp_cur_book_high;
/
SHOW ERRORS

/*test  proc_exp_cur_book_high*/
EXEC proc_exp_cur_book_high(900);
/*
Bookings with cost more than 900
Booking_id: 40000001 Booking cost: 13222.5 Booking date: 03-AUG-17 Designer
firstname: STEVE
Booking_id: 40000002 Booking cost: 988.25 Booking date: 17-NOV-15 Designer
firstname: MYLES
Booking_id: 40000003 Booking cost: 20000.49 Booking date: 06-MAY-14 Designer
firstname: ELIANE
Booking_id: 40000004 Booking cost: 2999.99 Booking date: 19-JAN-17 Designer
firstname: MYLES
*/
--Success
SELECT booking_id FROM bookings WHERE cost > 900;
/*
40000001
40000002
40000003
40000004
*/
--Success

--DROP PROCEDURE proc_exp_cur_book_high;

CREATE OR REPLACE PROCEDURE proc_exp_cur_book_low 
(in_cost bookings.cost%Type) 
IS	

	CURSOR cur_book_low IS
	SELECT b.booking_id, b.cost, b.order_date, d.firstname
	FROM bookings b
	JOIN designers d
	ON b.designer_id = d.designer_id
	WHERE cost < in_cost;
	
	rec_cur_book_low cur_book_low%ROWTYPE;
	vn_row_count NUMBER(2) := 0;

BEGIN
	DBMS_OUTPUT.PUT_LINE('Bookings with a cost less than ' || in_cost);
	FOR rec_cur_book_low IN cur_book_low LOOP
		DBMS_OUTPUT.PUT_LINE('Booking_id: ' || rec_cur_book_low.booking_id ||
		' Booking cost: ' || rec_cur_book_low.cost || ' Booking date: '
		|| rec_cur_book_low.order_date || ' Designer firstname: ' ||
		rec_cur_book_low.firstname);
		vn_row_count := vn_row_count + 1;
	END LOOP;
	
	IF vn_row_count = 0
		THEN
			DBMS_OUTPUT.PUT_LINE(vn_row_count || ' bookings cost less than ' || in_cost);
	END IF;
	
END proc_exp_cur_book_low;
/
SHOW ERRORS

/*test proc_exp_cur_book_low*/
EXEC proc_exp_cur_book_low(900);
/*
Bookings with cost less than 900
Booking_id: 40000000 Booking cost: 766.75 Booking date: 14-FEB-16 Designer
firstname: AKPAR
*/
--Success
SELECT booking_id FROM bookings WHERE cost < 900;
/*
40000000
*/
--Success

--DROP PROCEDURE proc_exp_cur_book_low;

--BONUS ACTIVITY

/*Procedure takes in a rating and creates a cursor which queries all 
ratings in testimonials which are greater than the input rating. The 
procedure then opens the cursors and checks if a row was found, displaying
and appropriate message. If a row was found it loops through the results 
displaying the relevant information from the results found.*/
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

/*test proc_higher_rate*/
EXEC proc_higher_rate(5);
/*
Designers with a rating higher than 5
1 Designer ID: 10000001 Designers Rating: 7
2 Designer ID: 10000001 Designers Rating: 7
3 Designer ID: 10000001 Designers Rating: 10
4 Designer ID: 10000003 Designers Rating: 6
*/
--Success
SELECT designer_id, rating FROM testimonials WHERE rating > 5;
/*
   10000001          7
   10000001          7
   10000001         10
   10000003          6
*/
--Success

--DROP PROCEDURE proc_higher_rate;





/*###PLSQL_EXTRAS###*/
/*Function takes in the total area of a room, a pay rate of a designer, 
and average rating of said designer. The function then uses the three 
arguements to generate a total cost which is return to the calling routine.*/
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

--DROP FUNCTION func_booking_cost;

/*Function calculates and returns the total area based upon two parameters passed if which are 
assumed to be measurements.*/
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

--DROP FUNCTION func_total_area;

/*Procedure takes in a total area and booking id. The booking id is then
used in a cursors to find all customer rooms under the same booking, each
customer rooms area is then added to the total area of the booking. It is also 
used in two queries that extracted the designers pay rate and average rating 
via joins and the AVG function into two variables. The total area, pay rate, 
and average rating are then passed to a function which returns a total cost 
which is used to update the booking associated with the booking id with a 
new cost.*/
CREATE OR REPLACE PROCEDURE proc_booking_cost 
(in_total_area NUMBER, in_booking_id bookings.booking_id%TYPE) 
IS
	
	CURSOR cur_total_area IS
	SELECT cr.room_length, cr.room_width
	FROM customer_rooms cr
	WHERE booking_id = in_booking_id;
	
	vn_total_area NUMBER(10) := in_total_area;
	
	vn_total_cost bookings.cost%TYPE;
	vn_pay_rate designers.pay_rate%TYPE;
	vn_avg_rat testimonials.rating%TYPE;
	
	rec_cur_total_area cur_total_area%ROWTYPE;

	
BEGIN

	FOR rec_cur_total_area IN cur_total_area LOOP
		vn_total_area := vn_total_area + func_total_area(rec_cur_total_area.room_length, rec_cur_total_area.room_width);
	END LOOP;
	
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

	vn_total_cost := func_booking_cost(vn_total_area, vn_pay_rate, vn_avg_rat);

	UPDATE bookings 
	SET cost = vn_total_cost
	WHERE booking_id = in_booking_id;
	
END proc_booking_cost;
/
SHOW ERRORS

--DROP PROCEDURE proc_booking_cost;

/*Trigger runs when a customer room is inserted. It takes the width and length
and works out the total area and passes it into the procedure to update the
bookings cost*/
CREATE OR REPLACE TRIGGER trig_booking_cost
BEFORE INSERT ON customer_rooms
FOR EACH ROW
WHEN ((NEW.room_width IS NOT NULL) AND(NEW.room_length IS NOT NULL))
DECLARE

	vn_total_area NUMBER(10); 
	
BEGIN
	
	vn_total_area := func_total_area(:NEW.room_width, :NEW.room_length);
	proc_booking_cost(vn_total_area, :NEW.booking_id);

END trig_booking_cost;
/
SHOW ERRORS

--original cost: 766.75 --select cost from bookings where booking_id = 40000000;
--desinger_id: 10000000 --select designer_id from bookings where booking_id = 40000000;
--pay_rate: 9 --select pay_rate from designers where designer_id = 10000000;
/*
INSERT INTO testimonials (testimonial_id, designer_id, rating)
VALUES (testimonials_seq.NEXTVAL, 10000000, 5);
--DELETE FROM customer_rooms WHERE customer_id = 20000000;
*/
--avg(rating): 5  --select AVG(rating) from testimonials where designer_id = 10000000;
--New cost: 281.25

INSERT INTO customer_rooms (customer_room_id, customer_id, booking_id, room_width, room_length)
VALUES (customer_rooms_seq.NEXTVAL, 20000000, 40000000, 50, 50);
/*
select booking_id, cost from bookings;
BOOKING_ID       COST
---------- ----------
  40000000        281
  
  --SUCCESS
*/


-- DROP TRIGGER trig_booking_cost;