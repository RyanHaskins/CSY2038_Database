--CSY2038 PR1 Assignment - CREATES

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

--@E:\scripts\creates.sql

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

