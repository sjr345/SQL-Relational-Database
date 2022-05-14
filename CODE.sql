-- -------------------------------------------------------------------------------------------------------------------------------
--File			: INFO605_WI22_ProjectFINAL_Group1_Report2.sql
--Desc			: FINAL Project 
--Author		   : Ashleigh Brauer(Ab3372)
--Author       : Haydn Chen(HC698) 
--Author       : Poojan Bhavsar (PB655) 
--Author       : Jessica Hutchison (JH3865)
--Author       : Shane Rebstock(SJR345) 
--Create Date 	: March 17, 2022
-- ------------------------------------------------------------------------------------------------------------------------------

-- Clear enviroment of existing tables
DROP TABLE rents;
DROP TABLE owns;
DROP TABLE bookcopy;
DROP TABLE bookdescription;
DROP TABLE audiobookcopy;
DROP TABLE audiobookdescription;
DROP TABLE movies;
DROP TABLE music;
DROP TABLE adult;
DROP TABLE minor;
DROP TABLE staff;
DROP TABLE member;
DROP TABLE rentalcopy;
DROP TABLE readingroom;
DROP TABLE addressbook;

--Create table displaying address book information
--Ashleigh AB3372, Poojan PB655, Shane SJR345, Haydn HC698, Jessica JH3865
CREATE TABLE AddressBook (
addressID VARCHAR2(6) CONSTRAINT address_pk PRIMARY KEY,
street VARCHAR2(30) CONSTRAINT address_nn_street NOT NULL,
city VARCHAR2(20)CONSTRAINT address_nn_city NOT NULL,
state VARCHAR2(10)CONSTRAINT address_nn_state NOT NULL,
zip CHAR(5) CONSTRAINT address_nn_zip NOT NULL
);

--Create table displaying reading room information
--Poojan PB655
CREATE TABLE ReadingRoom(
   LocationID VARCHAR2(15) CONSTRAINT LOCATION_PK_LID PRIMARY KEY,
   PhoneNumber CHAR(10),
   AddressID VARCHAR2(6) CONSTRAINT LOCATION_FK_ADDRESS REFERENCES AddressBook(AddressID) ON DELETE CASCADE
);

--Create table displaying staff information
--Poojan PB655
Create Table Staff(
   StaffID CHAR(4) CONSTRAINT STAFF_PK_SID PRIMARY KEY,
   FirstName VARCHAR2(15) CONSTRAINT STAFF_NN_FNAME NOT NULL,
   LastName VARCHAR2(15) CONSTRAINT STAFF_NN_LNAME NOT NULL,
   Position VARCHAR2(20) CONSTRAINT STAFF_NN_POSITION NOT NULL,
   LocationID VARCHAR2(15), CONSTRAINT STAFF_FK1_LOCATION FOREIGN KEY (LocationID) REFERENCES ReadingRoom (LocationID) ON DELETE SET NULL,
   AddressID VARCHAR(6) CONSTRAINT STAFF_FK2_ADDRESS REFERENCES AddressBook(AddressID) ON DELETE CASCADE
);

--Create table displaying member information
--Poojan PB655
CREATE TABLE Member(
   MemberID CHAR(5) CONSTRAINT MEMBER_PK_MID PRIMARY KEY,
   FirstName VARCHAR2(50) CONSTRAINT MEMBER_NN_FNAME NOT NULL,
   LastName VARCHAR2(50) CONSTRAINT MEMBER_NN_LNAME NOT NULL,
   BirthDate DATE CONSTRAINT MEMBER_NN_DOB NOT NUll,
   Gender VARCHAR2(6),
   SubscriptionDate DATE CONSTRAINT MEMBER_NN_SUBSDATE NOT NULL,
   LocationID VARCHAR2(15), CONSTRAINT MEMBER_FK1_LOCATION FOREIGN KEY (LocationID) REFERENCES ReadingRoom (LocationID) ON DELETE SET NULL,
   AddressID VARCHAR2(6) CONSTRAINT MEMBER_FK2_ADDRESS REFERENCES AddressBook(AddressID) ON DELETE CASCADE
);

--Create table displaying minor member information
--Ashleigh AB3372
CREATE TABLE Minor(
   MemberID CHAR(5) CONSTRAINT MINOR_PK PRIMARY KEY,
   CONSTRAINT MINOR_FK_MID FOREIGN KEY (MemberID) REFERENCES Member (MemberID) ON DELETE CASCADE,
   GuardianName VARCHAR2(50) CONSTRAINT MINOR_NN_GUARDNAME NOT NULL,
   GuardianPhone CHAR(10) CONSTRAINT MINOR_NN_GUARDPHONE NOT NULL,
   GuardianEmail VARCHAR2(50) CONSTRAINT MINOR_NN_GUARDEMAIL NOT NULL
);

--Create table displaying adult member information
--Ashleigh AB3372
CREATE TABLE Adult (
   MemberID CHAR(5) CONSTRAINT ADULT_PK PRIMARY KEY,
   CONSTRAINT ADULT_FK_MID FOREIGN KEY (MemberID) REFERENCES Member (MemberID) ON DELETE CASCADE,
   DriversLicense VARCHAR2(50) CONSTRAINT ADULT_UQ_DLICENSE UNIQUE,
   PhoneNumber CHAR(10) CONSTRAINT ADULT_NN_PHONE NOT NULL,
   Email VARCHAR2(50) CONSTRAINT ADULT_NN_EMAIL NOT NULL
);

