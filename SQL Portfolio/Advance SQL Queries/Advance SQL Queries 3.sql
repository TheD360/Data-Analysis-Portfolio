-- In this project I explore more advance SQL querying techniques such as JOINS, sub-querying, nested queries, use of aggregate functions/operations in combination with 
-- other SQL querying techniques to achieve remarkable results using SQL.
-- The Database I am querying for this project is the same as the one I created for 'Advance SQL Queries 1' 'DiveShop'.
-- I have also included the ERD in this folder to make it easy to access because it is very pivotal to successfully performing most of the queries in this project


-- Q1- List the names and addresses of all participants who have registered for more than two tours.
SELECT PART_FNAME + ' ' + PART_LNAME AS PART_NAME, PART_CITY + ', ' + PART_STATE AS PART_ADDRESS
FROM PARTICIPANT P 
INNER JOIN PARTRES PR ON P.PART_ID = PR.PART_ID 
INNER JOIN RESERVATION R ON PR.RES_ID = R.RES_ID
GROUP BY PART_FNAME, PART_LNAME, PART_CITY, PART_STATE
HAVING COUNT(DISTINCT R.TOUR_ID) > 2;


-- Q2- List the date and departure time for all tours that go to the 'Golden X' wreck.   Use a subquery.
SELECT TOUR_DATE, TOUR_DEPARTURETIME 
FROM TOUR 
WHERE TOUR.SITE_ID = (SELECT SITE_ID FROM SITE WHERE SITE_NAME LIKE '%Golden X%');


-- Q3- For each reservation, list the reservation date, the tour date, the participant cost (Res_PartCost) and the gear cost (Res_GearCost).
SELECT RES_ID, RES_DATE, T.TOUR_DATE, RES_PARTCOST, RES_GEARCOST 
FROM RESERVATION R INNER JOIN TOUR T ON R.TOUR_ID = T.TOUR_ID 
GROUP BY RES_ID, RES_DATE, T.TOUR_DATE, RES_PARTCOST, RES_GEARCOST;


-- Q4- List all tours scheduled for July, 2012 and the date of all reservations for that tour. Include all tours, including those without any reservations.
SELECT T.TOUR_ID, T.TOUR_DATE, R.RES_DATE
FROM TOUR T
LEFT JOIN RESERVATION R ON T.TOUR_ID = R.TOUR_ID
WHERE T.TOUR_DATE LIKE '2012-07%'
ORDER BY T.TOUR_ID, R.RES_DATE


-- Q5- List the departure date and time for all tours whose participants are NOT from Nebraska (state code = NE). Use a NOT EXISTS construct.
SELECT TOUR_DATE, TOUR_DEPARTURETIME 
FROM TOUR T
WHERE NOT EXISTS (
	SELECT TOUR_ID
	FROM PARTICIPANT P
	INNER JOIN PARTRES PR ON P.PART_ID = PR.PART_ID 
	INNER JOIN RESERVATION R ON PR.RES_ID = R.RES_ID
	WHERE R.TOUR_ID = T.TOUR_ID 
	AND P.PART_STATE = 'NE'
	);


-- Q6- For each tour departing on 24-jul-2012, list the site name, the skill level, and the name of the boat to be used.
SELECT SITE_NAME, SITE_SKILLLEVEL, B.BOAT_NAME
FROM TOUR T 
	INNER JOIN SITE S  ON T.SITE_ID = S.SITE_ID 
	INNER JOIN BOAT B ON T.BOAT_ID = B.BOAT_ID
WHERE EXISTS (
	SELECT SITE_NAME 
	FROM SITE S
	WHERE TOUR_DATE = '2012-07-24'
	);


--Q7- List the boats that have been used on tours to all sites at 100 ft. or greater depth.  
-- (If a boat has been used on tours to just one or two of the three sites, it should not appear in the output.)
SELECT B.BOAT_ID, B.BOAT_NAME FROM BOAT B
INNER JOIN TOUR T ON B.BOAT_ID = T.BOAT_ID
INNER JOIN SITE S ON T.SITE_ID = S.SITE_ID
WHERE S.SITE_DEPTH >= 100
GROUP BY B.BOAT_ID, B.BOAT_NAME
HAVING COUNT(DISTINCT S.SITE_ID) = (SELECT COUNT(*) FROM SITE WHERE SITE_DEPTH >= 100)

