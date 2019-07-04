--CSY2038 PR1 Assignment - CSY2038PR1

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

--@K:\scripts\CSY2028PR1.sql

/* Useful Commands
COLUMN object_name FORMAT A20;
COLUMN object_type FORMAT A20;
SELECT object_name, object_type FROM user_objects;
*/



/* ******************************
*								*
*		Create Types			*
*								*
*********************************/
CREATE OR REPLACE TYPE social_media_type AS OBJECT (
	media_name 	VARCHAR2(25),
	contact 	VARCHAR2(50)
);
/
SHOW ERRORS

CREATE TYPE social_media_table_type AS TABLE OF social_media_type;
/
SHOW ERRORS

CREATE OR REPLACE TYPE contact_type AS OBJECT (
	contact_type VARCHAR2(15),
	contact_method VARCHAR2(15),
	contact_info VARCHAR2(50)
);
/
SHOW ERRORS;

CREATE TYPE contact_varray_type AS VARRAY(50) OF contact_type;
/
SHOW ERRORS;

CREATE OR REPLACE TYPE address_type AS OBJECT ( 
	house_number VARCHAR2(25),
	street VARCHAR2(25),
	city VARCHAR2(25),
	country VARCHAR2(25),
	postcode VARCHAR2(15)
);
/
SHOW ERRORS;

CREATE TABLE addresses OF address_type;



/* ******************************
*								*
*		Check Types				*
*								*
*********************************/
COLUMN object_name FORMAT A20;
SELECT object_name FROM user_objects WHERE object_type = 'TYPE';



/* ******************************
*								*
*		Create Tables			*
*								*
*********************************/
CREATE TABLE designers (
	designer_id NUMBER(8),
	firstname VARCHAR2(25) NOT NULL,
	lastname VARCHAR2(25) NOT NULL,
	address REF address_type SCOPE IS addresses,
	social_media social_media_table_type,
	pay_rate NUMBER(4,2) DEFAULT 7.50,
	hire_date DATE DEFAULT SYSDATE,
	dob DATE NOT NULL
)
NESTED TABLE social_media STORE AS nested_social_media_table_type;

CREATE TABLE bookings (
	booking_id NUMBER(8),
	designer_id NUMBER(8) NOT NULL,
	cost NUMBER(10,2),
	completed CHAR(1) NOT NULL,
	order_date DATE DEFAULT SYSDATE,
	arrival_date DATE
);

CREATE TABLE customers (
	customer_id NUMBER(8),
	title VARCHAR2(10),
	firstname VARCHAR2(25) NOT NULL,
	lastname VARCHAR2(25) NOT NULL,
	username VARCHAR2(25),
	address   address_type,
	contact contact_varray_type
);
	
CREATE TABLE customer_rooms (
	Customer_room_id NUMBER(8),
	customer_id NUMBER(8) NOT NULL,
	booking_id NUMBER(8) NOT NULL,	
	room_width NUMBER(6) NOT NULL,		
	room_length NUMBER(6) NOT NULL,
	address REF address_type SCOPE IS addresses	
);

CREATE TABLE testimonials(
	testimonial_id NUMBER(8),
	designer_id NUMBER(10) NOT NULL,
	review VARCHAR2(125),
	rating NUMBER(2) NOT NULL,
	date_created DATE DEFAULT SYSDATE	
);



/* ******************************
*								*
*		Check Tables			*
*								*
*********************************/
COLUMN tname FORMAT A20;
SELECT tname FROM TAB;



/* ******************************
*								*
*		Create Sequences		*
*								*
*********************************/
CREATE SEQUENCE designers_seq START WITH 10000000 INCREMENT BY 1;
CREATE SEQUENCE bookings_seq START WITH 40000000 INCREMENT BY 1;
CREATE SEQUENCE testimonials_seq START WITH 30000000 INCREMENT BY 1;
CREATE SEQUENCE customers_seq START WITH 20000000 INCREMENT BY 1;
CREATE SEQUENCE customer_rooms_seq START WITH 50000000 INCREMENT BY 1;



/* ******************************
*								*
*		Check Sequences			*
*								*
*********************************/
COLUMN sequence_name FORMAT A20;
SELECT sequence_name FROM user_sequences;



/* ******************************
*								*
*		Primary keys			*
*								*
*********************************/
ALTER TABLE designers
ADD CONSTRAINT pk_designers
PRIMARY KEY (designer_id);

ALTER TABLE bookings
ADD CONSTRAINT pk_bookings
PRIMARY KEY (booking_id);

ALTER TABLE customers
ADD CONSTRAINT pk_customers
PRIMARY KEY (customer_id);

ALTER TABLE customer_rooms
ADD CONSTRAINT pk_customer_rooms
PRIMARY KEY (customer_room_id);

ALTER TABLE testimonials
ADD CONSTRAINT pk_testimonials
PRIMARY KEY (testimonial_id);



/* ******************************
*								*
*		Foreign keys 			*
*								*
*********************************/
ALTER TABLE bookings 
ADD CONSTRAINT fk_b_designers
FOREIGN KEY (designer_id)
REFERENCES designers(designer_id);

ALTER TABLE customer_rooms
ADD CONSTRAINT fk_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE customer_rooms 
ADD CONSTRAINT fk_bookings
FOREIGN KEY (booking_id)
REFERENCES bookings(booking_id);

ALTER TABLE testimonials
ADD CONSTRAINT fk_t_designers
FOREIGN KEY (designer_id)
REFERENCES designers (designer_id);



/* ******************************
*								*
*	Other Constraints 			*
*								*
*********************************/
COLUMN object_name FORMAT A20;
SELECT constraint_name 
FROM user_constraints 
WHERE constraint_type = 'P' OR constraint_type = 'R';

ALTER TABLE bookings
MODIFY (completed DEFAULT 'N');

ALTER TABLE bookings
ADD CONSTRAINT ck_completed 
CHECK (completed IN ('Y','N'));

ALTER TABLE testimonials
ADD CONSTRAINT ck_rating 
CHECK (rating < 11);



/* ******************************
*								*
*	Check Constraints 			*
*								*
*********************************/
COLUMN object_name FORMAT A20;
SELECT constraint_name 
FROM user_constraints 
WHERE constraint_type = 'P' OR constraint_type = 'R';



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


/* ******************************
*								*
*		Create Triggers			*
*								*
*********************************/
--Trigger runs before insert, update or delete on the designers table taking appropriate action dependant on the action that triggered the trigger.If inserting it displays the name of who is being inserts. If updating itsends the dob of the record being updated to a function which returns the  remaining months until retirements base on a hardcoded age of 67. If deleteing it displays the name of who is being deleted.
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
					DBMS_OUTPUT.PUT_LINE(:OLD.designer_id || ' has ' || vn_months_left || ' months until retirement.');
			END IF;
		ELSE
			--DELETING
			DBMS_OUTPUT.PUT_LINE('You are deleting ' || :OLD.firstname || '.');
	END IF;