--Create table displaying rentalcopy information
--Ashleigh AB3372
CREATE TABLE RentalCopy(
   Barcode CHAR(12) CONSTRAINT RENTALCOPY_PK_BCODE PRIMARY KEY,
   Name VARCHAR2(50) CONSTRAINT RENTALCOPY_NN_NAME NOT NULL,
   STATUS VARCHAR2(3) CONSTRAINT RENTALCOPY_NN_STATUS NOT NULL,
   CONSTRAINT RENTALCOPY_CK_STATUS CHECK(STATUS IN ('IN', 'OUT'))
);

--Create table displaying information about rented items
--Jessica JH3865
CREATE TABLE Rents (
   memberID CHAR(5) CONSTRAINT rents_fk1_mid REFERENCES Member(memberID) ON DELETE CASCADE,
   barcode CHAR(12) CONSTRAINT rents_fk2_bcode REFERENCES RentalCopy(barcode) ON DELETE CASCADE,
   restriction CHAR(1) CONSTRAINT rents_nn_restriction NOT NULL
   CONSTRAINT rents_ck_restriction CHECK (Restriction IN ('Y','N')),
   checkIn DATE CONSTRAINT rents_nn_cin NOT NULL,
   checkOut DATE CONSTRAINT rents_nn_cout NOT NULL,
   CONSTRAINT rents_pk PRIMARY KEY (memberID, barcode)
);

--Create table displaying information about items owned by the reading rooms
--Jessica JH3865
CREATE TABLE Owns (
   locationID VARCHAR2(15) CONSTRAINT owns_fk1 REFERENCES ReadingRoom(locationID) ON DELETE CASCADE,
   barcode CHAR(12) CONSTRAINT owns_fk2 REFERENCES RentalCopy(barcode) ON DELETE CASCADE,
   CONSTRAINT owns_pk PRIMARY KEY (locationID, barcode)
);

--Create table displaying descriptive information about books
--Jessica JH3865
CREATE TABLE BookDescription (
   ISBN CHAR(13) CONSTRAINT bookdesc_pk PRIMARY KEY,
   author VARCHAR2(50) CONSTRAINT bookdesc_nn_author NOT NULL,
   publisher VARCHAR2(50) CONSTRAINT bookdesc_nn_pub NOT NULL,
   year NUMBER(4) CONSTRAINT bookdesc_nn_year NOT NULL,
   genre VARCHAR2(50) CONSTRAINT bookdesc_nn_genre NOT NULL
);

--Create BookCopy table
--Haydn HC698
CREATE TABLE BookCopy(
   Barcode CHAR(12)
       CONSTRAINT BKCOPY_PK PRIMARY KEY
       CONSTRAINT BKCOPY_FK1 REFERENCES RentalCopy (Barcode)
       ON DELETE CASCADE,
   ISBN CHAR(13) CONSTRAINT BKCOPY_FK2 REFERENCES BookDescription (ISBN)
       ON DELETE CASCADE
);

--Create AudioBookDescription table
--Haydn HC698
CREATE TABLE AudioBookDescription(
   ISBN CHAR(13) CONSTRAINT AUDIOBKDESC_PK PRIMARY KEY,
   Author VARCHAR2(50) CONSTRAINT AUDIOBKDESC_NN_AUTHOR NOT NULL,
   Publisher VARCHAR2(50) CONSTRAINT AUDIOBKDESC_NN_PUB NOT NULL,
   Genre VARCHAR2(50) CONSTRAINT AUDIOBKDESC_NN_GENRE NOT NULL
);

--Create AudioBookCopy table
--Haydn HC698
CREATE TABLE AudioBookCopy(
   Barcode CHAR(12)
       CONSTRAINT AUDIOBKCOPY_PK PRIMARY KEY
       CONSTRAINT AUDIOBKCOPY_FK1 REFERENCES RentalCopy (Barcode)
           ON DELETE CASCADE,
   ISBN CHAR(13) CONSTRAINT AUDIOBKCOPY_FK2 REFERENCES AudioBookDescription (ISBN)
       ON DELETE CASCADE
);

--Create table displaying information about movies
--Shane SJR345
CREATE TABLE Movies (
   Barcode CHAR(12) CONSTRAINT MOVIE_PK_BARCODE PRIMARY KEY,
   CONSTRAINT MOVIE_FK_BARCODE FOREIGN KEY (Barcode) REFERENCES RentalCopy(Barcode),
   Director VARCHAR2(25) CONSTRAINT MOVIE_NN_DIRECTOR NOT NULL,
   Year NUMBER (4) CONSTRAINT MOVIE_NN_YEAR NOT NULL,
   Title VARCHAR2(50) CONSTRAINT MOVIE_NN_TITLE NOT NULL
);

--Create table displaying information about music items
--Shane SJR345
CREATE TABLE Music(
   Barcode CHAR(12) CONSTRAINT MUSIC_PK_BARCODE PRIMARY KEY,
   CONSTRAINT MUSIC_FK_BARCODE FOREIGN KEY (Barcode) REFERENCES RentalCopy(Barcode),
   Album VARCHAR(20) CONSTRAINT  MUSIC_NN_ALBUM NOT NULL,
   Year NUMBER(4) CONSTRAINT MUSIC_NN_YEAR NOT NULL,
   Format VARCHAR(2) CONSTRAINT MUSIC_NN_FORMAT NOT NULL,
   Genre VARCHAR2(20) CONSTRAINT MUSIC_NN_GENRE NOT NULL
);

