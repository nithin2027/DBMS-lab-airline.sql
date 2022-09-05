create database  MOVIE_82;
use MOVIE_82;

CREATE TABLE ACTOR(
ACTID INT,
ACTNAME VARCHAR(20),
ACTGENDER CHAR(1),
PRIMARY KEY (ACTID));

DESC ACTOR;

CREATE TABLE DIRECTOR(
DIRID INT,
DIRNAME VARCHAR(20),
DIRPHONE INT,
PRIMARY KEY (DIRID));

DESC DIRECTOR;

CREATE TABLE MOVIES(
MOVID INT,
MOVTITLE VARCHAR(25),
MOVYEAR INT,
MOVLANG VARCHAR(12),
DIRID INT,
PRIMARY KEY (MOVID),
FOREIGN KEY (DIRID) REFERENCES DIRECTOR(DIRID));

DESC MOVIES;

CREATE TABLE MOVIECAST(
ACTID INT,
MOVID INT,
ROLE VARCHAR(10),
PRIMARY KEY (ACTID,MOVID),
FOREIGN KEY (ACTID) REFERENCES ACTOR(ACTID),
FOREIGN KEY (MOVID) REFERENCES MOVIES(MOVID));

DESC MOVIECAST;

CREATE TABLE RATING(
MOVID INT,
REVSTARS VARCHAR(25),
PRIMARY KEY(MOVID),
FOREIGN KEY (MOVID) REFERENCES MOVIES(MOVID));

DESC RATING;

INSERT INTO ACTOR VALUES(301,'ANUSHKA','F');
INSERT INTO ACTOR VALUES(302,'PRABHAS','M');
INSERT INTO ACTOR VALUES(303,'PUNITH','M');
INSERT INTO ACTOR VALUES(304,'SUDEEP','M');

SELECT * FROM ACTOR;

INSERT INTO DIRECTOR VALUES(60,'RAJAMOULI',9191);
INSERT INTO DIRECTOR VALUES(61,'HITCHCOCK',8181);
INSERT INTO DIRECTOR VALUES(62,'FARAN',7171);
INSERT INTO DIRECTOR VALUES(63,'STEVEN SPIELBERG',6161);

SELECT * FROM DIRECTOR;

INSERT INTO MOVIES VALUES(1001,'BAHUBALI-2',2017,'TELUGU',60);
INSERT INTO MOVIES VALUES(1002,'BAHUBALI-1',2015,'TELUGU',60);
INSERT INTO MOVIES VALUES(1003,'AKASH',2008,'KANADA',61);
INSERT INTO MOVIES VALUES(1004,'WAR HORSE',2011,'ENGLISH',63);

SELECT * FROM MOVIES;

INSERT INTO MOVIECAST VALUES(301,1002,'HEROINE');
INSERT INTO MOVIECAST VALUES(301,1001,'HEROINE');
INSERT INTO MOVIECAST VALUES(303,1003,'HERO');
INSERT INTO MOVIECAST VALUES(303,1002,'GUEST');
INSERT INTO MOVIECAST VALUES(304,1004,'HERO');

SELECT * FROM MOVIECAST;

INSERT INTO RATING VALUES(1001,4);
INSERT INTO RATING VALUES(1002,2);
INSERT INTO RATING VALUES(1003,5);
INSERT INTO RATING VALUES(1004,4);

SELECT * FROM RATING;


SELECT MOVTITLE
FROM MOVIES
WHERE DIRID IN (SELECT DIRID
FROM DIRECTOR
WHERE DIRNAME='HITCHCOCK');

SELECT MOVTITLE
FROM MOVIES M,MOVIECAST MV
WHERE M.MOVID=MV.MOVID AND ACTID IN (SELECT ACTID
FROM MOVIECAST GROUP BY ACTID
HAVING COUNT(ACTID) > 1)
GROUP BY MOVTITLE
HAVING COUNT(*)>1;

SELECT ACTNAME,MOVTITLE,MOVYEAR
FROM ACTOR A
JOIN MOVIECAST C
ON A.ACTID=C.ACTID
JOIN MOVIES M
ON C.MOVID=M.MOVID
WHERE M.MOVYEAR NOT BETWEEN 2000 AND 2015;


SELECT A.ACTNAME,C.MOVTITLE,C.MOVYEAR
FROM ACTOR A,MOVIECAST B,MOVIES C
WHERE A.ACTID=B.ACTID
AND B.MOVID=C.MOVID
AND C.MOVYEAR NOT BETWEEN 2000 AND 2005;


SELECT MOVTITLE, MAX(REVSTARS)
FROM MOVIES
INNER JOIN RATING USING (MOVID)
GROUP BY MOVTITLE
HAVING MAX(REVSTARS)>0
ORDER BY MOVTITLE;


UPDATE RATING
SET REVSTARS=5
WHERE MOVID IN (SELECT MOVID FROM MOVIES
WHERE DIRID IN (SELECT DIRID
FROM DIRECTOR
WHERE DIRNAME='STEVEN SPIELBERG'));

SELECT * FROM RATING;