END trig_designer;
/
SHOW ERRORS

--test trig_designer
--INSERT INTO designers (designer_id, firstname, lastname, dob)
--VALUES (designers_seq.NEXTVAL, 'JOSH', 'LAND', '26-JAN-1995');
--You are adding JOSH who is 23 years old. - Success
--UPDATE designers SET lastname = 'CHALLAND'
--WHERE designer_id = 10000005;
--252 months until retirement. - Success
--DELETE FROM designers WHERE designer_id = 10000005;
--You are deleting JOSH. - Success



--Trigger runs when a customer room is inserted. It takes the width and length and works out the total area and passes it into the procedure to update the bookings cost.
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

--test trig_booking_cost
--original cost: 766.75 --select cost from bookings where booking_id = 40000000;
--desinger_id: 10000000 --select designer_id from bookings where booking_id = 40000000;
--pay_rate: 9 --select pay_rate from designers where designer_id = 10000000;
--INSERT INTO testimonials (testimonial_id, designer_id, rating)
--VALUES (testimonials_seq.NEXTVAL, 10000000, 5);
--avg(rating): 5  --select AVG(rating) from testimonials where designer_id = 10000000;
--New cost: 281
--INSERT INTO customer_rooms (customer_room_id, customer_id, booking_id, room_width, room_length)
--VALUES (customer_rooms_seq.NEXTVAL, 20000000, 40000000, 50, 50);
--select booking_id, cost from bookings;
--BOOKING_ID       COST
---------- ----------
--  40000000        281
--SUCCESS



/* ******************************
*								*
*		Insert Addresses		*
*								*
*********************************/
INSERT INTO addresses 
VALUES ('2A','MATCHLESS CLOSE', 'NORTHAMPTON', 'UK', 'NN5 6YE');

INSERT INTO addresses 
VALUES ('22', 'CARLTON ROAD', 'TOWCESTER', 'UK', 'TT2 7DQ');

INSERT INTO addresses
VALUES ('56', 'BILLING ROAD', 'NORTHAMPTON', 'UK',  'NN7 9PO');

INSERT INTO addresses
VALUES ('62', 'HENSPORT STREET', 'OUNDLE', 'UK',  'OU23 1MG');

INSERT INTO addresses
VALUES ('34', 'GISMOUTH STREET', 'NORTHAMPTON', 'UK', 'NG3 6YE');

INSERT INTO addresses 
VALUES ('12', 'HUMMERSBY ROAD', 'NORTHAMPTON', 'UK', 'DV6 2OE');

INSERT INTO addresses
VALUES ('6Q', 'BRILTON ROAD', 'BRACKLEY', 'UK', 'BR10 5DE');

INSERT INTO addresses
VALUES ('6', 'KETTERING ROAD', 'NORTHAMPTON', 'UK', 'NH7 3GG');



/* ******************************
*								*
*	Check Addresses Inserts		*
*								*
*********************************/
COLUMN street FORMAT A20;
COLUMN city FORMAT A20;
SELECT street, city FROM addresses;



/* ******************************
*								*
*		Insert Designers		*
*								*
*********************************/
INSERT INTO designers
VALUES(
designers_seq.NEXTVAL, 
'AKPAR', 
'SALATIAN', 
(SELECT REF(a)
FROM addresses a
WHERE street = 'CARLTON ROAD'),
social_media_table_type(
	social_media_type('AKPARSALATAIN69', 'TWIITER.COM/APKARS69'),
	social_media_type('AKPARSALATAIN69', 'FACEBOOK.COM/APKARS69'),
	social_media_type('AKPARSALATAIN69', 'YOUTUBE.COM/APKARS69')),
9.00,
'12-JAN-2004',
'21-FEB-1976'
);

INSERT INTO designers
VALUES (
designers_seq.NEXTVAL,
'STEVE',
'PERRISON',
(SELECT REF (a)
FROM addresses a
WHERE street = 'KETTERING ROAD'),
social_media_table_type(
	social_media_type('PERRISON2', 'TWITTER.COM/PERRISON2'),
	social_media_type('PERRISON2', 'FACEBOOK.COM/PERRISON2')),
12.00,
'17-JAN-2008',
'28-MAY-1998'
);

INSERT INTO designers
VALUES (
designers_seq.NEXTVAL,
'MYLES',
'GOODE-FOUCHER',
(SELECT REF (a)
FROM addresses a
WHERE street = 'HUMMERSBY ROAD'),
social_media_table_type(
	social_media_type('MYLESFOUCHER', 'TWITTER.COM/MYLESFOUCHER'),
	social_media_type('MYLESFOUCHER', 'FACEBOOK.COM/MYLESFOUCHER')),
8.00,
'17-JAN-2005',
'24-NOV-1988'
);

INSERT INTO designers
VALUES (
designers_seq.NEXTVAL,
'ELIANE',
'PATTERSON',
(SELECT REF (a)
FROM addresses a
WHERE street = 'GISMOUTH STREET'),
social_media_table_type(
	social_media_type('ELIANEPATTERSON', 'FACEBOOK.COM/ELIANPATTERSON')),
7.50,
'10-AUG-2010',
'14-JAN-1989'
);

INSERT INTO designers
VALUES (
designers_seq.NEXTVAL,
'BARRY',
'GILMARTIN',
(SELECT REF(a)
FROM addresses a
WHERE street='HENSPORT STREET'),
social_media_table_type(
	social_media_type('GILMARTIN', 'FACEBOOK.COM/BARRYGILMARTIN')),
20.50,
'20-FEB-2015',
'12-JAN-1977'
);



/* ******************************
*								*
*	Check Designers Inserts		*
*								*
*********************************/
COLUMN firstname FORMAT A20;
SELECT designer_id, firstname FROM designers;



/* ******************************
*								*
*		Insert Customers		*
*								*
*********************************/
INSERT INTO customers
VALUES (customers_seq.NEXTVAL, 'MRS', 'ANDY', 'STAR', 'ONEANDONLY',
address_type('1', 'MAIN ROAD','NORTHAMPTON', 'UK', 'NN9 5YU'),
	contact_varray_type(
		contact_type('EMERGENCY', 'MOBILE PHONE', '07458921621'),
		contact_type('HOME', 'HOME PHONE', '01605216874'),
		contact_type('EMAIL', 'EMAIL', 'STARC@GMAIL.COM'))
);

INSERT INTO customers
VALUES (customers_seq.NEXTVAL , 'MR', 'BEN', 'WALKER', 'WALKINGAWAY',
address_type('13', 'WRENBRY ROAD', 'NORTHAMPTON', 'UNITED KINGDOM', 'NN5 6UI'),
	contact_varray_type(
		contact_type('EMERGENCY', 'MOBILE PHONE', '07755787555'),
		contact_type('HOME', 'HOME PHONE', '01605589876'),
		contact_type('EMAIL', 'EMAIL', 'BEN777@HOTMAIL.COM'))
);