--Insert values into AddressBook table
--Ashleigh AB3372, Poojan PB655, Shane SJR345, Haydn HC698, Jessica JH3865
INSERT INTO AddressBook VALUES ('AB1234', '379 Bushwick Avenue', 'Brooklyn', 'NY', '81620');
INSERT INTO AddressBook VALUES ('AB5678', '350 Broadway Avenue', 'Brooklyn', 'NY', '16180');
INSERT INTO AddressBook VALUES ('AB9012', '193 Meserole Avenue', 'Brooklyn', 'NY', '11222');
INSERT INTO AddressBook VALUES ('AB3456', '499 Rogers Avenue', 'Brooklyn', 'NY', '11225');
INSERT INTO AddressBook VALUES ('AB7890', '31-47 Steinway Street', 'Queens', 'NY', '11103');
INSERT INTO AddressBook VALUES ('AB2345', '3214 Sapphire Court', 'Wilmington', 'DE', '19810');
INSERT INTO AddressBook VALUES ('AB6789', '1429 Poplar Street', 'Philadelphia', 'PA', '19130');
INSERT INTO AddressBook VALUES ('AB0123', '121 Arrowhead Drive', 'Burlington', 'NJ', '18016');
INSERT INTO AddressBook VALUES ('AB4567', '1824 Spring Garden Street', 'Philadelphia', 'PA', '19132');
INSERT INTO AddressBook VALUES ('AB8901', '101 Chestnut Street', 'Philadelphia', 'PA', '19308');
INSERT INTO AddressBook VALUES ('AB9876', '4701 Green Street', 'Malvern', 'PA', '19825');
INSERT INTO AddressBook VALUES ('AB5432', '1405 South 2nd Street', 'Philadelphia', 'PA', '19103');
INSERT INTO AddressBook VALUES ('AB1098', '1776 Benjamin Franklin Parkway', 'Philadelphia', 'PA', '19103');
INSERT INTO AddressBook VALUES ('AB7654', '4302 Forest Hills Drive', 'Cherry Hill', 'NJ', '18045');
INSERT INTO AddressBook VALUES ('AB3210', '874 Wild Street', 'Manhattan', 'NY', '19832');
INSERT INTO AddressBook VALUES ('AB8765', '30 Sapphire Drive', 'Manhattan', 'NY', '19832');
INSERT INTO AddressBook VALUES ('AB4321', '425 Ruby Court', 'Los Angeles', 'CA', '19901');
INSERT INTO AddressBook VALUES ('AB0987', '505 Second Street', 'Manhattan', 'NY', '21040');
INSERT INTO AddressBook VALUES ('AB6543', '83 Monore Street', 'Brooklyn', 'NY', '11204');
INSERT INTO AddressBook VALUES ('AB2109', '30 Lake Forest Drive', 'Brooklyn', 'NY', '11204');
INSERT INTO AddressBook VALUES ('AB1122', '115 W. 30th Street', 'Manhattan', 'NY', '12106');
INSERT INTO AddressBook VALUES ('AB2233', '5089 Blue Lane', 'Newark', 'NJ', '18116');
INSERT INTO AddressBook VALUES ('AB3344', '747 Fire Lane', 'Short Hills', 'NJ', '11176');
INSERT INTO AddressBook VALUES ('AB5566', '395 Short Circle', 'Newark', 'DE', '12186');
INSERT INTO AddressBook VALUES ('AB6677', '121 E. Cira Green Street', 'Woodside', 'NY', '11503');
INSERT INTO AddressBook VALUES ('AB7788', '500 Walnut Lane', 'Philadelphia', 'PA', '19103');
INSERT INTO AddressBook VALUES ('AB8899', '5440 Michael Court', 'Pipersville', 'PA', '18947');
INSERT INTO AddressBook VALUES ('AB0011', '169 E 71st Street', 'Lenox Hill', 'NY', '10021');
INSERT INTO AddressBook VALUES ('AB2230', '66 Perry Street', 'New York', 'NY', '10014');
INSERT INTO AddressBook VALUES ('AB3340', '36 Fuller Place', 'Brooklyn', 'NY', '11215');
INSERT INTO AddressBook VALUES ('AB5560', '41 Charlton Street', 'New York', 'NY', '10014');
INSERT INTO AddressBook VALUES ('AB1212', '11 Wall Street', 'New York', 'NY', '10005');
INSERT INTO AddressBook VALUES ('AB3434', '161 Washington Ave Extension', 'Albany', 'NY', '12205');
INSERT INTO AddressBook VALUES ('AB5656', '1060 Mall Walk', 'Yonkers', 'NY', '10704');
INSERT INTO AddressBook VALUES ('AB7878', '748 Drew Street', 'Brooklyn', 'NY', '11208');

--Data to be inserted into ReadingRoom table
--Poojan PB655
INSERT INTO ReadingRoom VALUES ('Bushwick Ave', '9175690384', 'AB1234');
INSERT INTO ReadingRoom VALUES ('Broadway Ave', '9174730631', 'AB5678');
INSERT INTO ReadingRoom VALUES ('Meserole Ave', '7183497623', 'AB9012');
INSERT INTO ReadingRoom VALUES ('Rogers Ave', '3474137944', 'AB3456');
INSERT INTO ReadingRoom VALUES ('Steinway St', '9292080072', 'AB7890');
 
