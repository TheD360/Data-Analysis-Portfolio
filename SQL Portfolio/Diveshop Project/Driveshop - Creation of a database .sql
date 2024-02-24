-- IN THIS SCRIPT I CREATE A MINI-DATABASE AND FILL IT WITH VALUES
-- IN THE NEXT SCRIPT I QUERY THIS DATABASE AND PERFORM VARIOUS BASIC SQL QUERIES ON IT.

DROP TABLE IF EXISTS PARTRES;
DROP TABLE IF EXISTS PARTICIPANT;
DROP TABLE IF EXISTS RESERVATION;
DROP TABLE IF EXISTS TOUR;
DROP TABLE IF EXISTS BOAT;
DROP TABLE IF EXISTS SITE;

CREATE TABLE site (
	Site_ID   	INTEGER,
	Site_Name  	VARCHAR(50) NOT NULL,
	Site_Depth  	INTEGER,
	Site_SkillLevel VARCHAR(50),
	Site_Visibility VARCHAR(50),
	Site_Current 	VARCHAR(50),
	Site_Notes 	VARCHAR(255),
	Site_BaseCost 	NUMERIC(9,2),
	Site_Interest  	VARCHAR(50),
	Site_Area  	VARCHAR(100),
	Site_Type 	VARCHAR(100),
	CONSTRAINT site_pk PRIMARY KEY (Site_ID)
	);

CREATE TABLE boat (
	Boat_ID 	INTEGER,
	Boat_Name 	VARCHAR(50) NOT NULL,
	Boat_Type 	VARCHAR(100),
	Boat_Length 	INTEGER,
	Boat_Speed 	INTEGER,
	Boat_Capacity 	INTEGER,
	Boat_Year 	INTEGER,
	CONSTRAINT boat_pk PRIMARY KEY (Boat_ID)
);


CREATE TABLE tour (
	Tour_ID   	INTEGER,
	Tour_Date  	DATE NOT NULL,
	Tour_DepartureTime  VARCHAR(10),
	Site_ID   	INTEGER NOT NULL,
	Boat_ID  	INTEGER,
	CONSTRAINT tour_pk PRIMARY KEY (Tour_ID),
	CONSTRAINT tour_site_id_fk FOREIGN KEY (Site_ID) REFERENCES site
);

CREATE TABLE participant (
     	Part_ID         INTEGER,
     	Part_Fname     	VARCHAR(50) NOT NULL,
     	Part_Lname     	VARCHAR(100) NOT NULL,
     	Part_Title     	VARCHAR(100),
     	Part_City      	VARCHAR(50),
     	Part_State    	CHAR(2),
     	CONSTRAINT participant_pk PRIMARY KEY (Part_ID)
     	);

CREATE TABLE reservation (
   	Res_ID     	INTEGER,
   	Res_Date   	DATE NOT NULL,
   	Res_Tanks   	INTEGER,
   	Res_PartCost   	NUMERIC(9,2),
   	Res_GearCost   	NUMERIC(9,2),
   	Tour_ID   	INTEGER NOT NULL,
   	CONSTRAINT reservation_pk PRIMARY KEY (Res_ID),
        CONSTRAINT reservation_tour_id_fk FOREIGN KEY (Tour_ID) REFERENCES TOUR
      	);


CREATE TABLE partres (
	Res_ID   	INTEGER,
	Part_ID  	INTEGER,
	CONSTRAINT partres_pk PRIMARY KEY (Res_ID, Part_ID),
	CONSTRAINT Res_ID_fk FOREIGN KEY (Res_ID) REFERENCES reservation, 
	CONSTRAINT Part_ID_fk FOREIGN KEY (Part_ID) REFERENCES participant
	);


-- SITE table

INSERT INTO site (site_id, site_name, site_depth, site_skillLevel, site_visibility, site_current, site_notes, site_baseCost, site_interest, site_area, site_type)  
VALUES ( 1, 'La Paloma', 40, 'Novice', 150, 'Mild', 'The La Paloma kelp forest is one of the largest, with kelp dozens of feet in length creating a home for exotic plants and sea animals.', 25, 'Other', 'Giant Kelp Forests', 'Other');

