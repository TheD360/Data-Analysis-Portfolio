
-- This code drop an "EMP_1" if it exists in the database
DROP TABLE IF EXISTS EMP_1;


-- Q1
CREATE TABLE EMP_1 (
EMP_NUM CHAR(3) NOT NULL UNIQUE,
EMP_LNAME VARCHAR(15) NOT NULL,
EMP_FNAME VARCHAR(15) NOT NULL,
EMP_INITIAL CHAR(1),
EMP_HIREDATE DATE,
JOB_CODE CHAR(3),
PRIMARY KEY (EMP_NUM),
FOREIGN KEY (JOB_CODE) REFERENCES JOB);

-- Q2
-- I added more rows than was requested because that was the only way I could get the complete table to work on based off the questions asked.
INSERT INTO EMP_1
VALUES (101, 'NEWS', 'JOHN', 'G', '2000-11-08', '502');

INSERT INTO EMP_1
VALUES (102, 'SENIOR', 'DAVID', 'H', '1989-07-12', '501');

INSERT INTO EMP_1
VALUES (103, 'ARBOUGH', 'JUNE', 'E', '1996-12-01', '500');

INSERT INTO EMP_1
VALUES (104, 'RAMORAS', 'ANNE', 'K', '1987-11-15', '501');

INSERT INTO EMP_1
VALUES (105, 'JOHNSON', 'ALICE', 'K', '1993-02-01', '502');

INSERT INTO EMP_1
VALUES (106, 'SMITHFIELD', 'WILLIAM', ' ', '2004-06-22', '500');

INSERT INTO EMP_1
VALUES (107, 'ALONZO', 'MARIA', 'D', '1993-08-10', '500');

INSERT INTO EMP_1
VALUES (108, 'WASHINGTON', 'RALPH', 'B', '1991-08-22', '501');

INSERT INTO EMP_1
VALUES (109, 'SMITH', 'LARRY', 'W', '1997-07-18', '501');


SELECT * FROM EMP_1 -- To review the values inputted into the "EMP_1" table to ensure it was done correctly.


-- Q3
-- This changes the job code to 501 for the person whose employee number (EMP_NUM) is 107
UPDATE EMP_1
SET JOB_CODE = '501'
WHERE EMP_NUM = 107;


-- Q4
-- This CODE deletes the row for 'William Smithfield', who was hired on '2004-06-22' and whose  JOB_CODE is '500'
DELETE FROM EMP_1
WHERE EMP_LNAME = 'SMITHFIELD' 
AND EMP_FNAME = 'WILLIAM' 
AND EMP_HIREDATE = '2004-06-22' 
AND JOB_CODE = '500';


-- Q5
ALTER TABLE CUSTOMER
ADD CUST_DOB DATE;


-- Q6
UPDATE CUSTOMER
SET CUST_DOB = '1989-03-15'
WHERE CUS_CODE = 1000;


-- Q7
UPDATE CUSTOMER
SET CUST_DOB = '1988-12-22'
WHERE CUS_CODE = 1001;



