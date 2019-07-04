--CSY2038 PR1 Assignment - TRIGGERS

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

--@E:\scripts\triggers.sql

/* Useful Commands
COLUMN object_name FORMAT A20
COLUMN object_type FORMAT A20
SELECT object_name, object_type FROM user_objects;
*/



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






