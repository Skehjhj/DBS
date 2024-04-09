CREATE TABLE Course (
  CourseID  CHAR(6)      PRIMARY KEY,
  Name      VARCHAR(255),
  Howtomark     VARCHAR(255),
  Credit     INTEGER,
  SemesterID        INTEGER,
  CONSTRAINT   fk_course_semester_SemesterID   FOREIGN KEY
                            (SemesterID) REFERENCES Semester (SemesterID),
  Prerequisites CHAR(6) REFERENCES Course (CourseID),
  MinAttendance  INTEGER
);
ALTER TABLE Course
ALTER COLUMN Prerequisites VCHAR(6) NULL;


insert into Course (CourseID, Name, Howtomark, Credit, Prerequisites, MinAttendance) values ('CSC101', 'Introduction to Psychology', 'NASDAQ', 1, NULL, 72);
insert into Course (CourseID, Name, Howtomark, Credit, Prerequisites, MinAttendance) values ('MTH200', 'Advanced Calculus', 'NYSE', 1, NULL, 70);
insert into Course (CourseID, Name, Howtomark, Credit, Prerequisites, MinAttendance) values ('ENG101', 'Digital Marketing Strategies', 'NASDAQ', 4, NULL, 8);
insert into Course (CourseID, Name, Howtomark, Credit, Prerequisites, MinAttendance) values ('ART150', 'History of Ancient Civilizations', 'NYSE', 2, NULL, 29);
insert into Course (CourseID, Name, Howtomark, Credit, Prerequisites, MinAttendance) values ('HIS300', 'Creative Writing Workshop', 'NASDAQ', 3, 'ART150', 42);
insert into Course (CourseID, Name, Howtomark, Credit, Prerequisites, MinAttendance) values ('PHY201', 'Photography Basics', 'NYSE', 3, NULL, 95);
insert into Course (CourseID, Name, Howtomark, Credit, Prerequisites, MinAttendance) values ('PSY250', 'Nutrition and Wellness', 'NYSE', 4, 'PHYS201', 97);
insert into Course (CourseID, Name, Howtomark, Credit, Prerequisites, MinAttendance) values ('CHE110', 'Music Theory Fundamentals', 'NYSE', 4, NULL, 53);
insert into Course (CourseID, Name, Howtomark, Credit, Prerequisites, MinAttendance) values ('SOC101', 'Business Ethics', 'NYSE', 4, 'ENG101', 45)
insert into Course (CourseID, Name, Howtomark, Credit, Prerequisites, MinAttendance) values ('BUS300', 'Introduction to Computer Science', 'NYSE', 2, 'SOC101', 35);