--Data to be inserted into Staff table
--Poojan PB655
INSERT INTO Staff VALUES ('3372', 'Ashleigh', 'Brauer', 'Marketing Specialist', 'Bushwick Ave', 'AB2345');
INSERT INTO Staff VALUES ('3864', 'Jessica', 'Hutchison', 'Circulation', 'Broadway Ave', 'AB6789');
INSERT INTO Staff VALUES ('3933', 'Poojan', 'Bhavsar', 'Item Tracker', 'Meserole Ave', 'AB0123');
INSERT INTO Staff VALUES ('3436', 'Haydn', 'Chen', 'Librarian', 'Bushwick Ave', 'AB4567');
INSERT INTO Staff VALUES ('3834', 'Shane', 'Rebstock', 'Library Technician', 'Rogers Ave', 'AB8901');
INSERT INTO Staff VALUES ('4785', 'Violet', 'Jones', 'Page', 'Broadway Ave', 'AB9876');
INSERT INTO Staff VALUES ('4790', 'Roger', 'Fleck', 'Librarian', 'Bushwick Ave', 'AB5432');
INSERT INTO Staff VALUES ('7248', 'Angela', 'Rhoades', 'Item Tracker', 'Meserole Ave', 'AB1098');
INSERT INTO Staff VALUES ('7185', 'Patricia', 'Wagner', 'Circulation', 'Steinway St', 'AB7654'); 

--Data to be inserted into Member table
--Poojan PB655
INSERT INTO Member VALUES ('12345', 'Bob', 'Albert', '25-Jul-1992', 'Male', '17-Mar-2017', 'Bushwick Ave', 'AB3210');
INSERT INTO Member VALUES ('23456', 'Ryan', 'Brown', '05-Dec-1980', 'Male', '05-Jan-2019', 'Bushwick Ave', 'AB8765');
INSERT INTO Member VALUES ('34567', 'Olivia', 'Pierce', '12-Mar-1974', 'Female', '19-Mar-2017', 'Bushwick Ave', 'AB4321');
INSERT INTO Member VALUES ('45678', 'Henry', 'Shallow', '30-Sep-2005', 'Other', '08-Apr-2015', 'Meserole Ave', 'AB0987');
INSERT INTO Member VALUES ('56789', 'William', 'Todd', '07-Jan-2010', 'Male', '21-Oct-2019', 'Broadway Ave', 'AB6543');
INSERT INTO Member VALUES ('67890', 'Mia', 'Potts', '13-May-2007', 'Other', '11-Feb-2021', 'Rogers Ave', 'AB2109');
INSERT INTO Member VALUES ('98765', 'Nova', 'Sky', '12-Feb-2006', 'Female', '13-Dec-2013', 'Rogers Ave', 'AB1122');
INSERT INTO Member VALUES ('87654', 'River', 'Axel', '11-Jul-2007', 'Other', '9-Jul-2015', 'Rogers Ave', 'AB2233');
INSERT INTO Member VALUES ('76543', 'Finn', 'Roberts', '10-Sep-2008', 'Male', '23-Aug-2018', 'Broadway Ave', 'AB3344');
INSERT INTO Member VALUES ('65432', 'Mateo', 'Hill', '09-Mar-2011', 'Male', '21-Sep-2019', 'Steinway St', 'AB5566');
INSERT INTO Member VALUES ('54321', 'Otis', 'Orion', '30-Aug-1998', 'Male', '03-Dec-2017', 'Rogers Ave', 'AB6677');
INSERT INTO Member VALUES ('66223', 'Peter', 'Odell', '24-Jan-1983', 'Male', '07-Feb-2019', 'Rogers Ave', 'AB7788');
INSERT INTO Member VALUES ('33853', 'Avon', 'Barksdale', '12-May-1993', 'Male', '21-Nov-2015', 'Broadway Ave', 'AB8899');
INSERT INTO Member VALUES ('12956', 'Raymond', 'Dalio', '19-Jun-1989', 'Male', '23-May-2018', 'Steinway St', 'AB0011');
INSERT INTO Member VALUES ('75133', 'Ryan', 'Seacrest', '24-Jul-1979', 'Male', '25-Apr-2020', 'Broadway Ave', 'AB2230');
INSERT INTO Member VALUES ('92121', 'Aaron', 'Hotchner', '01-Apr-1985', 'Male', '27-Feb-2018', 'Steinway St', 'AB3340');
INSERT INTO Member VALUES ('23567', 'Jenifer', 'Rodriguez', '14-Feb-1998', 'Female', '04-Jan-2017', 'Broadway Ave', 'AB5560');
INSERT INTO Member VALUES ('14495', 'Shaun', 'White', '10-Sep-1994', 'Male', '24-Mar-2016', 'Bushwick Ave', 'AB1212');
INSERT INTO Member VALUES ('48293', 'April', 'Rod', '25-Sep-1995', 'Female', '20-Jun-2014', 'Steinway St', 'AB3434');
INSERT INTO Member VALUES ('65038', 'Lily', 'Jones', '21-Dec-1989', 'Female', '01-Dec-2020', 'Rogers Ave', 'AB5656');
INSERT INTO Member VALUES ('27496', 'Lana', 'Combs', '14-Feb-1992', 'Female', '15-Mar-2021', 'Broadway Ave', 'AB7878');
 