--Q8- Create a view that shows for each site and date the number of tours to that site on that date. **
CREATE VIEW TOURED_SITES AS
SELECT S.SITE_ID, S.SITE_NAME, T.TOUR_DATE,
COUNT(T.TOUR_ID) AS TOUR_COUNT  FROM TOUR T
INNER JOIN SITE S ON T.SITE_ID = S.SITE_ID
GROUP BY S.SITE_ID, S.SITE_NAME, T.TOUR_DATE;


--Q9- For each participant who has been on a tour in July 2012, list the name of the participant and the site visited. 
-- List the name of participants and sites visited since 2012-07
SELECT PART_FNAME + ' ' + PART_LNAME AS PART_NAME, S.SITE_NAME 
FROM PARTICIPANT P 
INNER JOIN PARTRES PR ON P.PART_ID = PR.PART_ID 
INNER JOIN RESERVATION R ON PR.RES_ID = R.RES_ID 
INNER JOIN TOUR T ON R.TOUR_ID = T.TOUR_ID 
INNER JOIN SITE S ON T.SITE_ID = S.SITE_ID
WHERE T.TOUR_DATE LIKE '2012-07%'


--Q10- For each site, list the sites at the same skill level that have lower base cost. **
--The output should be (site 1, cost 1, site 2, cost 2, skill level) where cost 1 < cost 2.
SELECT 
    A.SITE_NAME AS Site1, A.SITE_BASECOST AS Cost1,
    B.SITE_NAME AS Site2, B.SITE_BASECOST AS Cost2,
    A.SITE_SKILLLEVEL AS SkillLevel
FROM SITE A
INNER JOIN SITE B ON A.SITE_SKILLLEVEL = B.SITE_SKILLLEVEL
WHERE A.SITE_BASECOST < B.SITE_BASECOST;


--Q11- Calculate the total cost (participant cost + gear cost) for each reservation. If there is no value for the gear cost, 
-- the total cost should be equal to the participant cost (in this case). Do not alter the data in the tables.
SELECT 
	RES_ID, RES_PARTCOST + COALESCE(RES_GEARCOST, 0) AS [TOTAL COST] 
FROM RESERVATION;


--Q12- List the departure date and site name  of tours that either have more than seven participants or have a total of more than $230.
--In reservation participant cost. Use a UNION construct.

-- Here, this code finds departure date and site name of tours that have more than seven participants
SELECT T.TOUR_DATE AS DEPARTUREDATE, S.SITE_NAME FROM TOUR T
INNER JOIN SITE S ON T.SITE_ID = S.SITE_ID
INNER JOIN RESERVATION R ON T.TOUR_ID = R.TOUR_ID
INNER JOIN PARTRES PR ON R.Res_ID = PR.Res_ID
INNER JOIN PARTICIPANT P ON PR.PART_ID = P.PART_ID
GROUP BY T.TOUR_DATE, S.SITE_NAME
HAVING COUNT(PR.PART_ID) > 7

UNION

-- Here, this code finds departure date and site name of tours that have more than 230 in reservation participant cost 
-- and the 'UNION' clause joins them but removes or prevents duplicates.

SELECT T.TOUR_DATE, S.SITE_NAME FROM TOUR T
INNER JOIN SITE S ON T.SITE_ID = S.SITE_ID
INNER JOIN RESERVATION R ON T.TOUR_ID = R.TOUR_ID
GROUP BY T.TOUR_DATE, S.SITE_NAME
HAVING SUM(R.RES_PARTCOST) > 230;


--Q13- List the names and capacity of all boats that have been used on tours to a site in the 'Giant Kelp Forests'. Use a nested subquery.
SELECT BOAT_NAME, BOAT_CAPACITY 
FROM BOAT B 
WHERE EXISTS (
    SELECT 1
    FROM TOUR T 
    INNER JOIN SITE S ON T.SITE_ID = S.SITE_ID 
    WHERE S.SITE_AREA = 'Giant Kelp Forests' 
    AND B.BOAT_ID = T.BOAT_ID
);


--Q14- List the name of each site, the base cost, and a description of the cost.  If the cost is < $25, the cost is 'inexpensive'.  
-- If the cost is $25-40, the cost is 'moderate'.  If the cost is > 40, the cost is 'expensive'.
SELECT SITE_NAME, 
		SITE_BASECOST,
