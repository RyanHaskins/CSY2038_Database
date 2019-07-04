--CSY2038 PR1 Assignment - INSERT

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

--@E:\scripts\inserts.sql

/* Useful Commands
*/



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