INSERT INTO customers
VALUES (customers_seq.NEXTVAL , 'MS', 'DARKEN', 'SIDEN', 'CHOICEX',
address_type('1', 'RYELAND ROAD','OUNDLE', 'UK', 'OU3 8GH'), 
	contact_varray_type(
		contact_type('EMERGENCY', 'MOBILE PHONE', '07525512311'),
		contact_type('HOME', 'HOME PHONE', '01605216800'),
		contact_type('EMAIL', 'EMAIL', 'DARKENSIDEN@VERY.DARK.MAIL.COM'))
);

INSERT INTO customers
VALUES (customers_seq.NEXTVAL , 'MR', 'BILL', 'GATES', 'MILLIONDOOR',
address_type('300', 'BRIXTON ROAD', 'KETTERING', 'UNITED KINGDOM', 'BX3 99H'), 
	contact_varray_type(
		contact_type('EMERGENCY', 'MOBILE PHONE', '07511223344'),
		contact_type('HOME', 'HOME PHONE', '01405212345'),
		contact_type('EMAIL', 'EMAIL', 'GATESAREOPEN@MICROSOFT.COM'))
);

INSERT INTO customers
VALUES (customers_seq.NEXTVAL , 'MS', 'RUBY', 'DIAMOND', 'GOLDEN',
address_type('555', 'BUILDING STREET', 'WELLINGBOROUGH', 'UK', 'DN37 8777'),
	contact_varray_type(
		contact_type('EMERGENCY', 'MOBILE PHONE', '07501773144'),
		contact_type('HOME', 'HOME PHONE', '01605210000'),
		contact_type('EMAIL', 'EMAIL', 'RUBYTHEDIAMOND@GMAIL.COM'))
);



/* ******************************
*								*
*	Check Customers Inserts		*
*								*
*********************************/
COLUMN firstname FORMAT A20;
SELECT customer_id, firstname FROM customers;



/* ******************************
*								*
*		Insert Testimonials		*
*								*
*********************************/
INSERT INTO testimonials
VALUES (testimonials_seq.NEXTVAL, 10000001, 'Well completed job, very happy!', 7, '12-JAN-2017');

INSERT INTO testimonials
VALUES (testimonials_seq.NEXTVAL, 10000002, 'Poor Job, unhappy...', 3, '06-MAR-2016');

INSERT INTO testimonials
VALUES (testimonials_seq.NEXTVAL, 10000001, 'Satisfactory', 7, '19-MAY-2017');

INSERT INTO testimonials
VALUES (testimonials_seq.NEXTVAL, 10000001, 'Perfect', 10, '27-SEP-2015');

INSERT INTO testimonials
VALUES (testimonials_seq.NEXTVAL, 10000003, 'Good!', 6, '23-NOV-2017');



/* ******************************
*								*
*	Check Testimonials Inserts	*
*								*
*********************************/
SELECT testimonial_id, designer_id, rating FROM testimonials;



/* ******************************
*								*
*		Inserts Bookings		*
*								*
*********************************/
INSERT INTO bookings(booking_id, designer_id, cost, completed, order_date, arrival_date)
VALUES (bookings_seq.NEXTVAL, 10000000, 766.75, 'N', '14-FEB-2016', '01-FEB-2017');

INSERT INTO bookings(booking_id, designer_id, cost, completed, order_date, arrival_date)
VALUES (bookings_seq.NEXTVAL,10000001, 13222.50, 'N', '03-AUG-2017', '01-DEC-2017');

INSERT INTO bookings(booking_id, designer_id, cost, completed, order_date, arrival_date)
VALUES (bookings_seq.NEXTVAL,10000002, 988.25, 'N', '17-NOV-2015', '08-JAN-2016');

INSERT INTO bookings(booking_id, designer_id, cost, completed, order_date, arrival_date)
VALUES (bookings_seq.NEXTVAL,10000003, 20000.49, 'Y', '06-MAY-2014', '01-JUN-2015');

INSERT INTO bookings(booking_id, designer_id, cost, completed, order_date, arrival_date)
VALUES (bookings_seq.NEXTVAL,10000002, 2999.99, 'N', '19-JAN-2017', '01-MAR-2018');



/* ******************************
*								*
*	Check Bookings Inserts		*
*								*
*********************************/
SELECT booking_id, designer_id, cost FROM bookings;



/* ******************************
*								*
*	Inserts Customer_Rooms		*
*								*
*********************************/

INSERT INTO customer_rooms
SELECT customer_rooms_seq.NEXTVAL,
20000001, 
40000001,  
4500,
2300,
REF(a)
FROM addresses a
WHERE street = 'MATCHLESS CLOSE';

INSERT INTO customer_rooms
SELECT customer_rooms_seq.NEXTVAL,
20000002, 
40000003, 
1400,
2550,
REF(a)
FROM addresses a
WHERE street = 'KETTERING ROAD';

INSERT INTO customer_rooms
SELECT customer_rooms_seq.NEXTVAL,
20000004, 
40000002,
6000,
8000,  
REF(a)
FROM addresses a
WHERE street = 'BRILTON ROAD';

INSERT INTO customer_rooms
SELECT customer_rooms_seq.NEXTVAL,
20000003, 
40000003, 
3000,
5025, 
REF(a)
FROM addresses a
WHERE street = 'KETTERING ROAD';




/* ******************************
*								*
* Check Customer_Rooms Inserts	*
*								*
*********************************/

COLUMN c.address.street FORMAT A20;
SELECT c.customer_room_id, c.customer_id, c.booking_id, c.address.street FROM customer_rooms c;




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



/* ******************************
*								*
*		Drop Triggers			*
*								*
*********************************/
DROP TRIGGER trig_designer;
DROP TRIGGER trig_booking_cost;



/* ******************************
*								*
*		Drop Procedures			*
*								*
*********************************/
DROP PROCEDURE proc_retire_param;
DROP PROCEDURE proc_higher_rate;
DROP PROCEDURE proc_booking_cost;



/* ******************************
*								*
*		Drop Functions			*
*								*
*********************************/
DROP FUNCTION func_retire_age;
DROP FUNCTION func_booking_cost;
DROP FUNCTION func_total_area;



/* ******************************
*								*
*		Drop Constraints		*
*								*
*********************************/
ALTER TABLE bookings
DROP CONSTRAINT ck_completed;

ALTER TABLE testimonials
DROP CONSTRAINT ck_rating;



/* ******************************
*								*
*		Drop Foreign Keys		*
*								*
*********************************/
ALTER TABLE customer_rooms
DROP CONSTRAINT fk_bookings;

ALTER TABLE customer_rooms
DROP CONSTRAINT fk_customers;