CASE 
WHEN SITE_BASECOST < 25 THEN 'inexpensive'
WHEN SITE_BASECOST >= 25 AND SITE_BASECOST <= 40 THEN 'moderate'
WHEN SITE_BASECOST > 40 THEN 'expensive'

END [COST DESCRIPTION]
FROM SITE;


--Q15- For each boat, list the boat name, and the tour_id, date and departure time of the most recent tour to use that boat.
-- There are four boats after the join clause has been executed the most recent time each of the boat has been used for TOUR are...
SELECT 
    B.BOAT_NAME,
    T.TOUR_ID,
    T.TOUR_DATE,
    T.TOUR_DEPARTURETIME
FROM 
    BOAT B
INNER JOIN 
    TOUR T ON B.BOAT_ID = T.BOAT_ID
WHERE 
    T.TOUR_DATE = (
        SELECT MAX(T.TOUR_DATE)
        FROM TOUR T
        WHERE T.BOAT_ID = B.BOAT_ID
    );


--Q16- List all pairs of dive sites that are at the same depth. The result should contain three columns <first site, second site, depth> such that <first site> 
--and <second site> have the same depth. A given pair should appear only once in the output.
-- To achieve this use a SELF JOIN on the SITE table.
SELECT 
    A.SITE_NAME AS FirstSite,
    B.SITE_NAME AS SecondSite,
    A.SITE_DEPTH AS Depth
FROM 
    SITE A
INNER JOIN 
    SITE B ON A.SITE_DEPTH = B.SITE_DEPTH AND A.SITE_ID < B.SITE_ID;


--Q17- List the name of each participant who has made a reservation on a tour to a site at over 95ft depth. 
-- Include in the output the name of the site and its depth.
SELECT 
    P.PART_FNAME + ' ' + P.PART_LNAME AS PART_NAME,
    S.SITE_NAME,
    S.SITE_DEPTH
FROM 
    PARTICIPANT P
INNER JOIN 
    PARTRES PR ON P.PART_ID = PR.PART_ID
INNER JOIN 
    RESERVATION R ON PR.RES_ID = R.RES_ID
INNER JOIN 
    TOUR T ON R.TOUR_ID = T.TOUR_ID
INNER JOIN 
    SITE S ON T.SITE_ID = S.SITE_ID
WHERE 
    S.SITE_DEPTH > 95;


--18- List the site, departure date, and boat name for each tour to a site in 'Wreck Alley'. 
-- Include all tours, including those that have not yet been assigned a boat.
-- To include all tours from the TOUR table regardless of whether they have been assigned a boat or not I used a LEFT JOIN clause.
SELECT 
    S.SITE_NAME,
    T.TOUR_DATE,
    COALESCE(B.BOAT_NAME, 'Not Assigned') AS BoatName
FROM 
    TOUR T
LEFT JOIN 
    SITE S ON T.SITE_ID = S.SITE_ID
LEFT JOIN 
    BOAT B ON T.BOAT_ID = B.BOAT_ID
WHERE 
    S.SITE_AREA = 'Wreck Alley';


--19- List the names of all participants who have registered for a tour to the 'Golden X' wreck.  Use a nested subquery for this question.
SELECT 
    P.PART_FNAME + ' ' + P.PART_LNAME AS PART_NAME
FROM 
    PARTICIPANT P
WHERE 
    P.PART_ID IN (
        SELECT DISTINCT PR.PART_ID
        FROM PARTRES PR
        JOIN RESERVATION R ON PR.RES_ID = R.RES_ID
        JOIN TOUR T ON R.TOUR_ID = T.TOUR_ID
        JOIN SITE S ON T.SITE_ID = S.SITE_ID
        WHERE S.SITE_NAME = 'Golden X'
    );


--20- List the names of sites visited by more than two large tours.  A large tour is defined as a tour with more than 10 participants.  
-- Include in the output the number of large tours.
SELECT S.SITE_NAME, COUNT(DISTINCT T.TOUR_ID) AS LARGETOUR
FROM SITE S
INNER JOIN TOUR T ON S.SITE_ID = T.SITE_ID
INNER JOIN RESERVATION R ON T.TOUR_ID = R.TOUR_ID
INNER JOIN PARTRES PR ON R.RES_ID = PR.RES_ID
GROUP BY S.SITE_NAME
HAVING COUNT(DISTINCT PR.PART_ID) > 10
AND COUNT(DISTINCT T.TOUR_ID) > 2;
