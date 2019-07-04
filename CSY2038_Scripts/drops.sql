--CSY2038 PR1 Assignment - DROPS

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

--@E:\scripts\drops.sql

/* Useful Commands
*/



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