ALTER TABLE bookings
DROP CONSTRAINT fk_b_designers;

ALTER TABLE testimonials
DROP CONSTRAINT fk_t_designers;



/* ******************************
*								*
*		Drop Primary Keys		*
*								*
*********************************/
ALTER TABLE customer_rooms
DROP CONSTRAINT pk_customer_rooms;

ALTER TABLE testimonials
DROP CONSTRAINT pk_testimonials;

ALTER TABLE customers
DROP CONSTRAINT pk_customers;

ALTER TABLE bookings
DROP CONSTRAINT pk_bookings;

ALTER TABLE designers
DROP CONSTRAINT pk_designers;



/* ******************************
*								*
*		Drop Tables				*
*								*
*********************************/
DROP TABLE customer_rooms;
DROP TABLE bookings;
DROP TABLE testimonials;
DROP TABLE customers;
DROP TABLE designers;



/* ******************************
*								*
*		Drop Sequences			*
*								*
*********************************/
DROP SEQUENCE designers_seq;
DROP SEQUENCE bookings_seq;
DROP SEQUENCE testimonials_seq;
DROP SEQUENCE customers_seq;
DROP SEQUENCE customer_rooms_seq;



/* ******************************
*								*
*		Drop Object Tables		*
*								*
*********************************/
DROP TABLE addresses;



/* ******************************
*								*
*	Drop Table/Varray Types		*
*								*
*********************************/
DROP TYPE social_media_table_type;
DROP TYPE contact_varray_type;



/* ******************************
*								*
*		Drop Types				*
*								*
*********************************/
DROP TYPE social_media_type;
DROP TYPE contact_type;
DROP TYPE address_type;



/* ******************************
*								*
*		Purge RECYCLEBIN		*
*								*
*********************************/
PURGE RECYCLEBIN;



/* ******************************
*								*
*		Drop Check				*
*								*
*********************************/
SELECT object_name FROM user_objects;



/* ******************************************
*											*
*			EXTRAS FROM DEMO				*
*(HIGHLIGHT BLOCK AND SINGLE LINE UNCOMMENT)*
*********************************************/
-- /*###PLSQL_2_PROCEDURES###*/
-- --SET SERVEROUTPUT ON;

-- CREATE OR REPLACE PROCEDURE proc_add_customer IS
	-- vc_customer_name customers.firstname%TYPE := 'CUSTOMER';
-- BEGIN
	-- INSERT INTO customers (customer_id, firstname)
	-- VALUES (customers_seq.NEXTVAL, vc_customer_name);
-- END proc_add_customer;
-- /
-- SHOW ERRORS

-- /*test proc_add_customer*/
-- SELECT * FROM customers; 
-- -- 5 rows returned
-- EXEC proc_add_customer
-- SELECT * FROM customers; 
-- -- 6 rows returned
-- --Success
-- --DROP PROCEDURE proc_add_customer;

-- CREATE OR REPLACE PROCEDURE proc_delete_customer IS
	-- vn_customer_id customers.customer_id%TYPE;
-- BEGIN
	-- SELECT customers_seq.CURRVAL
	-- INTO vn_customer_id
	-- FROM DUAL;
	
	-- DELETE FROM customers
	-- WHERE customer_id = vn_customer_id;
-- END proc_delete_customer;
-- /
-- SHOW ERRORS

-- /*test proc_delete_customer*/
-- SELECT * FROM customers; 
-- --6 rows returned
-- EXEC proc_delete_customer;
-- SELECT * FROM customers; 
-- --5 rows returned
-- --Success
-- --DROP PROCEDURE proc_delete_customer;

-- CREATE OR REPLACE PROCEDURE proc_param_del_cu
-- (in_customer_id customers.customer_id%TYPE) IS
	
-- BEGIN
	-- DELETE FROM customers
	-- WHERE customer_id = in_customer_id;
-- END proc_param_del_cu;
-- /
-- SHOW ERRORS

-- /*test proc_param_del_cu*/
-- SELECT * FROM customers; 
-- --5 rows returned
-- EXEC proc_param_del_cu(20000005);
-- SELECT * FROM customers; 
-- --4 rows returned
-- --Success
-- --DROP PROCEDURE proc_param_del_cu;

-- --BONUS ACTIVTY
-- CREATE OR REPLACE PROCEDURE proc_firstname (in_firstname customers.firstname%TYPE) IS
	-- vn_length NUMBER(2);
	-- vn_counter NUMBER(2) := 1;
-- BEGIN
	-- DBMS_OUTPUT.PUT_LINE('----FIRSTNAME----');
	-- vn_length := LENGTH(in_firstname);
-- LOOP
	
	-- EXIT WHEN vn_counter = (vn_length + 1);
	-- DBMS_OUTPUT.PUT_LINE(SUBSTR(in_firstname, vn_counter, 1));
	-- vn_counter := vn_counter + 1;
-- END LOOP;
-- END proc_firstname;
-- /
-- SHOW ERRORS

-- /*test proc_firstname*/
-- EXEC proc_firstname('ARYA')
-- --Success
-- EXEC proc_firstname('SILVER')
-- --Success
-- --DROP PROCEDURE proc_firstname;

-- CREATE OR REPLACE PROCEDURE proc_middlename (in_middlename VARCHAR2) IS
	-- vn_length NUMBER(2);
	-- vn_counter NUMBER(2) := 1;
-- BEGIN
	-- DBMS_OUTPUT.PUT_LINE('----MIDDLENAME----');
	-- vn_length := LENGTH(in_middlename);
-- WHILE vn_counter <= vn_length LOOP
	-- DBMS_OUTPUT.PUT_LINE(SUBSTR(in_middlename, vn_counter, 1));
	-- vn_counter := vn_counter + 1;
-- END LOOP;
-- END proc_middlename;
-- /
-- SHOW ERRORS

-- /*test proc_middlename*/
-- EXEC proc_middlename('MARY-ANGEL')
-- --Success
-- EXEC proc_middlename('FLOWERS')
-- --Success
-- --DROP PROCEDURE proc_middlename;

-- CREATE OR REPLACE PROCEDURE proc_lastname (in_lastname customers.lastname%TYPE) IS
	-- vn_length NUMBER(2);
	-- vn_counter NUMBER(2) := 1;
-- BEGIN
	-- DBMS_OUTPUT.PUT_LINE('----LASTNAME----');
	-- vn_length := LENGTH(in_lastname);
-- FOR vn_counter IN 1 .. vn_length LOOP
	-- DBMS_OUTPUT.PUT_LINE(SUBSTR(in_lastname, vn_counter, 1));
-- END LOOP;
-- END proc_lastname;
-- /
-- SHOW ERRORS

-- /*test proc_lastname*/
-- EXEC proc_lastname('MAULE')
-- --Success
-- EXEC proc_lastname('EARDLEY')
-- --Success
-- --DROP PROCEDURE proc_lastname;