INSERT INTO site (site_id, site_name, site_depth, site_skillLevel, site_visibility, site_current, site_notes, site_baseCost, site_interest, site_area, site_type)  
VALUES ( 2, 'La Jolla', 50, 'Novice', 100, 'Mild', 'The La Jolla kelp forest is best known for the many species of colorful fish.', 25, 'Fish', 'Giant Kelp Forests', 'Other');

INSERT INTO site (site_id, site_name, site_depth, site_skillLevel, site_visibility, site_current, site_notes, site_baseCost, site_interest, site_area, site_type)  
VALUES ( 3, 'HMCS Alberta', 150, 'Experienced', 150, 'Strong', 'Lies at a 90 degree angle Port side down.  Complete penetration of the ship is possible.', 40, 'Fixture', 'Wreck Alley', 'Shipwreck');

INSERT INTO site (site_id, site_name, site_depth, site_skillLevel, site_visibility, site_current, site_notes, site_baseCost, site_interest, site_area, site_type)  
VALUES ( 4, 'Golden X', 150, 'Experienced', 100, 'Strong', 'This 1985 wreck is completely covered by strawberry anemones, making it appear like a float in a parade.', 30, 'Machinery', 'Wreck Alley', 'Shipwreck');

INSERT INTO site (site_id, site_name, site_depth, site_skillLevel, site_visibility, site_current, site_notes, site_baseCost, site_interest, site_area, site_type)  
VALUES ( 5, 'Magdelina', 90, 'Intermediate', 175, 'Mild', 'When the Magdelina sank, an heiress, her entourage, and a considerable number of diamonds sank to the ocean floor.', 40, 'Treasure', 'Wreck Alley', 'Shipwreck');

INSERT INTO site (site_id, site_name, site_depth, site_skillLevel, site_visibility, site_current, site_notes, site_baseCost, site_interest, site_area, site_type)  
VALUES ( 6, 'OIL', 60, 'Novice', 150, 'Mild', 'A permanent fixture, this oceanographic lab sank during a storm.  It is now home to a wide array of sea creatures.', 30, 'Fixture', 'Wreck Alley', 'Shipwreck');

INSERT INTO site (site_id, site_name, site_depth, site_skillLevel, site_visibility, site_current, site_notes, site_baseCost, site_interest, site_area, site_type)  
VALUES ( 7, 'Civil Construction', 50, 'Novice', 60, 'None', 'This site contains old pilings, pieces of roadways, and other junk from civil construction projects.  It is, however, home to a breathtaking collection of sea life.', 20, 'Marine Life', 'Wreck Alley', 'Shipwreck');

INSERT INTO site (site_id, site_name, site_depth, site_skillLevel, site_visibility, site_current, site_notes, site_baseCost, site_interest, site_area, site_type)  
VALUES ( 8, 'Santa Rosa', 100, 'Experienced', 20, 'Mild', 'The Santa Rosa Caves were only discovered within the last 15 years.  Bring your diving lights.', 40, 'Caves', 'Cozumel Reef', 'Other');

INSERT INTO site (site_id, site_name, site_depth, site_skillLevel, site_visibility, site_current, site_notes, site_baseCost, site_interest, site_area, site_type)  
VALUES ( 9, 'Punta Arenas Reef', 50, 'Novice', 150, 'None', 'The Punta Arenas Reef is home to many animal species, including anemones, mollusks, crabs, seastars, and numerous species of fish.', 30, 'Marine Life', 'Cozumel Reef', 'Other');

INSERT INTO site (site_id, site_name, site_depth, site_skillLevel, site_visibility, site_current, site_notes, site_baseCost, site_interest, site_area, site_type)  
VALUES ( 10, 'Punta Tunich Reef', 80, 'Intermediate', 100, 'Strong', 'The Punta Tunich Reef has some of the finest examples of  Brain Coral, Staghorn Coral, Lettuce Coral, and Ivory Bush Coral', 30, 'Coral', 'Cozumel Reef', 'Other');

