-- 1. Print the names of professors who work in departments that have fewer than 50 PhD students.
SELECT P.pname
FROM prof P
JOIN dept D ON P.dname = D.dname
WHERE D.numphds < 50;

-- 2. Print the names of the students with the lowest GPA.
SELECT sname
FROM student
WHERE gpa = (SELECT MIN(gpa) FROM student);

-- 3. For each Computer Sciences class, print the class number, section number, and the average gpa of the students enrolled in the class section.
SELECT E.cno, E.sectno, AVG(E.grade) AS avg_gpa
FROM enroll E
JOIN course C ON E.cno = C.cno AND E.dname = C.dname
WHERE C.dname = 'Computer Sciences'
GROUP BY E.cno, E.sectno;

-- 4. Print the names and section numbers of all sections with more than six students enrolled in them.
SELECT S.cno, S.sectno
FROM section S
JOIN enroll E ON S.cno = E.cno AND S.dname = E.dname AND S.sectno = E.sectno
GROUP BY S.cno, S.sectno
HAVING COUNT(E.sid) > 6;

-- 5. Print the name(s) and sid(s) of the student(s) enrolled in the most sections.
WITH SSC AS (
    SELECT sid, COUNT(*) AS sec_cnt
    FROM enroll
    GROUP BY sid
),
MSC AS (
    SELECT MAX(sec_cnt) AS mx
    FROM SSC
)
SELECT S.sname, SSC.sid
FROM student S
JOIN SSC ON S.sid = SSC.sid
JOIN MSC ON SSC.sec_cnt = MSC.mx;


-- 6. Print the names of departments that have one or more majors who are under 18 years old.
SELECT DISTINCT D.dname
FROM dept D
JOIN major M ON D.dname = M.dname
JOIN student S ON M.sid = S.sid
WHERE S.age < 18;

-- 7. Print the names and majors of students who are taking one of the College Geometry courses.
SELECT S.sname, M.dname
FROM student S
JOIN major M ON S.sid = M.sid
JOIN enroll E ON S.sid = E.sid
JOIN course C ON E.cno = C.cno AND E.dname = C.dname
WHERE C.cname LIKE 'College Geometry%';

-- 8. For those departments that have no major taking a College Geometry course print the department name and the number of PhD students in the department.
WITH GCS AS (
    SELECT DISTINCT C.dname
    FROM course C
    WHERE C.cname LIKE 'College Geometry%'
),
DWG AS (
   SELECT dname FROM dept
   EXCEPT
   SELECT dname FROM GCS
)
SELECT D.dname, D.numphds
FROM dept D
JOIN DWG ON D.dname = DWG.dname;


-- 9. Print the names of students who are taking both a Computer Sciences course and a Mathematics course.
WITH CSS AS (
    SELECT DISTINCT E.sid
    FROM enroll E
    JOIN course C ON E.cno = C.cno AND E.dname = C.dname
    WHERE C.dname = 'Computer Sciences'
),
MS AS (
    SELECT DISTINCT E.sid
    FROM enroll E
    JOIN course C ON E.cno = C.cno AND E.dname = C.dname
    WHERE C.dname = 'Mathematics'
)
SELECT S.sname
FROM student S
JOIN CSS ON S.sid = CSS.sid
JOIN MS ON S.sid = MS.sid;


-- 10. Print the age difference between the oldest and the youngest Computer Sciences major.
WITH CSAD AS (
    SELECT S.age
    FROM student S
    JOIN major M ON S.sid = M.sid
    WHERE M.dname = 'Computer Sciences'
)
SELECT MAX(age) - MIN(age) AS age_diff
FROM CSAD;

-- 11. For each department that has one or more majors with a GPA under 1.0, print the name of the department and the average GPA of its majors.
WITH LGPA AS (
    SELECT M.dname, S.gpa
    FROM major M
    JOIN student S ON M.sid = S.sid
    WHERE S.gpa < 1.0
)
SELECT U.dname, AVG(U.gpa) AS avg_gpa
FROM LGPA U
GROUP BY U.dname;

-- 12. Print the ids, names and GPAs of the students who are currently taking all the Civil Engineering courses.
WITH CESD AS (
    SELECT C.cno, C.dname
    FROM course C
    WHERE C.dname = 'Civil Engineering'
),
SCC AS (
    SELECT E.sid
    FROM enroll E
    JOIN CESD ON E.cno = CESD.cno AND E.dname = CESD.dname
    GROUP BY E.sid
    HAVING COUNT(*) = (SELECT COUNT(*) FROM CESD)
)
SELECT S.sid, S.sname, S.gpa
FROM student S
JOIN SCC ON S.sid = SCC.sid;