-- CREATE OR REPLACE PROCEDURE proc_fir_mid_las (in_firstname customers.firstname%TYPE, in_middlename VARCHAR2, in_lastname customers.lastname%TYPE) IS

-- BEGIN
	-- proc_firstname(in_firstname);
	-- proc_middlename(in_middlename);
	-- proc_lastname(in_lastname);
-- END proc_fir_mid_las;
-- /
-- SHOW ERRORS

-- /*test proc_fir_mid_las*/
-- EXEC proc_fir_mid_las('ARYA', 'MARY-ANGEL', 'MAULE')
-- --Success
-- EXEC proc_fir_mid_las('SILVER', 'FLOWERS', 'EARDLEY')
-- --Success
-- --DROP PROCEDURE proc_fir_mid_las;





-- /*###PLSQL_3_FUNCTIONS###*/
-- CREATE OR REPLACE FUNCTION func_designer_ct RETURN NUMBER IS
	-- vn_designer_ct NUMBER(3);
-- BEGIN
	-- SELECT COUNT(designer_id)
	-- INTO vn_designer_ct
	-- FROM designers;

	-- RETURN vn_designer_ct;
-- END func_designer_ct;
-- /
-- SHOW ERRORS

-- CREATE OR REPLACE PROCEDURE proc_func_designer IS
	-- vn_no_of_designers NUMBER(3);
-- BEGIN
	-- vn_no_of_designers := func_designer_ct;

	-- DBMS_OUTPUT.PUT_LINE('There are ' || vn_no_of_designers || ' designer(s) in the database.');
-- END proc_func_designer;
-- /
-- SHOW ERRORS

-- /*test proc_func_designer*/
-- EXEC proc_func_designer;
-- --Success
-- SELECT COUNT(designer_id) FROM designers;
-- --Success
-- --DROP PROCEDURE proc_func_designer;
-- --DROP FUNCTION func_designer_ct;

-- CREATE OR REPLACE FUNCTION func_pay_desn_ct (in_pay_rate designers.pay_rate%TYPE) RETURN NUMBER IS
	-- vn_designer_ct NUMBER(3);
-- BEGIN
	-- SELECT COUNT(designer_id)
	-- INTO vn_designer_ct
	-- FROM designers
	-- WHERE pay_rate > in_pay_rate;

	-- RETURN vn_designer_ct;
-- END func_pay_desn_ct;
-- /
-- SHOW ERRORS

-- CREATE OR REPLACE PROCEDURE proc_func_pay_desn(in_pay_rate designers.pay_rate%TYPE) IS
	-- vn_no_of_designers NUMBER(3);
-- BEGIN
	-- vn_no_of_designers := func_pay_desn_ct(in_pay_rate);

	-- DBMS_OUTPUT.PUT_LINE('There are ' || vn_no_of_designers || ' designer(s) in the database with a pay rate higher than ' || in_pay_rate || '.');
-- END proc_func_pay_desn;
-- /
-- SHOW ERRORS

-- /*test proc_func_pay_desn*/
-- EXEC proc_func_pay_desn(10);
-- --Success
-- SELECT COUNT(designer_id) FROM designers WHERE pay_rate > 10;
-- --Success
-- EXEC proc_func_pay_desn(5);
-- --Success
-- SELECT COUNT(designer_id) FROM designers WHERE pay_rate > 5;
-- --Success
-- --DROP PROCEDURE proc_func_pay_desn;
-- --DROP FUNCTION func_pay_desn_ct;

-- --BONUS ACTIVTY
-- CREATE OR REPLACE FUNCTION func_cus_username 
-- (in_customer_id customers.customer_id%TYPE)RETURN VARCHAR2 IS
	-- vc_firstname customers.firstname%TYPE;
	-- vc_lastname customers.lastname%TYPE;
	-- vc_username VARCHAR2(7);
	-- --Change to customers.username%TYPE;
-- BEGIN
	-- SELECT firstname
	-- INTO vc_firstname
	-- FROM customers
	-- WHERE customer_id = in_customer_id;
	
	-- SELECT lastname
	-- INTO vc_lastname
	-- FROM customers
	-- WHERE customer_id = in_customer_id;
	
	-- vc_username := CONCAT(SUBSTR(vc_firstname, 1, 2), SUBSTR(vc_lastname, 1, 5));
	
	-- RETURN vc_username;
-- END func_cus_username;
-- /
-- SHOW ERRORS

-- CREATE OR REPLACE PROCEDURE proc_func_cus_username 
-- (in_customer_id customers.customer_id%TYPE) IS
	-- vc_username VARCHAR2(7);
	-- --Change to customers.username%TYPE;
-- BEGIN
	-- vc_username := func_cus_username(in_customer_id);

	-- DBMS_OUTPUT.PUT_LINE('Customers: ' || in_customer_id || ' username set to ' || vc_username || '.');
	-- --Change to -¬
	-- --UPDATE customers 
	-- --SET username = vc_username
	-- --WHERE customer_id = in_customer_id;
-- END proc_func_cus_username;
-- /
-- SHOW ERRORS

-- /*test proc_func_cus_username*/
-- EXEC proc_func_cus_username(20000000);
-- SELECT customer_id, firstname, lastname
-- --Change to SELECT customer_id, username
-- FROM customers
-- WHERE customer_id = 20000000;
-- --DROP PROCEDURE proc_func_cus_username;
-- --DROP FUNCTION func_cus_username





-- /*###PLSQL_4_TRIGGERS###*/
-- CREATE OR REPLACE TRIGGER trig_ar_date_ck
-- BEFORE INSERT OR UPDATE OF arrival_date ON bookings
-- FOR EACH ROW
-- WHEN(NEW.arrival_date < SYSDATE)