-- BOAT table
INSERT INTO boat  (boat_id, boat_name, boat_type, boat_length, boat_speed, boat_capacity, boat_year)  
VALUES ( 1, 'El Capitan', 'Custom Modutech Dive Boat', 32, 10, 18, 1995);

INSERT INTO boat  (boat_id, boat_name, boat_type, boat_length, boat_speed, boat_capacity, boat_year)  
VALUES ( 2, 'Donni-Marie', 'Coast Guard certified dive boat', 36, 20, 24, 2000);

INSERT INTO boat  (boat_id, boat_name, boat_type, boat_length, boat_speed, boat_capacity, boat_year)  
VALUES ( 3, 'El Astuto', 'Gulfcraft Coast Guard certified dive boat', 65, 14, 32, null);

INSERT INTO boat  (boat_id, boat_name, boat_type, boat_length, boat_speed, boat_capacity, boat_year)  
VALUES ( 4, 'La Rosa', 'Gulfcraft Coast Guard certified dive boat', 40, 12, 20, 2004);

-- TOUR table

Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (1,convert (date,'23-JUL-12',6),'8:30 AM',4,3);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (2,convert (date,'24-JUL-12',6),'8:30 AM',8,3);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (3,convert (date,'24-JUL-12',6),'10:30 AM',2,2);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (4,convert (date,'25-JUL-12',6),'8:30 AM',5,null);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (5,convert (date,'28-JUL-12',6),'9:00 AM',10,3);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (6,convert (date,'28-JUL-12',6),'9:00 AM',7,2);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (7,convert (date,'29-JUL-12',6),'9:00 AM',3,2);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (8,convert (date,'30-JUL-12',6),'9:00 AM',5,3);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (9,convert (date,'31-JUL-12',6),'9:00 AM',6,3);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (10,convert (date,'28-JUL-12',6),'10:30 AM',2,1);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (11,convert (date,'24-JUL-13',6),'9:00 AM',7,null);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (12,convert (date,'24-JUL-13',6),'9:00 AM',4,2);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (13,convert (date,'24-JUL-13',6),'9:00 AM',3,3);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (14,convert (date,'25-JUL-13',6),'9:00 AM',5,null);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (15,convert (date,'25-JUL-13',6),'9:00 AM',6,null);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (16,convert (date,'26-JUL-13',6),'9:00 AM',9,null);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (17,convert (date,'26-JUL-13',6),'9:00 AM',2,null);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (18,convert (date,'26-JUL-13',6),'9:00 AM',10,null);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (19,convert (date,'27-JUL-13',6),'10:30 AM',2,null);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (20,convert (date,'26-JUL-13',6),'12 NOON',10,null);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (21,convert (date,'28-JUL-13',6),'9:00 AM',1,null);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (22,convert (date,'28-JUL-12',6),'3:00 PM',7,2);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (23,convert (date,'02-AUG-12',6),'9:00 AM',1,2);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (24,convert (date,'03-AUG-12',6),'10:00 AM',8,2);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (25,convert (date,'14-JUL-14',6),'9:00 AM',4,4);
Insert into TOUR (TOUR_ID,TOUR_DATE,TOUR_DEPARTURETIME,SITE_ID,BOAT_ID) values (26,convert (date,'17-AUG-12',6),'10:00 AM',8,2);



