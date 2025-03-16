-- 1. Table "Chei" (Keys)
-- Keys have IDs from 1 to 30 and initial availability (validity) as 1 (true).
CREATE TABLE Chei (
    key_id NUMBER PRIMARY KEY,
    validity NUMBER(1) DEFAULT 1  -- 1 = available, 0 = unavailable
);

-- Insert keys from 1 to 30
BEGIN
  FOR i IN 1..30 LOOP
    INSERT INTO Chei (key_id) VALUES (i);
  END LOOP;
  COMMIT;
END;
/

------------------------------------------------------------

-- 2. Table "Profesori" (Professors)
-- Contains professor information, including a password field for login.
CREATE TABLE Profesori (
    profesor_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    prenume VARCHAR2(50) NOT NULL,
    nume VARCHAR2(50) NOT NULL,
    telefon VARCHAR2(20),
    email VARCHAR2(100),
    password VARCHAR2(100) NOT NULL  -- Password for login
);

-- Insert example professors (with example passwords)
INSERT INTO Profesori (prenume, nume, telefon, email, password)
VALUES ('Adrian', 'Spataru', '0744123456', 'adrian.spataru@example.com', 'passAdrian123');

INSERT INTO Profesori (prenume, nume, telefon, email, password)
VALUES ('Mihai', 'Popescu', '0744234567', 'mihai.popescu@example.com', 'passMihai123');

INSERT INTO Profesori (prenume, nume, telefon, email, password)
VALUES ('Ioana', 'Ionescu', '0744345678', 'ioana.ionescu@example.com', 'passIoana123');

INSERT INTO Profesori (prenume, nume, telefon, email, password)
VALUES ('Elena', 'Marinescu', '0744456789', 'elena.marinescu@example.com', 'passElena123');

INSERT INTO Profesori (prenume, nume, telefon, email, password)
VALUES ('Andrei', 'Georgescu', '0744567890', 'andrei.georgescu@example.com', 'passAndrei123');

COMMIT;

------------------------------------------------------------

-- 3. Table "AcademicSchedule" (Unique Schedule for each Professor)
-- This table stores the schedule of lectures/seminars for each professor.
CREATE TABLE AcademicSchedule (
    schedule_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    profesor_id NUMBER NOT NULL,
    subject VARCHAR2(100) NOT NULL,         -- e.g., 'Mathematics', 'Computer Science', etc.
    event_type VARCHAR2(50) NOT NULL,         -- e.g., 'Lecture' or 'Seminar'
    time_interval VARCHAR2(50) NOT NULL,      -- e.g., '08:00-10:00'
    key_id NUMBER,                           -- reference to table Chei
    key_taken NUMBER(1) DEFAULT 0,            -- 0 = no, 1 = yes
    CONSTRAINT fk_profesor FOREIGN KEY (profesor_id) REFERENCES Profesori(profesor_id),
    CONSTRAINT fk_chei FOREIGN KEY (key_id) REFERENCES Chei(key_id)
);

-- Insert example schedule entries for each professor

-- For Professor 1: Adrian Spataru
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (1, 'Mathematics', 'Lecture', '08:00-10:00', 5, 1);
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (1, 'Computer Science', 'Seminar', '10:15-12:15', 8, 0);
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (1, 'Calculus', 'Lecture', '13:00-15:00', 11, 1);
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (1, 'Programming Fundamentals', 'Lecture', '15:15-17:15', 6, 0);

-- For Professor 2: Mihai Popescu
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (2, 'Methods and Practices for Computer Science', 'Lecture', '09:00-11:00', 3, 1);
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (2, 'Programming', 'Seminar', '11:15-13:15', 7, 0);
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (2, 'Algorithms and Data Structures', 'Lecture', '14:00-16:00', 10, 1);

-- For Professor 3: Ioana Ionescu
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (3, 'Algorithms and Data Structures', 'Lecture', '14:00-16:00', 12, 1);
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (3, 'Computational Geometry', 'Seminar', '16:15-18:15', 20, 0);
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (3, 'Discrete Mathematics', 'Lecture', '08:30-10:30', 9, 1);

-- For Professor 4: Elena Marinescu
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (4, 'Computer Science', 'Lecture', '08:30-10:30', 2, 1);
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (4, 'Programming', 'Seminar', '10:45-12:45', 9, 0);
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (4, 'Calculus', 'Lecture', '13:00-15:00', 13, 1);

-- For Professor 5: Andrei Georgescu
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (5, 'Mathematics', 'Lecture', '09:30-11:30', 4, 1);
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (5, 'Algorithms and Data Structures', 'Seminar', '11:45-13:45', 6, 0);
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (5, 'Calculus', 'Lecture', '14:00-16:00', 14, 1);
INSERT INTO AcademicSchedule (profesor_id, subject, event_type, time_interval, key_id, key_taken)
VALUES (5, 'Computational Geometry', 'Lecture', '16:15-18:15', 15, 0);

COMMIT;

------------------------------------------------------------

-- 4. Table "CheiAsignate" (Key Assignments / Check-in Register)
-- This table is updated continuously: when a professor checks in,
-- a record is added with the professor, the key, the check-in time and the active status.
CREATE TABLE CheiAsignate (
    assignment_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    profesor_id NUMBER NOT NULL,
    key_id NUMBER NOT NULL,
    checkin_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR2(20) DEFAULT 'active',  -- e.g., 'active', 'transferred', 'returned'
    CONSTRAINT fk_asig_prof FOREIGN KEY (profesor_id) REFERENCES Profesori(profesor_id),
    CONSTRAINT fk_asig_chei FOREIGN KEY (key_id) REFERENCES Chei(key_id)
);

-- Insert example records in CheiAsignate
INSERT INTO CheiAsignate (profesor_id, key_id, status)
VALUES (1, 5, 'active');
INSERT INTO CheiAsignate (profesor_id, key_id, status)
VALUES (2, 3, 'active');
INSERT INTO CheiAsignate (profesor_id, key_id, status)
VALUES (3, 12, 'returned');
INSERT INTO CheiAsignate (profesor_id, key_id, status)
VALUES (4, 2, 'active');
INSERT INTO CheiAsignate (profesor_id, key_id, status)
VALUES (5, 4, 'active');

COMMIT;