--Data to be inserted into Minor table
--Ashleigh AB3372
INSERT INTO Minor VALUES ('67890', 'Nova Potts', '6093452345', 'NP234@gmail.com');
INSERT INTO Minor VALUES ('98765', 'Matthew Sky', '4563217869',   'MS342@gmail.com');
INSERT INTO Minor VALUES ('76543', 'Tara Roberts', '6092347869', 'TR678@gmail.com');
INSERT INTO Minor VALUES ('45678', 'Shallow Green', '4569684586', 'Sh@657@gmail.com');
INSERT INTO Minor VALUES ('56789', 'Rachel Todd', '6096522680',   'RT123@gmail.com');
INSERT INTO Minor VALUES ('65432', 'Francis Hill', '4357638594', 'HI@gmail.com');
INSERT INTO Minor VALUES ('87654', 'Axel Tire', '6092348470', 'AX@gmail.com');
 
--Data to be inserted into Adult table
--Ashleigh AB3372
INSERT INTO Adult VALUES ('12345', '987654321', '6095672343', 'DF@gmail.com');
INSERT INTO Adult VALUES ('23456', '234567890', '4654678943', 'dh@gmail.com');
INSERT INTO Adult VALUES ('34567', '998877665', '6092344637', 'pq@gmail.com');
INSERT INTO Adult VALUES ('54321', '112233455', '3454653747', 'sr@gmail.com');
INSERT INTO Adult VALUES ('66223', '123456789', '5548473833', 'ab@gmail.com');
INSERT INTO Adult VALUES ('33853', '543212345', '6095643472', 'pb@gmail.com');
INSERT INTO Adult VALUES ('12956', '765876987', '6093824329', 'jc@gmail.com');
INSERT INTO Adult VALUES ('75133', '334455667', '5328493291', 'hc@gmail.com');
INSERT INTO Adult VALUES ('92121', '284742982', '6097922390', 'bs@gmail.com');
INSERT INTO Adult VALUES ('23567', '436401923', '6093213943', 'ks@gmail.com');
INSERT INTO Adult VALUES ('14495', '785932485', '5423480493', 'fb@gmail.com');
INSERT INTO Adult VALUES ('48293', '937405987', '3042852948', 'aj@gmail.com');
INSERT INTO Adult VALUES ('65038', '283740912', '4034852945', 'ff@gmail.com');
INSERT INTO Adult VALUES ('27496', '385017465', '3943953947', 'ro@gmail.com');
 
--Data to be inserted into RentalCopy table
--Ashleigh AB3372
INSERT INTO RentalCopy VALUES ('786244744221', 'Cats Cradle', 'OUT');
INSERT INTO RentalCopy VALUES ('981769123582', 'Animal Farm', 'OUT');
INSERT INTO RentalCopy VALUES ('676716987784', 'The Garden of Eden', 'OUT');
INSERT INTO RentalCopy VALUES ('345983948752', 'A History of Communism', 'IN');
INSERT INTO RentalCopy VALUES ('329874982374', 'A Hundred Thousand Hours', 'IN');
INSERT INTO RentalCopy VALUES ('938474626372', 'A return to love', 'OUT');
INSERT INTO RentalCopy VALUES ('834967238874', 'The Secret Life of Bees', 'IN');
INSERT INTO RentalCopy VALUES ('564563245342', 'The Invisible Man', 'IN');
INSERT INTO RentalCopy VALUES ('478236176547', 'Into the Wild', 'OUT');
INSERT INTO RentalCopy VALUES ('423245634324', 'Where the Sidewalk Ends', 'IN');
INSERT INTO RentalCopy VALUES ('546378671928', 'A Knights Tale', 'OUT');
INSERT INTO RentalCopy VALUES ('983647562543', 'The Nun', 'OUT');
INSERT INTO RentalCopy VALUES ('761235687683', 'Episode IV: A New Hope', 'IN');
INSERT INTO RentalCopy VALUES ('983673465578', 'The Avengers', 'OUT');
INSERT INTO RentalCopy VALUES ('127836983482', 'Parasite', 'IN');
INSERT INTO RentalCopy VALUES ('786964534253', 'Sour', 'OUT');
INSERT INTO RentalCopy VALUES ('958564642239', 'Fearless', 'IN');
INSERT INTO RentalCopy VALUES ('983735355987', 'Christmas Classics', 'OUT');
INSERT INTO RentalCopy VALUES ('798234548978', 'After Hours', 'OUT');
INSERT INTO RentalCopy VALUES ('985454758653', 'Take Care', 'IN');
 
--Data to be inserted into Rents table
--Jessica JH3865
INSERT INTO Rents VALUES ('12345', '786244744221', 'N', '15-MAR-2022', '01-MAR-2022');
INSERT INTO Rents VALUES ('75133', '981769123582', 'N', '08-MAR-2022', '22-FEB-2022');
INSERT INTO Rents VALUES ('66223', '676716987784', 'N', '24-JAN-2022', '12-JAN-2022');
INSERT INTO Rents VALUES ('23456', '938474626372', 'N', '13-FEB-2022', '30-JAN-2022');
INSERT INTO Rents VALUES ('87654', '478236176547', 'N', '15-JAN-2022', '01-JAN-2022');
INSERT INTO Rents VALUES ('12345', '546378671928', 'N', '15-MAR-2022', '01-MAR-2022');
INSERT INTO Rents VALUES ('67890', '983647562543', 'Y', '08-MAR-2022', '22-FEB-2022');
INSERT INTO Rents VALUES ('65432', '983673465578', 'N', '26-DEC-2021', '12-DEC-2021');
INSERT INTO Rents VALUES ('92121', '786964534253', 'N', '09-JAN-2022', '24-DEC-2021');
INSERT INTO Rents VALUES ('65432', '983735355987', 'N', '18-MAR-2022', '04-MAR-2022');
INSERT INTO Rents VALUES ('65432', '798234548978', 'Y', '18-MAR-2022', '04-MAR-2022');
 
