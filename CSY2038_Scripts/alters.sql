--CSY2038 PR1 Assignment - ALTERS

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

--@E:\scripts\alters.sql

/* Useful Commands
COLUMN object_name FORMAT A20;
COLUMN object_type FORMAT A20;
SELECT object_name, object_type FROM user_objects;
*/



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