-- RESERVATION table

Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (1,convert (date,'15-MAR-12',6),2,150,194,1);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (2,convert (date,'24-FEB-12',6),2,135,73,3);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (3,convert (date,'20-MAR-12',6),3,120,35,5);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (4,convert (date,'15-APR-12',6),2,120,null,6);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (5,convert (date,'15-APR-12',6),3,140,40,7);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (6,convert (date,'13-APR-13',6),3,140,25,14);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (7,convert (date,'13-JAN-13',6),3,240,null,15);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (8,convert (date,'10-JAN-13',6),3,0,null,14);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (9,convert (date,'15-MAY-12',6),3,280,94,7);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (10,convert (date,'20-JUN-12',6),2,120,56,7);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (11,convert (date,'15-MAR-12',6),3,50,5,22);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (12,convert (date,'01-JUL-12',6),2,225,80,3);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (13,convert (date,'15-JUN-12',6),1,175,40,3);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (14,convert (date,'12-APR-12',6),3,110,null,3);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (15,convert (date,'10-JAN-13',6),2,180,20,17);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (16,convert (date,'08-NOV-12',6),3,275,104,17);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (17,convert (date,'04-DEC-12',6),3,220,39,17);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (18,convert (date,'14-MAY-12',6),3,330,40,10);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (19,convert (date,'02-JUN-12',6),2,225,62,10);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (20,convert (date,'23-JUN-12',6),3,385,null,23);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (21,convert (date,'23-APR-12',6),2,225,50,23);
Insert into RESERVATION (RES_ID,RES_DATE,RES_TANKS,RES_PARTCOST,RES_GEARCOST,TOUR_ID) values (22,convert (date,'23-APR-12',6),0,100,null,6);



-- PARTICIPANT table

INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 4, 'Janet', 'Moralez', null, 'New York', 'NY');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 5, 'Philip', 'Moralez', null, 'New York', 'NY');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 6, 'Cassie', 'Moralez', null, 'New York', 'NY');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 7, 'Jack', 'Santee', '', 'Omaha', 'NE');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 8, 'Jessica', 'Santee', null, 'Omaha', 'NE');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 9, 'Lawson D.', 'Woods', 'Scout Leader', 'Boca Raton', 'FL');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 10, 'Joaquin', 'Matilda', 'Australian Tour Guide', 'Tampa Bay', 'FL');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 11, 'Menachem', 'Down', 'Bowling coach', 'Worchester', 'MA');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 12, 'Jillian', 'Here', 'Climate Change Monitor', 'Bangor', 'ME');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 13, 'Dustin', 'Dubree', 'Construction Manager', 'Freemont', 'NE');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 14, 'Max', 'Stout', 'Credit Counselor', 'Omaha', 'NE');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 15, 'Lauren', 'Order', 'Criminal Justice Expert', 'Omaha', 'NE');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 16, 'Andy', 'Zoff', 'Race Car Driver', 'Gloucester', 'MA');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 17, 'U.B.', 'Crawlin', 'Traffic Reporter', 'Atlanta', 'GA');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 18, 'Joaquin', 'Closet', 'Wardrobe Assistant', 'Durham', 'SC');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 19, 'Natalie', 'Drest', 'Wardrobe Consultant', 'Freemont', 'NE');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 20, 'Deepak', 'Tumuch', 'Excursion Planner', 'Portsmouth', 'NH');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 21, 'Alexis', 'Itznot', 'Used Car Salesman', 'Durham', 'SC');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 22, 'Diana', 'Bordum', 'Transcriber', 'Lincoln', 'NE');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 23, 'Opal', 'Lease', 'Telephone Complaint Representative', 'Roanoke', 'VA');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 24, 'Lou', 'Pole', 'Tax Consultant', 'Santa Fe', 'NM');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 25, 'Cal', 'Abunga', 'Surf Reporter', 'Portsmouth', 'NH');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 26, 'Gladys', 'Overnow', 'Summer Intern', 'Tampa Bay', 'FL');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 27, 'Marge', 'Innovera', 'Statistician', 'Roanoke', 'VA');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 28, 'Joaquin', 'DePark', 'Urban Health Coordinator', 'Sacramento', 'CA');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 29, 'Mo', 'Mentum', 'Physicist', 'Lincoln', 'NE');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 30, 'Ivan', 'Inkling', 'Innovator', 'Bangor', 'ME');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 31, 'Neera', 'Nuff', 'Background Checker', 'Ames', 'IA');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 32, 'Obie', 'Quiet', 'Counselor', 'Sacramento', 'CA');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 33, 'Luke', 'Bizzy', 'Shop Foreman', 'Grand Island', 'NE');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 34, 'Howard E.', 'Oysters', 'Seafood Salesman', 'Grand Island', 'NE');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 35, 'Pikop', 'Andropov', 'Chauffeur', 'San Francisco', 'CA');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 36, 'Chet', 'Propelled', 'Rocket Scientist', 'Sioux Falls', 'SD');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 37, 'Willy', 'Bolt', 'Parole Officer', 'Grand Island', 'NE');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 38, 'Don B.', 'Zonozzi', 'Press Secretary', 'Albuquerque', 'NM');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 39, 'Zbignew', 'Rigg', 'Truck Salesman', 'Albuquerque', 'NM');
INSERT INTO participant  (part_id, part_fname, part_lname, part_title, part_city, part_state)  
VALUES ( 40, 'Farida', 'Wales', 'Environmentalist', 'Grand Forks', 'ND');