--Data to be inserted into Owns table
--Jessica JH3865
INSERT INTO Owns VALUES ('Bushwick Ave', '786244744221');
INSERT INTO Owns VALUES ('Broadway Ave', '981769123582');
INSERT INTO Owns VALUES ('Steinway St', '676716987784');
INSERT INTO Owns VALUES ('Rogers Ave', '345983948752');
INSERT INTO Owns VALUES ('Bushwick Ave', '329874982374');
INSERT INTO Owns VALUES ('Meserole Ave', '938474626372');
INSERT INTO Owns VALUES ('Rogers Ave', '834967238874');
INSERT INTO Owns VALUES ('Steinway St', '564563245342');
INSERT INTO Owns VALUES ('Broadway Ave', '478236176547');
INSERT INTO Owns VALUES ('Rogers Ave', '423245634324');
INSERT INTO Owns VALUES ('Meserole Ave', '546378671928');
INSERT INTO Owns VALUES ('Steinway St', '983647562543');
INSERT INTO Owns VALUES ('Bushwick Ave', '761235687683');
INSERT INTO Owns VALUES ('Meserole Ave', '983673465578');
INSERT INTO Owns VALUES ('Rogers Ave', '127836983482');
INSERT INTO Owns VALUES ('Broadway Ave', '786964534253');
INSERT INTO Owns VALUES ('Broadway Ave', '958564642239');
INSERT INTO Owns VALUES ('Bushwick Ave', '983735355987');
INSERT INTO Owns VALUES ('Steinway St', '798234548978');
INSERT INTO Owns VALUES ('Meserole Ave', '985454758653');
 
--Data to be inserted into BookDescription table
--Jessica JH3865
INSERT INTO BookDescription VALUES ('9780385333481', 'Kurt Vonnegut', 'Delacorte Press', 1963, 'Fiction');
INSERT INTO BookDescription VALUES ('9780451526342', 'George Orwell', 'Massmarket Paperback', 1996, 'Political Satire');
INSERT INTO BookDescription VALUES ('9780684804521', 'Ernest Hemingway', 'Scribner', 1995, 'Thriller');
INSERT INTO BookDescription VALUES ('9783869307916', 'Jim Dime', 'Alan Cristea Gallery', 2014, 'Art');
INSERT INTO BookDescription VALUES ('9781937027247', 'Gro Dahle', 'Ugly Duckling Presse', 2013, 'Poetry');
 
--Data to be inserted into BookCopy table
--Haydn HC698
INSERT INTO BookCopy VALUES ('786244744221', '9780385333481');
INSERT INTO BookCopy VALUES ('981769123582', '9780451526342');
INSERT INTO BookCopy VALUES ('676716987784', '9780684804521');
INSERT INTO BookCopy VALUES ('345983948752', '9783869307916');
INSERT INTO BookCopy VALUES ('329874982374', '9781937027247');
 
--Data to be inserted into AudioBookDescription table
--Haydn HC698
INSERT INTO AudioBookDescription VALUES ('9780060798062', 'Marianne Williamson', 'Harper Audio', 'Spiritual');
INSERT INTO AudioBookDescription VALUES ('9781565115392', 'Sue Monk Kidd', 'Penguin Audio','Fiction');
INSERT INTO AudioBookDescription VALUES ('9781094296029', 'H. G. Wells', 'JSX Publishing Inc', 'Mystery');
INSERT INTO AudioBookDescription VALUES ('9780221033841', 'Jon Krakauer', 'Cam Drynan', 'Thriller' );
INSERT INTO AudioBookDescription VALUES ('9780738900902', 'Shel Silverstein', 'Columbia/Legacy/Sony Wonder', 'Children');
 
--Data to be inserted into AudioBookCopy table
--Haydn HC698
INSERT INTO AudioBookCopy VALUES ('938474626372', '9780060798062');
INSERT INTO AudioBookCopy VALUES ('834967238874', '9781565115392');
INSERT INTO AudioBookCopy VALUES ('564563245342', '9781094296029');
INSERT INTO AudioBookCopy VALUES ('478236176547', '9780221033841');
INSERT INTO AudioBookCopy VALUES ('423245634324', '9780738900902');
 
--Data to be inserted into Movies table
--Shane SJR345
INSERT INTO Movies VALUES ('546378671928', 'Brian Helgeland', 2001, 'A Knights Tale');
INSERT INTO Movies VALUES ('983647562543', 'Cordin Hardy', 2018, 'The Nun');
INSERT INTO Movies VALUES ('761235687683', 'George Lucas', 1977, 'Episode IV A New Hope');
INSERT INTO Movies VALUES ('983673465578', 'Joss Whedon', 2012, 'The Avengers');
INSERT INTO Movies VALUES ('127836983482', 'Bong Joon-ho', 2020, 'Parasite');
 
--Data to be inserted into Music table
--Shane SJR345
INSERT INTO Music VALUES ('786964534253', 'Sour', 2020, 'CD', 'Pop');
INSERT INTO Music VALUES ('958564642239', 'Fearless', 2010, 'CD', 'Country');
INSERT INTO Music VALUES ('983735355987', 'Christmas Classics', 1999, 'CD', 'Holiday');
INSERT INTO Music VALUES ('798234548978', 'After Hours', 2015, 'CD', 'Rap');
INSERT INTO Music VALUES ('985454758653', 'Take Care', 2020, 'CD', 'Rap');


