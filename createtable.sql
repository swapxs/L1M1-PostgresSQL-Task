-- Table 1: dept
CREATE TABLE dept (
    dname VARCHAR(100) PRIMARY KEY,
    numphds INT
);

-- Table 2: prof
CREATE TABLE prof (
    pname VARCHAR(100) PRIMARY KEY,
    dname VARCHAR(100),
    FOREIGN KEY (dname) REFERENCES dept(dname)
);

-- Table 3: course
CREATE TABLE course (
    cno INT,
    cname VARCHAR(100),
    dname VARCHAR(100),
    PRIMARY KEY (cno, dname),
    FOREIGN KEY (dname) REFERENCES dept(dname)
);

-- Table 4: student
CREATE TABLE student (
    sid INT PRIMARY KEY,
    sname VARCHAR(100),
    sex CHAR(1),
    age INT,
    year INT,
    gpa NUMERIC(3, 2)
);

-- Table 5: major
CREATE TABLE major (
    dname VARCHAR(100),
    sid INT,
    PRIMARY KEY (dname, sid),
    FOREIGN KEY (dname) REFERENCES dept(dname),
    FOREIGN KEY (sid) REFERENCES student(sid)
);

-- Table 6: section
CREATE TABLE section (
    dname VARCHAR(100),
    cno INT,
    sectno INT,
    pname VARCHAR(100),
    PRIMARY KEY (dname, cno, sectno),
    FOREIGN KEY (dname) REFERENCES dept(dname),
    FOREIGN KEY (cno, dname) REFERENCES course(cno, dname),
    FOREIGN KEY (pname) REFERENCES prof(pname)
);

-- Table 7: enroll
CREATE TABLE enroll (
    sid INT,
    dname VARCHAR(100),
    cno INT,
    sectno INT,
    grade NUMERIC(3, 2),
    PRIMARY KEY (sid, dname, cno, sectno),
    FOREIGN KEY (sid) REFERENCES student(sid),
    FOREIGN KEY (dname, cno, sectno) REFERENCES section(dname, cno, sectno)
);