-- BEGIN
	-- DBMS_OUTPUT.PUT_LINE('The arrival date cannot exist in the past');
	-- RAISE_APPLICATION_ERROR
	-- (-20000, 'ERROR - THE ARRIVAL DATE CAN NOT EXIST BEFORE TODAYS DATE! 
	-- ARRIVAL DATE: ' || :NEW.arrival_date || ' TODAYS DATE: ' || SYSDATE);
-- END trig_ar_date_ck;
-- /
-- SHOW ERRORS

-- /*test trig_ar_date_ck*/
-- INSERT INTO bookings (booking_id, designer_id, arrival_date)
-- VALUES (bookings_seq.NEXTVAL, 10000000, '01-JUN-2016');
-- --Throws error - Success
-- INSERT INTO bookings (booking_id, designer_id, arrival_date)
-- VALUES (bookings_seq.NEXTVAL, 10000000, '01-JUN-2019');
-- --Should not throw error - Success 
-- --DROP TRIGGER trig_ar_date_ck;

-- CREATE OR REPLACE TRIGGER trig_hire_date
-- AFTER INSERT OR UPDATE ON designers
-- FOR EACH ROW
-- WHEN (NEW.hire_date IS NOT NULL)
-- DECLARE
	-- vd_today designers.hire_date%TYPE := SYSDATE;
-- BEGIN
	-- IF (vd_today - (365*5)) >= :NEW.hire_date
		-- THEN
			-- DBMS_OUTPUT.PUT_LINE('Designer has been hired for or over 5 years.');
		-- ELSE
			-- DBMS_OUTPUT.PUT_LINE('Designer has not been hired for more 5 years.');
	-- END IF;
-- END trig_hire_date;
-- /
-- SHOW ERRORS

-- /*test trig_hire_date*/
-- INSERT INTO designers (designer_id, hire_date)
-- VALUES (designers_seq.NEXTVAL, '01-JAN-2013');
-- --Trigger designer has been hired for over 5 years - Success
-- INSERT INTO designers (designer_id, hire_date)
-- VALUES (designers_seq.NEXTVAL, '01-JAN-2014');
-- --Trigger designer has not been hired for 5 years - Success
-- --DROP TRIGGER trig_hire_date;

-- --BONUS ACTIVITY
-- CREATE OR REPLACE TRIGGER trig_desn_dob_suc
-- BEFORE INSERT ON designers
-- FOR EACH ROW
-- WHEN ((MONTHS_BETWEEN(SYSDATE, NEW.dob)/12) > 18)

-- BEGIN
	-- DBMS_OUTPUT.PUT_LINE('Designer added.');
-- END trig_desn_dob_suc;
-- /
-- SHOW ERRORS

-- /*test trig_desn_dob_suc */
-- INSERT INTO designers (designer_id, dob)
-- VALUES (designers_seq.NEXTVAL, '01-JAN-2000');
-- --Designer added. - Success
-- --DROP TRIGGER trig_desn_dob_suc;

-- CREATE OR REPLACE TRIGGER trig_desn_dob_dec
-- BEFORE INSERT ON designers
-- FOR EACH ROW
-- WHEN ((MONTHS_BETWEEN(SYSDATE, NEW.dob)/12) < 18)

-- BEGIN
	-- DBMS_OUTPUT.PUT_LINE('Designer is too young.');
	-- RAISE_APPLICATION_ERROR
	-- (-20000, 'ERROR - THE DESIGNER IS TOO YOUNG!');
-- END trig_desn_dob_dec;
-- /
-- SHOW ERRORS

-- /*test trig_desn_dob_dec*/
-- INSERT INTO designers (designer_id, dob)
-- VALUES (designers_seq.NEXTVAL, '01-JAN-2010');
-- --ERROR - THE DESIGNER IS TOO YOUNG! - Success
-- --DROP TRIGGER trig_desn_dob_dec;





-- /*###PLSQL_4.5_COMBINED--IMPROVED###*/
-- /*Function determines the months left until retirement based upon the 
-- dob and retirement age passed in its parameters*/
-- CREATE OR REPLACE FUNCTION func_retire_age (in_dob designers.dob%TYPE, in_retire_age NUMBER)
-- RETURN NUMBER IS
	-- vn_age NUMBER(2) := FLOOR(MONTHS_BETWEEN(SYSDATE, in_dob)/12);
	-- vn_months_left NUMBER(3);
-- BEGIN
	
	-- vn_months_left := MOD(in_retire_age, vn_age)*12;
	
	-- RETURN vn_months_left;
-- END func_retire_age;
-- /
-- SHOW ERRORS

-- /*Trigger runs before insert, update or delete on the designers table 
-- taking appropriate action dependant on the action that triggered the trigger.
-- If inserting it displays the name of who is being inserts. If updating it
-- sends the dob of the record being updated to a function which returns the 
-- remaining months until retirements base on a hardcoded age of 67. If deleteing
-- it displays the name of who is being deleted.*/
-- CREATE OR REPLACE TRIGGER trig_designer 
-- BEFORE INSERT OR UPDATE OR DELETE ON designers
-- FOR EACH ROW
-- DECLARE
	-- vn_age NUMBER(2) := FLOOR(MONTHS_BETWEEN(SYSDATE, :NEW.dob)/12);
	-- vn_months_left NUMBER(3);
-- BEGIN
	-- IF (INSERTING OR UPDATING)
		-- THEN
			-- IF INSERTING
				-- THEN
					-- --INSERTING
					-- DBMS_OUTPUT.PUT_LINE('You are adding ' || :NEW.firstname|| ' who is ' || vn_age ||' years old.');
				-- ELSE
					-- --UPDATING
					-- vn_months_left := func_retire_age(:OLD.dob, 67);
					-- DBMS_OUTPUT.PUT_LINE(vn_months_left || ' months until retirement.');
			-- END IF;
		-- ELSE
			-- --DELETING
			-- DBMS_OUTPUT.PUT_LINE('You are deleting ' || :OLD.firstname || '.');
	-- END IF;
-- END trig_designer;
-- /
-- SHOW ERRORS

-- /*test trig_designer*/
-- INSERT INTO designers (designer_id, firstname, dob)
-- VALUES (designers_seq.NEXTVAL, 'JOSH', '26-JAN-1995');
-- --You are adding JOSH who is 23 years old. - Success
-- UPDATE designers SET lastname = 'CHALLAND'
-- WHERE designer_id = 10000021;
-- --252 months until retirement. - Success
-- DELETE FROM designers WHERE designer_id = 10000021;
-- --You are deleting JOSH. - Success

-- /*Procedure takes in a designers id and the age at which they plan to
-- retire, it then stores the designers date of birth using a query. the 
-- dob and age they plan to retire is send to a function which returns the 
-- number of months they have left until retirement.*/
-- CREATE OR REPLACE PROCEDURE proc_retire_param 
-- (in_designer_id designers.designer_id%TYPE, in_retire_age NUMBER)
-- IS
	-- vn_months_left NUMBER(3);
	-- vd_dob DATE;
-- BEGIN

	-- SELECT dob
	-- INTO vd_dob
	-- FROM designers
	-- WHERE designer_id = in_designer_id;

	-- vn_months_left := func_retire_age(vd_dob, in_retire_age);
	
	-- DBMS_OUTPUT.PUT_LINE(vn_months_left || ' months until retirement.');
	
-- END proc_retire_param;
-- /
-- SHOW ERRORS

-- /*test proc_retire_param*/
-- EXEC proc_retire_param(10000000, 67);
-- --300 months until retirement. - Success
-- EXEC proc_retire_param(10000000, 60);
-- --216 months until retirement. - Success

-- --DROP PROCEDURE proc_retire_param;
-- --DROP TRIGGER trig_designer;
-- --DROP FUNCTION func_retire_age;





-- /*###PLSQL_5_CURSORS###*/
-- CREATE OR REPLACE PROCEDURE proc_imp_cursor 
-- (in_firstname designers.firstname%Type) 
-- IS	

-- BEGIN
	-- DELETE FROM designers WHERE firstname = in_firstname;
	
	-- IF SQL%FOUND 
		-- THEN
			-- DBMS_OUTPUT.PUT_LINE(in_firstname || ' REMOVED.');
		-- ELSE 
			-- DBMS_OUTPUT.PUT_LINE(in_firstname || ' DOES NOT EXIST.');
	-- END IF;

-- END proc_imp_cursor;
-- /
-- SHOW ERRORS

-- /*test proc_imp_cursor*/
-- INSERT INTO designers (designer_id, firstname)
-- VALUES(99999999, 'CANDY');
-- EXEC proc_imp_cursor ('CANDY');
-- --CANDY REMOVED. - Success
-- EXEC proc_imp_cursor ('DAISY');
-- --DAISY DOES NOT EXIST. - Success
-- SELECT firstname FROM designers;
-- --NO CANDY OR DAISY IN TABLE - Success

-- --DROP PROCEDURE proc_imp_cursor;

-- CREATE OR REPLACE PROCEDURE proc_exp_cur_book_high 
-- (in_cost bookings.cost%Type) 
-- IS	

	-- CURSOR cur_book_mor IS
	-- SELECT b.booking_id, b.cost, b.order_date, d.firstname
	-- FROM bookings b
	-- JOIN designers d
	-- ON b.designer_id = d.designer_id
	-- WHERE cost > in_cost;
	
	-- rec_cur_book_mor cur_book_mor%ROWTYPE;
	-- vn_row_count NUMBER(2) := 0;

-- BEGIN
	-- DBMS_OUTPUT.PUT_LINE('Number bookings with a cost more than ' || in_cost);
	-- FOR rec_cur_book_mor IN cur_book_mor LOOP
		-- DBMS_OUTPUT.PUT_LINE(cur_book_mor%ROWCOUNT || ' Booking_id: ' || rec_cur_book_mor.booking_id ||
		-- ' Booking cost: ' || rec_cur_book_mor.cost || ' Booking date: '
		-- || rec_cur_book_mor.order_date || ' Designer firstname: ' ||
		-- rec_cur_book_mor.firstname);
		-- vn_row_count := vn_row_count + 1;
	-- END LOOP;
	
	-- IF vn_row_count = 0
		-- THEN
			-- DBMS_OUTPUT.PUT_LINE(vn_row_count || ' bookings cost more than ' || in_cost);
	-- END IF;

-- END proc_exp_cur_book_high;
-- /
-- SHOW ERRORS

-- /*test  proc_exp_cur_book_high*/
-- EXEC proc_exp_cur_book_high(900);
-- /*
-- Bookings with cost more than 900
-- Booking_id: 40000001 Booking cost: 13222.5 Booking date: 03-AUG-17 Designer
-- firstname: STEVE
-- Booking_id: 40000002 Booking cost: 988.25 Booking date: 17-NOV-15 Designer
-- firstname: MYLES
-- Booking_id: 40000003 Booking cost: 20000.49 Booking date: 06-MAY-14 Designer
-- firstname: ELIANE
-- Booking_id: 40000004 Booking cost: 2999.99 Booking date: 19-JAN-17 Designer
-- firstname: MYLES
-- */
-- --Success
-- SELECT booking_id FROM bookings WHERE cost > 900;
-- /*
-- 40000001
-- 40000002
-- 40000003
-- 40000004
-- */
-- --Success

-- --DROP PROCEDURE proc_exp_cur_book_high;

-- CREATE OR REPLACE PROCEDURE proc_exp_cur_book_low 
-- (in_cost bookings.cost%Type) 
-- IS	

	-- CURSOR cur_book_low IS
	-- SELECT b.booking_id, b.cost, b.order_date, d.firstname
	-- FROM bookings b
	-- JOIN designers d
	-- ON b.designer_id = d.designer_id
	-- WHERE cost < in_cost;
	
	-- rec_cur_book_low cur_book_low%ROWTYPE;
	-- vn_row_count NUMBER(2) := 0;

-- BEGIN
	-- DBMS_OUTPUT.PUT_LINE('Bookings with a cost less than ' || in_cost);
	-- FOR rec_cur_book_low IN cur_book_low LOOP
		-- DBMS_OUTPUT.PUT_LINE('Booking_id: ' || rec_cur_book_low.booking_id ||
		-- ' Booking cost: ' || rec_cur_book_low.cost || ' Booking date: '
		-- || rec_cur_book_low.order_date || ' Designer firstname: ' ||
		-- rec_cur_book_low.firstname);
		-- vn_row_count := vn_row_count + 1;
	-- END LOOP;
	
	-- IF vn_row_count = 0
		-- THEN
			-- DBMS_OUTPUT.PUT_LINE(vn_row_count || ' bookings cost less than ' || in_cost);
	-- END IF;
	
-- END proc_exp_cur_book_low;
-- /
-- SHOW ERRORS

-- /*test proc_exp_cur_book_low*/
-- EXEC proc_exp_cur_book_low(900);
-- /*
-- Bookings with cost less than 900
-- Booking_id: 40000000 Booking cost: 766.75 Booking date: 14-FEB-16 Designer
-- firstname: AKPAR
-- */
-- --Success
-- SELECT booking_id FROM bookings WHERE cost < 900;
-- /*
-- 40000000
-- */
-- --Success

-- --DROP PROCEDURE proc_exp_cur_book_low;

-- --BONUS ACTIVITY

-- /*Procedure takes in a rating and creates a cursor which queries all 
-- ratings in testimonials which are greater than the input rating. The 
-- procedure then opens the cursors and checks if a row was found, displaying
-- and appropriate message. If a row was found it loops through the results 
-- displaying the relevant information from the results found.*/
-- CREATE OR REPLACE PROCEDURE proc_higher_rate 
-- (in_rating testimonials.rating%Type) 
-- IS	

	-- CURSOR cur_higher_rate IS
	-- SELECT t.rating, d.designer_id
	-- FROM testimonials t 
	-- JOIN designers d
	-- ON t.designer_id = d.designer_id
	-- WHERE rating > in_rating;
	
	-- rec_cur_higher_rate cur_higher_rate%ROWTYPE;

-- BEGIN
	-- OPEN cur_higher_rate;
	-- FETCH cur_higher_rate INTO rec_cur_higher_rate;
	
	-- IF cur_higher_rate%NOTFOUND
		-- THEN
			-- DBMS_OUTPUT.PUT_LINE('There are no designers with a rating higher than ' || in_rating);
		-- ELSE
			-- DBMS_OUTPUT.PUT_LINE('Designers with a rating higher than ' || in_rating);
	-- END IF;
	
	-- WHILE cur_higher_rate%FOUND
			-- LOOP
				-- DBMS_OUTPUT.PUT_LINE(cur_higher_rate%ROWCOUNT || ' Designer ID: ' || rec_cur_higher_rate.designer_id ||
				-- ' Designers Rating: ' || rec_cur_higher_rate.rating);
				-- FETCH cur_higher_rate INTO rec_cur_higher_rate;
			-- END LOOP;
	
	-- CLOSE cur_higher_rate;
	
-- END proc_higher_rate;
-- /
-- SHOW ERRORS

-- /*test proc_higher_rate*/
-- EXEC proc_higher_rate(5);
-- /*
-- Designers with a rating higher than 5
-- 1 Designer ID: 10000001 Designers Rating: 7
-- 2 Designer ID: 10000001 Designers Rating: 7
-- 3 Designer ID: 10000001 Designers Rating: 10
-- 4 Designer ID: 10000003 Designers Rating: 6
-- */
-- --Success
-- SELECT designer_id, rating FROM testimonials WHERE rating > 5;
-- /*
   -- 10000001          7
   -- 10000001          7
   -- 10000001         10
   -- 10000003          6
-- */
-- --Success

-- --DROP PROCEDURE proc_higher_rate;





-- /*###PLSQL_EXTRAS###*/
-- /*Function takes in the total area of a room, a pay rate of a designer, 
-- and average rating of said designer. The function then uses the three 
-- arguements to generate a total cost which is return to the calling routine.*/
-- CREATE OR REPLACE FUNCTION func_booking_cost 
-- (in_total_area NUMBER, in_pay_rate designers.pay_rate%TYPE, in_avg_rate testimonials.rating%TYPE) 
-- RETURN NUMBER IS
	-- out_vn_total_cost NUMBER(8);
-- BEGIN
	-- out_vn_total_cost := in_total_area * ((in_pay_rate * 0.025)*(in_avg_rate*0.1));

	-- RETURN out_vn_total_cost;
-- END func_booking_cost;
-- /
-- SHOW ERRORS;

-- --DROP FUNCTION func_booking_cost;

-- /*Function calculates and returns the total area based upon two parameters passed if which are 
-- assumed to be measurements.*/
-- CREATE OR REPLACE FUNCTION func_total_area
-- (in_length customer_rooms.room_length%TYPE, in_width customer_rooms.room_width%TYPE)
-- RETURN NUMBER IS
	-- out_vn_total_area NUMBER(10);
-- BEGIN
	-- out_vn_total_area := in_length * in_width;
	
	-- RETURN out_vn_total_area;
-- END func_total_area;
-- /
-- SHOW ERRORS;

-- --DROP FUNCTION func_total_area;

-- /*Procedure takes in a total area and booking id. The booking id is then
-- used in a cursors to find all customer rooms under the same booking, each
-- customer rooms area is then added to the total area of the booking. It is also 
-- used in two queries that extracted the designers pay rate and average rating 
-- via joins and the AVG function into two variables. The total area, pay rate, 
-- and average rating are then passed to a function which returns a total cost 
-- which is used to update the booking associated with the booking id with a 
-- new cost.*/
-- CREATE OR REPLACE PROCEDURE proc_booking_cost 
-- (in_total_area NUMBER, in_booking_id bookings.booking_id%TYPE) 
-- IS
	
	-- CURSOR cur_total_area IS
	-- SELECT cr.room_length, cr.room_width
	-- FROM customer_rooms cr
	-- WHERE booking_id = in_booking_id;
	
	-- vn_total_area NUMBER(10) := in_total_area;
	
	-- vn_total_cost bookings.cost%TYPE;
	-- vn_pay_rate designers.pay_rate%TYPE;
	-- vn_avg_rat testimonials.rating%TYPE;
	
	-- rec_cur_total_area cur_total_area%ROWTYPE;

	
-- BEGIN

	-- FOR rec_cur_total_area IN cur_total_area LOOP
		-- vn_total_area := vn_total_area + func_total_area(rec_cur_total_area.room_length, rec_cur_total_area.room_width);
	-- END LOOP;
	
	-- SELECT d.pay_rate
	-- INTO vn_pay_rate
	-- FROM designers d
	-- JOIN bookings b
	-- ON d.designer_id = b.designer_id
	-- WHERE b.booking_id = in_booking_id;
	
	-- SELECT AVG(t.rating)
	-- INTO vn_avg_rat
	-- FROM testimonials t
	-- JOIN designers d
	-- ON t.designer_id = d.designer_id
	-- JOIN bookings b
	-- ON d.designer_id = b.designer_id
	-- WHERE b.booking_id = in_booking_id
	-- GROUP BY t.designer_id;

	-- vn_total_cost := func_booking_cost(vn_total_area, vn_pay_rate, vn_avg_rat);

	-- UPDATE bookings 
	-- SET cost = vn_total_cost
	-- WHERE booking_id = in_booking_id;
	
-- END proc_booking_cost;
-- /
-- SHOW ERRORS

-- --DROP PROCEDURE proc_booking_cost;

-- /*Trigger runs when a customer room is inserted. It takes the width and length
-- and works out the total area and passes it into the procedure to update the
-- bookings cost*/
-- CREATE OR REPLACE TRIGGER trig_booking_cost
-- BEFORE INSERT ON customer_rooms
-- FOR EACH ROW
-- WHEN ((NEW.room_width IS NOT NULL) AND(NEW.room_length IS NOT NULL))
-- DECLARE

	-- vn_total_area NUMBER(10); 
	
-- BEGIN
	
	-- vn_total_area := func_total_area(:NEW.room_width, :NEW.room_length);
	-- proc_booking_cost(vn_total_area, :NEW.booking_id);

-- END trig_booking_cost;
-- /
-- SHOW ERRORS

-- --original cost: 766.75 --select cost from bookings where booking_id = 40000000;
-- --desinger_id: 10000000 --select designer_id from bookings where booking_id = 40000000;
-- --pay_rate: 9 --select pay_rate from designers where designer_id = 10000000;
-- /*
-- INSERT INTO testimonials (testimonial_id, designer_id, rating)
-- VALUES (testimonials_seq.NEXTVAL, 10000000, 5);
-- --DELETE FROM customer_rooms WHERE customer_id = 20000000;
-- */
-- --avg(rating): 5  --select AVG(rating) from testimonials where designer_id = 10000000;
-- --New cost: 281.25

-- INSERT INTO customer_rooms (customer_room_id, customer_id, booking_id, room_width, room_length)
-- VALUES (customer_rooms_seq.NEXTVAL, 20000000, 40000000, 50, 50);
-- /*
-- select booking_id, cost from bookings;
-- BOOKING_ID       COST
-- ---------- ----------
  -- 40000000        281
  
  -- --SUCCESS
-- */


-- -- DROP TRIGGER trig_booking_cost;