--FORMATS
SET PAGESIZE 100
SET LINESIZE 160

--Addressbook table formatting
COL AddressID FORMAT A11;
COL State FORMAT A6;
COL City FORMAT A12;

--ReadingRoom table formatting
COL LocationID FORMAT A12;
COL PhoneNumber FORMAT A11;

--Staff table formatting
COL StaffID FORMAT A7;
COL FirstName FORMAT A10;
COL LastName FORMAT A12;
COL Position FORMAT A20;

--Member table formatting
COL MemberID FORMAT A8;
COL SubscriptionDate FORMAT A16;

--Minor table formatting
COL GUARDIANNAME FORMAT A13;
COL GuardianPhone FORMAT A13;
COL GuardianEmail FORMAT A16;

--Adult table foramtting
COL DriversLicense FORMAT A14;
COL Email FORMAT A12;

--RentalCopy table formatting 
COL Status FORMAT A6;
COL Name FORMAT A25;

--Rents table formatting
COL Restriction FORMAT A11;

--Bookdescription table
COL ISBN FORMAT A13;
COL Author FORMAT A19;
COL Publisher FORMAT A27;
COL Year FORMAT 9999;
COL Genre FORMAT A16;

--Movies table formatting
COL Director FORMAT A15;
COL Year FORMAT 9999;
COL Title FORMAT A21;

--Music table formatting
COL format FORMAT A6;


-- Jessica's Queries 
-- 1. Show the title and barcode of all items checked out to Mateo Hill.
SELECT rc.name, r.barcode, m.firstname, m.lastname, rc.status
FROM Member m
JOIN Rents r
ON m.memberID=r.memberID
JOIN RentalCopy rc
ON r.barcode=rc.barcode
WHERE m.firstname='Mateo' AND m.lastname='Hill';

-- 2. Show the staff IDs, names, and positions of all staff who work in zip code 16180.
SELECT s.staffID, s.firstname, s.lastname, s.position, a.zip
FROM Staff s
JOIN ReadingRoom rr   
ON rr.locationID=s.locationID
JOIN addressBook a
ON rr.addressID=a.addressID    
WHERE a.zip='16180';

-- 3. Show the barcodes and titles of items that are overdue (due before 3/17/2022), and the memberID, first name, last name, and contact number of the adult members who have them checked out.
SELECT r.barcode, r.name, re.checkin AS DueDate, m.memberID, m.firstname, m.lastname, a.phonenumber
FROM RentalCopy r
JOIN Rents re
ON r.barcode=re.barcode
JOIN Member m
ON m.memberID=re.memberID
JOIN Adult a
ON a.memberID=m.memberID
WHERE re.checkin < '17-MAR-2022';

COL phonenumber FORMAT A11;

-- 4. For each book that is currently checked out, show the author of the book, and the name of the member to whom it is checked out.
SELECT re.memberid, m.firstname, m.lastname, r.name, b.author, r.status
FROM Member m
JOIN Rents re
ON m.memberID=re.memberID
JOIN RentalCopy r
ON re.barcode=r.barcode
JOIN BookCopy bc
ON r.barcode=bc.barcode
JOIN BookDescription b
ON bc.ISBN=b.ISBN
WHERE r.status='OUT';

COL memberid FORMAT A8;
COL firstname FORMAT A10;
COL lastname FORMAT A10;
COL status FORMAT A6;


-- Poojan's Queries 
-- 1. Show the phone number of the Reading Room locations where staff who live in Pennsylvania work.
SELECT rr.phonenumber, s.FirstName, s.LastName
FROM ReadingRoom rr
JOIN Staff s
ON rr.LocationID=s.LocationID
JOIN AddressBook a
ON s.AddressID=a.AddressID
WHERE a.state='PA';

COL PhoneNumber FORMAT A10;
COL FirstName FORMAT A10;
COL Lastname FORMAT A10;

-- 2. Show the names from rentalcopy whose restriction is Y.
SELECT rc.name, r.restriction
FROM RentalCopy rc
JOIN Rents r
ON rc.Barcode=r.Barcode
WHERE r.restriction='Y';

COL name FORMAT A24;
COL restriction FORMAT A10;

-- 3. Show the name and barcodes materials checked out by all members who live in PA, and the memberID, first name, and last name of the member who has them checked out.
SELECT r.name, r.barcode, r.status, m.memberID, m.firstname, m.lastname
FROM RentalCopy r
JOIN Rents re
ON r.barcode=re.barcode
JOIN Member m
ON m.memberID=re.memberID
JOIN AddressBook ab
ON m.AddressID=ab.AddressID
WHERE ab.state='NY' AND r.status='OUT';


-- Shane's Queries
-- 1. Show the name, year, and barcode of all movies and music released in the year 2020.
SELECT mv.Title, mv.Year, rc.Barcode, mc.Album, mc.Year
FROM rentalcopy rc
JOIN movies mv
ON rc.barcode=mv.barcode
JOIN music mc
ON mv.Year=mc.Year
WHERE mv.Year = '2020' AND mc.Year = '2020';