-- PARTRES table

INSERT INTO partres  (res_id, part_id)  VALUES ( 1, 9);
INSERT INTO partres  (res_id, part_id)  VALUES ( 1, 14);
INSERT INTO partres  (res_id, part_id)  VALUES ( 1, 15);
INSERT INTO partres  (res_id, part_id)  VALUES ( 2, 4);
INSERT INTO partres  (res_id, part_id)  VALUES ( 2, 5);
INSERT INTO partres  (res_id, part_id)  VALUES ( 2, 6);
INSERT INTO partres  (res_id, part_id)  VALUES ( 3, 7);
INSERT INTO partres  (res_id, part_id)  VALUES ( 3, 8);
INSERT INTO partres  (res_id, part_id)  VALUES ( 4, 9);
INSERT INTO partres  (res_id, part_id)  VALUES ( 4, 12);
INSERT INTO partres  (res_id, part_id)  VALUES ( 4, 13);
INSERT INTO partres  (res_id, part_id)  VALUES ( 5, 9);
INSERT INTO partres  (res_id, part_id)  VALUES ( 5, 10);
INSERT INTO partres  (res_id, part_id)  VALUES ( 5, 11);
INSERT INTO partres  (res_id, part_id)  VALUES ( 6, 6);
INSERT INTO partres  (res_id, part_id)  VALUES ( 6, 9);
INSERT INTO partres  (res_id, part_id)  VALUES ( 6, 15);
INSERT INTO partres  (res_id, part_id)  VALUES ( 7, 9);
INSERT INTO partres  (res_id, part_id)  VALUES ( 7, 12);
INSERT INTO partres  (res_id, part_id)  VALUES ( 7, 14);
INSERT INTO partres  (res_id, part_id)  VALUES ( 7, 16);
INSERT INTO partres  (res_id, part_id)  VALUES ( 8, 4);
INSERT INTO partres  (res_id, part_id)  VALUES ( 8, 10);
INSERT INTO partres  (res_id, part_id)  VALUES ( 8, 12);
INSERT INTO partres  (res_id, part_id)  VALUES ( 8, 13);
INSERT INTO partres  (res_id, part_id)  VALUES ( 9, 4);
INSERT INTO partres  (res_id, part_id)  VALUES ( 9, 5);
INSERT INTO partres  (res_id, part_id)  VALUES ( 9, 7);
INSERT INTO partres  (res_id, part_id)  VALUES ( 9, 13);
INSERT INTO partres  (res_id, part_id)  VALUES ( 10, 12);
INSERT INTO partres  (res_id, part_id)  VALUES ( 10, 14);
INSERT INTO partres  (res_id, part_id)  VALUES ( 11, 11);
INSERT INTO partres  (res_id, part_id)  VALUES ( 12, 17);
INSERT INTO partres  (res_id, part_id)  VALUES ( 12, 19);
INSERT INTO partres  (res_id, part_id)  VALUES ( 12, 28);
INSERT INTO partres  (res_id, part_id)  VALUES ( 12, 35);
INSERT INTO partres  (res_id, part_id)  VALUES ( 12, 37);
INSERT INTO partres  (res_id, part_id)  VALUES ( 13, 12);
INSERT INTO partres  (res_id, part_id)  VALUES ( 13, 22);
INSERT INTO partres  (res_id, part_id)  VALUES ( 13, 23);
INSERT INTO partres  (res_id, part_id)  VALUES ( 13, 26);
INSERT INTO partres  (res_id, part_id)  VALUES ( 13, 27);
INSERT INTO partres  (res_id, part_id)  VALUES ( 14, 7);
INSERT INTO partres  (res_id, part_id)  VALUES ( 14, 8);
INSERT INTO partres  (res_id, part_id)  VALUES ( 15, 13);
INSERT INTO partres  (res_id, part_id)  VALUES ( 15, 21);
INSERT INTO partres  (res_id, part_id)  VALUES ( 15, 25);
INSERT INTO partres  (res_id, part_id)  VALUES ( 15, 35);
INSERT INTO partres  (res_id, part_id)  VALUES ( 16, 16);
INSERT INTO partres  (res_id, part_id)  VALUES ( 16, 17);
INSERT INTO partres  (res_id, part_id)  VALUES ( 16, 18);
INSERT INTO partres  (res_id, part_id)  VALUES ( 16, 29);
INSERT INTO partres  (res_id, part_id)  VALUES ( 16, 33);
INSERT INTO partres  (res_id, part_id)  VALUES ( 17, 4);
INSERT INTO partres  (res_id, part_id)  VALUES ( 17, 5);
INSERT INTO partres  (res_id, part_id)  VALUES ( 17, 6);
INSERT INTO partres  (res_id, part_id)  VALUES ( 17, 34);
INSERT INTO partres  (res_id, part_id)  VALUES ( 18, 9);
INSERT INTO partres  (res_id, part_id)  VALUES ( 18, 12);
INSERT INTO partres  (res_id, part_id)  VALUES ( 18, 21);
INSERT INTO partres  (res_id, part_id)  VALUES ( 18, 26);
INSERT INTO partres  (res_id, part_id)  VALUES ( 18, 30);
INSERT INTO partres  (res_id, part_id)  VALUES ( 18, 37);
INSERT INTO partres  (res_id, part_id)  VALUES ( 19, 14);
INSERT INTO partres  (res_id, part_id)  VALUES ( 19, 20);
INSERT INTO partres  (res_id, part_id)  VALUES ( 19, 22);
INSERT INTO partres  (res_id, part_id)  VALUES ( 19, 31);
INSERT INTO partres  (res_id, part_id)  VALUES ( 19, 36);
INSERT INTO partres  (res_id, part_id)  VALUES ( 20, 15);
INSERT INTO partres  (res_id, part_id)  VALUES ( 20, 17);
INSERT INTO partres  (res_id, part_id)  VALUES ( 20, 22);
INSERT INTO partres  (res_id, part_id)  VALUES ( 20, 23);
INSERT INTO partres  (res_id, part_id)  VALUES ( 20, 26);
INSERT INTO partres  (res_id, part_id)  VALUES ( 20, 28);
INSERT INTO partres  (res_id, part_id)  VALUES ( 20, 33);
INSERT INTO partres  (res_id, part_id)  VALUES ( 21, 4);
INSERT INTO partres  (res_id, part_id)  VALUES ( 21, 6);
INSERT INTO partres  (res_id, part_id)  VALUES ( 21, 8);
INSERT INTO partres  (res_id, part_id)  VALUES ( 21, 21);
INSERT INTO partres  (res_id, part_id)  VALUES ( 21, 26);
INSERT INTO partres  (res_id, part_id)  VALUES ( 22, 5);
INSERT INTO partres  (res_id, part_id)  VALUES ( 22, 6);
INSERT INTO partres  (res_id, part_id)  VALUES ( 22, 13);
INSERT INTO partres  (res_id, part_id)  VALUES ( 22, 15);
INSERT INTO partres  (res_id, part_id)  VALUES ( 22, 20);