-- 2. Show all non-restricted items rented out to members.
SELECT rc.Name, rc.Status, rs.barcode, rs.Restriction, m.firstname, m.lastname
From Rents rs
JOIN RentalCopy rc
ON rc.barcode = rs.barcode
JOIN member m
ON m.memberid = rs.memberid
WHERE rc.Status='OUT' AND rs.Restriction='N';

-- 3. Show all movies checked out to members.
SELECT rc.Status, rc.name, ad.author
From RentalCopy rc
JOIN audiobookcopy ab
ON rc.barcode=ab.barcode
JOIN AudioBookDescription ad
ON ad.ISBN=ab.ISBN
WHERE rc.Status='OUT';


-- Ashleigh's Queries
-- 1. Display the first and last names determined by their memberID from the Rents table and their total counted rented items.
SELECT FirstName, LastName, count(*) InvCount
FROM member
JOIN rents
ON member.memberid = rents.memberid
GROUP BY member.MemberID, FirstName, LastName;

-- 2. List the members’ id, first name, last name and when they checkout an item and its assigned barcode. 
SELECT member.FirstName, member.LastName, member.MemberID, rents.CheckOut, rents.barcode
FROM Member
JOIN rents
ON member.memberid = rents.memberid
JOIN rentalcopy
ON rentalcopy.barcode = rents.barcode;

-- 3. The barcode of the rented item and the location of where the item is rented out from.
SELECT owns.barcode, locationID
FROM owns
JOIN rents
ON owns.barcode = rents.barcode
ORDER BY locationID;


--Haydn's Queries
-- 1.Display the minor members who has the state of NY record with their first name, last name, age, years of membership and their guardians' phone and email address
SELECT m.FirstName, m.LastName, FLOOR(((SYSDATE - m.BirthDate)/365)) AS Age,
FLOOR(((SYSDATE - m.SubscriptionDate)/365)) AS YearsofMembership, mi.GuardianEmail, mi.GuardianPhone
FROM AddressBook a JOIN Member m
ON a.addressID = m.addressID
JOIN Minor mi ON m.memberID = mi.memberID
WHERE a.state = 'NY'
ORDER BY m.LastName ASC;

col guardianEmail format a16;
col Guardianphone format a13;

-- 2. List the adult members who subscribe their membership at Rogers Ave with first name, last name, age, years of membership, and contact phone and email
SELECT m.FirstName, m.LastName, FLOOR (((SYSDATE - m.BirthDate)/365)) AS Age,
FLOOR(((SYSDATE-m.SubscriptionDate)/365)) AS YearsofMembership, ad.PhoneNumber,
ad.Email
FROM Member m, Adult ad
WHERE m.memberID = ad.memberID
AND LocationID = 'Rogers Ave'
ORDER BY Age DESC;

COL Email Format A15;

-- 3. Present the most active member who has the highest rental record with memberID, first name, last name, gender, age, years of membership, rent record 
SELECT * FROM (
   SELECT m.memberID, m.FirstName, m.LastName, m.Gender, FLOOR (((SYSDATE - m.BirthDate)/365)) AS Age,
   FLOOR(((SYSDATE - m.SubscriptionDate)/365)) AS YearsofMembership, Count(rts.Barcode) AS Rent_Record
   FROM Member m Join Rents rts
   ON m.memberID = rts.memberID
   Group BY m.memberID, m.FirstName, m.LastName, m.Gender, m.BirthDate, m.SubscriptionDate
   ORDER BY Rent_Record DESC
)
WHERE ROWNUM = 1;


-- Jessica's Data Manipulation
-- 1.Extend the check-in date to March 29th, 2022 for all items rented by memberID 12345
UPDATE Rents
SET CheckIn='29-MAR-2022'
WHERE MemberID='12345';

-- 2. Wendy’s Subway is weeding all music items from before 2012 to make room for new materials. Delete all music that was released prior to 2012.
DELETE FROM Music
WHERE Year < 2012;


-- Poojan's Data Manipulation
-- 1. Delete from BookDescription the publisher, Scribner
DELETE FROM BookDescription
WHERE Publisher='Scribner';

-- 2. Update music genre to rap where album is Sour.
UPDATE Music
SET Genre='Rap'
WHERE Album='Sour';


-- Shane's Data Manipulation
-- 1. A member lost our only copy of the Avengers.  Remove ‘The Avengers’ from the system.
DELETE FROM Movies
WHERE Title='The Avengers';

--2. Update gender to male for member, first name ‘Lily’ and last name ‘Jones’
UPDATE Member
SET Gender='Male'
WHERE FirstName='Lily' AND LastName='Jones';


-- Ashleigh's Data Manipulation
-- 1. Ashleigh quit Wendy's Library and her record needs to be deleted
DELETE FROM Staff
WHERE Firstname='Ashleigh';

-- 2. A minor's guardian phone was changed so that corresponding phone number needs to be updated.
UPDATE Minor
SET GuardianPhone='4563217869'
WHERE GuardianName='Matthew Sky';

-- Haydn's Data Manipulation
-- 1. Delete the music album: "After Hours" which genre is Rap from Music table
SELECT Album
FROM Music
WHERE Genre = 'Rap';

DELETE FROM Music
WHERE Album = 'After Hours'; 

-- 2. Update the location for barcode: 564563245342 to Meserole Ave in Owns table.
SELECT LocationID, Barcode
FROM Owns
WHERE Barcode = '564563245342';

UPDATE Owns
SET LocationID = 'Meserole Ave'
WHERE Barcode='564563245342';

--THE END! Thank you, have a great spring break.
