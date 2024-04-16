CREATE DATABASE lms;
use lms;


SET DATEFORMAT dmy;
CREATE      TABLE       UserTable (
  userID    CHAR(9)   PRIMARY KEY,
  mail      VARCHAR(255),
  name      VARCHAR(255),
  DoB       DATE,
  sex       VARCHAR(10),
  password  VARCHAR(10,)
);


ALTER TABLE UserTable
ADD CONSTRAINT CK_Sex
CHECK (sex IN ('Male', 'Female'));


CREATE TABLE Message(
    MessageID INTEGER PRIMARY KEY,
    Content VARCHAR(255),
    SenderID CHAR(9),
    CONSTRAINT fk_sender_user_SenderID FOREIGN KEY (SenderID) REFERENCES UserTable (userID),
);

CREATE TABLE Receiver(
  ReceiverID CHAR(9),
  CONSTRAINT fk_receiver_user_ReceiverID FOREIGN KEY (ReceiverID) REFERENCES UserTable (userID),
  MessageID INTEGER,
  CONSTRAINT fk_receiver_message_MessageID FOREIGN KEY (MessageID) REFERENCES Message (MessageID),
  ReceiveTime DATE
)

CREATE      TABLE       Professor (
  ProfID    CHAR(9)    PRIMARY KEY,
  CONSTRAINT   fk_prof_user_ProfID   FOREIGN KEY
                            (ProfID) REFERENCES UserTable (userID),
  Degree      VARCHAR(255),
);

CREATE      TABLE       Student (
  StuID    CHAR(9)     PRIMARY KEY,
  CONSTRAINT   fk_stu_user_StuID   FOREIGN KEY
                            (StuID) REFERENCES UserTable (userID),
  DateJoin     DATE,
  Program      VARCHAR(255),
  Major        VARCHAR(255),
);

CREATE TABLE Semester(
    SemesterID INTEGER PRIMARY KEY,
    StartDate DATE,
    EndDate DATE,
);

CREATE      TABLE       Course (
  CourseID  CHAR(10)     PRIMARY KEY,
  Name      VARCHAR(255),
  Credit     INTEGER,
  Prerequisites CHAR(10) NULL  REFERENCES Course (CourseID),
);

CREATE TABLE MarkColumns(
  CourseID  CHAR(10),
  Column INTEGER,
  PRIMARY KEY (CourseID, Column),
  Percentage INTEGER,
);

CREATE      TABLE      Class (
  ClassID    INTEGER     PRIMARY KEY,
  SemesterID INTEGER,
  CONSTRAINT fk_class_semester_SemesterID FOREIGN KEY (SemesterID) REFERENCES Semester (SemesterID),
  Classroom  CHAR(3),
  CourseID  CHAR(10),
  CONSTRAINT  fk_class_course_CourseID FOREIGN KEY (CourseID) REFERENCES Course (CourseID),
  ProfID    CHAR(9),
  CONSTRAINT   fk_class_prof_ProfID   FOREIGN KEY
                            (ProfID) REFERENCES Professor (ProfID),
  Class_size INTEGER
);

CREATE TABLE Document(
  DocID INTEGER PRIMARY KEY,
  DocName VARCHAR(255),
  DocType VARCHAR(255),
  Docpath VARCHAR(255),
  ClassID    INTEGER,
  CONSTRAINT fk_document_class_ClassID FOREIGN KEY (ClassID) REFERENCES Class (ClassID),
  Author VARCHAR(255),
);

--?---

CREATE TABLE TestBank(
  TestID INTEGER PRIMARY KEY,
  Context VARCHAR(255),
  Answer VARCHAR(255),
);

CREATE TABLE StuWork(
  StuID CHAR(9) REFERENCES Student (StuID),
  TestID INTEGER REFERENCES TestBank (TestID),
  TimesID INTEGER,
  PRIMARY KEY (StuID, TestID, TimesID),
  StuWork VARCHAR(255),
  DoTime TIME,
  DoneTime DATE,
  Score INTEGER
);

CREATE TABLE Test(
    TestID INTEGER PRIMARY KEY,
    CONSTRAINT fk_test_testbank_TestID FOREIGN KEY (TestID) REFERENCES TestBank (TestID),
    ClassID  INTEGER,
    CONSTRAINT fk_test_class_ClassID FOREIGN KEY
                            (ClassID) REFERENCES Class (ClassID),
    Deadline DATE,
    Test_name VARCHAR(255),
);


--- Continues ---

CREATE TABLE Study(
    StuID CHAR(9) REFERENCES Student (StuID),
    ClassID INTEGER REFERENCES Class (ClassID),
    CONSTRAINT pk_study PRIMARY KEY (StuID, ClassID),
    Arg_Score INTEGER,
);

UPDATE Class
SET Class_size = (
  SELECT COUNT(StuID)
  FROM Study
  WHERE Study.ClassID = Class.ClassID
);

CREATE OR REPLACE FUNCTION update_avg_score()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Study
    SET Arg_Score = (SELECT AVG(sw.Score)
                     FROM StuWork sw
                     WHERE sw.StuID = NEW.StuID AND sw.ClassID = NEW.ClassID)
    WHERE StuID = NEW.StuID AND ClassID = NEW.ClassID;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_avg_score_trigger
AFTER INSERT OR UPDATE OR DELETE ON StuWork
FOR EACH ROW
EXECUTE FUNCTION update_avg_score();

insert into UserTable (userID, mail, name, DoB, sex) values ('GV01', 'lbaldick0@hcmut.edu.vn', 'Libbie Baldick', '28-08-2003', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV02', 'dhartegan1@hcmut.edu.vn', 'Devy Hartegan', '17-12-2004', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV03', 'vpurkis2@hcmut.edu.vn', 'Vinny Purkis', '28-03-2003', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV04', 'jjozefczak3@hcmut.edu.vn', 'Janos Jozefczak', '26-11-2002', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV05', 'nrichichi4@hcmut.edu.vn', 'Nina Richichi', '29-08-2004', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV06', 'pbleakman5@hcmut.edu.vn', 'Pearce Bleakman', '23-09-2002', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV07', 'ffilisov6@hcmut.edu.vn', 'Florian Filisov', '30-10-2002', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV08', 'egrelik7@hcmut.edu.vn', 'Esra Grelik', '22-11-2000', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV09', 'jadriano8@hcmut.edu.vn', 'Joshuah Adriano', '27-01-2002', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV10', 'jmattityahou9@hcmut.edu.vn', 'Jemmy Mattityahou', '31-03-2005', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV01', 'pwelbrocka@hcmut.edu.vn', 'Pierette Welbrock', '06-07-2001', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV02', 'bsaltmanb@hcmut.edu.vn', 'Belicia Saltman', '23-01-2001', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV03', 'celcomec@hcmut.edu.vn', 'Carlynne Elcome', '29-05-2003', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV04', 'icorbend@hcmut.edu.vn', 'Irene Corben', '04-03-2001', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV05', 'alivzeye@hcmut.edu.vn', 'Augy Livzey', '13-02-2003', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV06', 'lzeplinf@hcmut.edu.vn', 'Lucien Zeplin', '11-01-2001', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV07', 'bloggg@hcmut.edu.vn', 'Bryant Logg', '24-10-2000', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV08', 'olampardh@hcmut.edu.vn', 'Oberon Lampard', '16-02-2001', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV09', 'rroxburghi@hcmut.edu.vn', 'Rinaldo Roxburgh', '11-10-2003', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV10', 'abusainj@hcmut.edu.vn', 'Amandy Busain', '17-07-2000', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV11', 'rbeavisk@hcmut.edu.vn', 'Rosa Beavis', '19-01-2004', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV12', 'aspurierl@hcmut.edu.vn', 'Aubrey Spurier', '23-06-2001', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV13', 'alovelockm@hcmut.edu.vn', 'Alina Lovelock', '08-07-2003', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV14', 'abowatern@hcmut.edu.vn', 'Axe Bowater', '06-09-2003', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV15', 'vciceroneo@hcmut.edu.vn', 'Virgilio Cicerone', '05-10-2002', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV16', 'kperrinp@hcmut.edu.vn', 'Karina Perrin', '13-11-2002', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV17', 'dleakeq@hcmut.edu.vn', 'Deny Leake', '28-03-2002', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV18', 'croycroftr@hcmut.edu.vn', 'Corbie Roycroft', '28-01-2003', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV19', 'mennalss@hcmut.edu.vn', 'Maurits Ennals', '20-06-2002', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV20', 'sfochst@hcmut.edu.vn', 'Salomo Fochs', '20-12-2003', 'Male');

insert into Message (MessageID, Content, SenderID) values (1, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'GV02');
insert into Message (MessageID, Content, SenderID) values (2, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'SV13');
insert into Message (MessageID, Content, SenderID) values (3, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'SV07');
insert into Message (MessageID, Content, SenderID) values (4, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 'GV06');
insert into Message (MessageID, Content, SenderID) values (5, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'SV16');
insert into Message (MessageID, Content, SenderID) values (6, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 'SV04');
insert into Message (MessageID, Content, SenderID) values (7, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'SV05');
insert into Message (MessageID, Content, SenderID) values (8, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'SV01');
insert into Message (MessageID, Content, SenderID) values (9, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 'GV07');
insert into Message (MessageID, Content, SenderID) values (10, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'GV08');

insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV10', 4, '21-08-2023');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('GV02', 2, '02-04-2024');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('GV10', 8, '20-09-2023');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('GV08', 10, '19-01-2024');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV09', 7, '03-09-2023');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV04', 5, '09-11-2023');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV15', 5, '30-04-2023');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('GV10', 7, '14-01-2024');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV14', 2, '01-03-2024');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('GV09', 2, '19-02-2024');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV14', 7, '03-01-2024');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV19', 7, '24-03-2024');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV11', 4, '24-07-2023');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('GV09', 8, '28-11-2023');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV03', 3, '28-10-2023');

insert into Professor (ProfID, Degree) values ('GV01', 'M.S.');
insert into Professor (ProfID, Degree) values ('GV02', 'M.S.');
insert into Professor (ProfID, Degree) values ('GV03', 'Ph.D');
insert into Professor (ProfID, Degree) values ('GV04', 'Ph.D');
insert into Professor (ProfID, Degree) values ('GV05', 'Bachelor');
insert into Professor (ProfID, Degree) values ('GV06', 'M.S.');
insert into Professor (ProfID, Degree) values ('GV07', 'Bachelor');
insert into Professor (ProfID, Degree) values ('GV08', 'M.S.');
insert into Professor (ProfID, Degree) values ('GV09', 'M.S.');
insert into Professor (ProfID, Degree) values ('GV10', 'M.S.');

insert into Student (StuID, StuStatus, Major) values ('SV01', 'Graduated', 'Biology');
insert into Student (StuID, StuStatus, Major) values ('SV02', 'On Leave', 'Psychology');
insert into Student (StuID, StuStatus, Major) values ('SV03', 'Active', 'English Literature');
insert into Student (StuID, StuStatus, Major) values ('SV04', 'Active', 'Mathematics');
insert into Student (StuID, StuStatus, Major) values ('SV05', 'Suspended', 'Art History');
insert into Student (StuID, StuStatus, Major) values ('SV06', 'On Leave', 'English Literature');
insert into Student (StuID, StuStatus, Major) values ('SV07', 'Active', 'Mathematics');
insert into Student (StuID, StuStatus, Major) values ('SV08', 'Active', 'Business Administration');
insert into Student (StuID, StuStatus, Major) values ('SV09', 'Active', 'Biology');
insert into Student (StuID, StuStatus, Major) values ('SV10', 'Active', 'History');
insert into Student (StuID, StuStatus, Major) values ('SV11', 'Active', 'Sociology');
insert into Student (StuID, StuStatus, Major) values ('SV12', 'On Leave', 'English Literature');
insert into Student (StuID, StuStatus, Major) values ('SV13', 'Active', 'Sociology');
insert into Student (StuID, StuStatus, Major) values ('SV14', 'On Leave', 'Business Administration');
insert into Student (StuID, StuStatus, Major) values ('SV15', 'Graduated', 'Mathematics');
insert into Student (StuID, StuStatus, Major) values ('SV16', 'Suspended', 'English Literature');
insert into Student (StuID, StuStatus, Major) values ('SV17', 'Active', 'Biology');
insert into Student (StuID, StuStatus, Major) values ('SV18', 'Active', 'Computer Science');
insert into Student (StuID, StuStatus, Major) values ('SV19', 'On Leave', 'Mathematics');
insert into Student (StuID, StuStatus, Major) values ('SV20', 'Active', 'Biology');

insert into Semester (SemesterID, StartDate, EndDate) values (191, '05-09-2019', '31-12-2019');
insert into Semester (SemesterID, StartDate, EndDate) values (192, '01-01-2020', '21-06-2020');
insert into Semester (SemesterID, StartDate, EndDate) values (193, '22-06-2020', '02-09-2020');
insert into Semester (SemesterID, StartDate, EndDate) values (201, '05-09-2020', '31-12-2020');
insert into Semester (SemesterID, StartDate, EndDate) values (202, '01-01-2021', '21-06-2021');
insert into Semester (SemesterID, StartDate, EndDate) values (203, '22-06-2021', '02-09-2021');
insert into Semester (SemesterID, StartDate, EndDate) values (211, '05-09-2011', '31-12-2011');
insert into Semester (SemesterID, StartDate, EndDate) values (212, '01-01-2022', '21-06-2022');
insert into Semester (SemesterID, StartDate, EndDate) values (213, '22-06-2022', '02-09-2022');
insert into Semester (SemesterID, StartDate, EndDate) values (221, '05-09-2022', '31-12-2022');
insert into Semester (SemesterID, StartDate, EndDate) values (222, '01-01-2023', '21-06-2023');
insert into Semester (SemesterID, StartDate, EndDate) values (223, '22-06-2023', '02-09-2023');

INSERT INTO Course (CourseID, Name, Howtomark, Credit, SemesterID, Prerequisites, MinAttendance) VALUES (N'ART606', N'Photography Basics', N'NYSE', 2, 203, null, 35);
INSERT INTO Course (CourseID, Name, Howtomark, Credit, SemesterID, Prerequisites, MinAttendance) VALUES (N'ENG303', N'Digital Marketing Strategies', N'NASDAQ', 4, 193, null, 64);
INSERT INTO Course (CourseID, Name, Howtomark, Credit, SemesterID, Prerequisites, MinAttendance) VALUES (N'MAT202', N'Advanced Calculus', N'NASDAQ', 3, 192, null, 33);
INSERT INTO Course (CourseID, Name, Howtomark, Credit, SemesterID, Prerequisites, MinAttendance) VALUES (N'PHI808', N'Music Theory Fundamentals', N'NYSE', 3, 212, null, 75);
INSERT INTO Course (CourseID, Name, Howtomark, Credit, SemesterID, Prerequisites, MinAttendance) VALUES (N'BUS707', N'Nutrition and Wellness', N'NASDAQ', 4, 211, N'PHI808', 1);
INSERT INTO Course (CourseID, Name, Howtomark, Credit, SemesterID, Prerequisites, MinAttendance) VALUES (N'CSE101', N'Introduction to Psychology', N'NASDAQ', 1, 191, N'MAT202', 25);
INSERT INTO Course (CourseID, Name, Howtomark, Credit, SemesterID, Prerequisites, MinAttendance) VALUES (N'CHE101', N'Business Ethics', N'NASDAQ', 1, 221, N'CSE101', 75);
INSERT INTO Course (CourseID, Name, Howtomark, Credit, SemesterID, Prerequisites, MinAttendance) VALUES (N'SCI505', N'History of Ancient Civilizations', N'NASDAQ', 1, 202, N'ART606', 15);
INSERT INTO Course (CourseID, Name, Howtomark, Credit, SemesterID, Prerequisites, MinAttendance) VALUES (N'HIS404', N'Creative Writing Workshop', N'NYSE', 2, 201, N'SCI505', 48);
INSERT INTO Course (CourseID, Name, Howtomark, Credit, SemesterID, Prerequisites, MinAttendance) VALUES (N'MUS909', N'Introduction to Computer Science', N'NASDAQ', 4, 213, N'CHE101', 56);

insert into Class (ClassID, Classroom, Capacity, CourseID, ProfID) values (1, 'L01', 66, 'MUS909', 'GV04');
insert into Class (ClassID, Classroom, Capacity, CourseID, ProfID) values (2, 'C02', 44, 'ART606', 'GV02');
insert into Class (ClassID, Classroom, Capacity, CourseID, ProfID) values (3, 'J03', 45, 'ART606', 'GV06');
insert into Class (ClassID, Classroom, Capacity, CourseID, ProfID) values (4, 'L04', 88, 'ART606', 'GV05');
insert into Class (ClassID, Classroom, Capacity, CourseID, ProfID) values (5, 'C05', 92, 'PHI808', 'GV03');
insert into Class (ClassID, Classroom, Capacity, CourseID, ProfID) values (6, 'J01', 61, 'BUS707', 'GV10');
insert into Class (ClassID, Classroom, Capacity, CourseID, ProfID) values (7, 'L02', 35, 'SCI505', 'GV04');
insert into Class (ClassID, Classroom, Capacity, CourseID, ProfID) values (8, 'C03', 26, 'BUS707', 'GV06');
insert into Class (ClassID, Classroom, Capacity, CourseID, ProfID) values (9, 'J04', 30, 'CSE101', 'GV10');
insert into Class (ClassID, Classroom, Capacity, CourseID, ProfID) values (10, 'L05', 76, 'BUS707', 'GV02');
insert into Class (ClassID, Classroom, Capacity, CourseID, ProfID) values (11, 'L03', 49, 'MAT202', 'GV08');
insert into Class (ClassID, Classroom, Capacity, CourseID, ProfID) values (12, 'C04', 39, 'CHE101', 'GV05');
insert into Class (ClassID, Classroom, Capacity, CourseID, ProfID) values (13, 'J05', 32, 'MAT202', 'GV02');
insert into Class (ClassID, Classroom, Capacity, CourseID, ProfID) values (14, 'L01', 65, 'MUS909', 'GV01');
insert into Class (ClassID, Classroom, Capacity, CourseID, ProfID) values (15, 'C02', 74, 'BUS707', 'GV10');

INSERT INTO Teach (ProfID, CourseID)
SELECT DISTINCT ProfID, CourseID
FROM Class;

insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (1, 1, 1, 'Essay Exam', '12-02-2024 04:32:29', '24-08-2023', 45, 1);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (2, 1, 1, 'Multiple Choice', '12-11-2023 07:38:00', '09-03-2024', 16, 1);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (3, 0, 0, 'Essay Exam', '29-08-2023 14:10:42', '24-08-2023', 17, 1);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (4, 1, 1, 'Multiple Choice', '30-07-2023 03:32:15', '16-09-2023', 9, 3);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (5, 0, 1, 'Essay Exam', '06-10-2023 11:06:14', '16-06-2023', 12, 1);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (6, 0, 0, 'Essay Exam', '13-10-2023 13:44:54', '10-05-2023', 70, 2);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (7, 1, 1, 'Essay Exam', '24-02-2024 16:59:17', '17-09-2023', 78, 3);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (8, 0, 0, 'Multiple Choice', '09-04-2023 03:14:24', '29-04-2023', 58, 1);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (9, 0, 1, 'Essay Exam', '27-08-2023 02:06:40', '13-07-2023', 88, 2);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (10, 1, 0, 'Multiple Choice', '23-10-2023 00:41:22', '14-10-2023', 96, 2);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (11, 0, 1, 'Multiple Choice', '02-03-2024 14:03:55', '04-05-2023', 23, 2);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (12, 0, 0, 'Multiple Choice', '18-11-2023 06:37:40', '16-07-2023', 80, 2);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (13, 1, 1, 'Multiple Choice', '05-06-2023 01:02:12', '26-02-2024', 86, 3);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (14, 1, 0, 'Multiple Choice', '11-11-2023 03:17:56', '05-12-2023', 99, 1);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (15, 1, 1, 'Multiple Choice', '30-09-2023 12:22:19', '16-06-2023', 93, 1);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (16, 0, 0, 'Essay Exam', '25-04-2023 16:52:04', '15-01-2024', 32, 1);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (17, 1, 0, 'Multiple Choice', '28-11-2023 02:06:04', '28-05-2023', 80, 3);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (18, 1, 1, 'Essay Exam', '03-09-2023 14:07:06', '23-09-2023', 41, 1);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (19, 1, 0, 'Essay Exam', '12-04-2023 20:46:49', '15-03-2024', 92, 2);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (20, 1, 1, 'Multiple Choice', '19-06-2023 15:12:31', '28-01-2024', 61, 1);

insert into QuizBank (QuizID, Context, Answer) values (1, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (2, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (3, 'Fusce consequat. Nulla nisl. Nunc nisl.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (4, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (5, 'In congue. Etiam justo. Etiam pretium iaculis justo.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (6, 'Fusce consequat. Nulla nisl. Nunc nisl.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (7, 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (8, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (9, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (10, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (11, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (12, 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (13, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (14, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (15, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (16, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (17, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (18, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (19, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (20, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (21, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (22, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (23, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (24, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (25, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (26, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (27, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (28, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (29, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (30, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (31, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (32, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (33, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (34, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (35, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (36, 'Fusce consequat. Nulla nisl. Nunc nisl.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (37, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (38, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (39, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (40, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (41, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (42, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (43, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (44, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (45, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (46, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (47, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (48, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (49, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (50, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (51, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (52, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (53, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (54, 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (55, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (56, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (57, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (58, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (59, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (60, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (61, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (62, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (63, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (64, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (65, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (66, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (67, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (68, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (69, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (70, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (71, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (72, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (73, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (74, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (75, 'Fusce consequat. Nulla nisl. Nunc nisl.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (76, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (77, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (78, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (79, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (80, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (81, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (82, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (83, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (84, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (85, 'In congue. Etiam justo. Etiam pretium iaculis justo.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (86, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (87, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (88, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (89, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (90, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (91, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (92, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (93, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (94, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (95, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (96, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (97, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (98, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (99, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (100, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'B');

insert into Quiz (TestID, QuizID) values (7, 65);
insert into Quiz (TestID, QuizID) values (6, 31);
insert into Quiz (TestID, QuizID) values (1, 54);
insert into Quiz (TestID, QuizID) values (14, 48);
insert into Quiz (TestID, QuizID) values (18, 41);
insert into Quiz (TestID, QuizID) values (3, 62);
insert into Quiz (TestID, QuizID) values (9, 97);
insert into Quiz (TestID, QuizID) values (10, 98);
insert into Quiz (TestID, QuizID) values (15, 58);
insert into Quiz (TestID, QuizID) values (18, 62);
insert into Quiz (TestID, QuizID) values (6, 66);
insert into Quiz (TestID, QuizID) values (9, 40);
insert into Quiz (TestID, QuizID) values (8, 53);
insert into Quiz (TestID, QuizID) values (1, 66);
insert into Quiz (TestID, QuizID) values (5, 67);
insert into Quiz (TestID, QuizID) values (11, 79);
insert into Quiz (TestID, QuizID) values (9, 31);
insert into Quiz (TestID, QuizID) values (1, 65);
insert into Quiz (TestID, QuizID) values (8, 31);
insert into Quiz (TestID, QuizID) values (20, 45);
insert into Quiz (TestID, QuizID) values (14, 38);
insert into Quiz (TestID, QuizID) values (10, 35);
insert into Quiz (TestID, QuizID) values (10, 25);
insert into Quiz (TestID, QuizID) values (7, 54);
insert into Quiz (TestID, QuizID) values (4, 32);
insert into Quiz (TestID, QuizID) values (6, 46);
insert into Quiz (TestID, QuizID) values (6, 45);
insert into Quiz (TestID, QuizID) values (8, 13);
insert into Quiz (TestID, QuizID) values (17, 83);
insert into Quiz (TestID, QuizID) values (6, 32);
insert into Quiz (TestID, QuizID) values (7, 98);
insert into Quiz (TestID, QuizID) values (13, 71);
insert into Quiz (TestID, QuizID) values (17, 95);
insert into Quiz (TestID, QuizID) values (15, 43);
insert into Quiz (TestID, QuizID) values (9, 85);
insert into Quiz (TestID, QuizID) values (1, 93);
insert into Quiz (TestID, QuizID) values (6, 61);
insert into Quiz (TestID, QuizID) values (9, 89);
insert into Quiz (TestID, QuizID) values (7, 34);
insert into Quiz (TestID, QuizID) values (13, 20);
insert into Quiz (TestID, QuizID) values (18, 31);
insert into Quiz (TestID, QuizID) values (17, 45);
insert into Quiz (TestID, QuizID) values (13, 56);
insert into Quiz (TestID, QuizID) values (11, 18);
insert into Quiz (TestID, QuizID) values (20, 43);
insert into Quiz (TestID, QuizID) values (9, 86);
insert into Quiz (TestID, QuizID) values (2, 87);
insert into Quiz (TestID, QuizID) values (19, 20);
insert into Quiz (TestID, QuizID) values (3, 69);
insert into Quiz (TestID, QuizID) values (17, 85);
insert into Quiz (TestID, QuizID) values (18, 73);
insert into Quiz (TestID, QuizID) values (5, 42);
insert into Quiz (TestID, QuizID) values (5, 55);
insert into Quiz (TestID, QuizID) values (5, 89);
insert into Quiz (TestID, QuizID) values (18, 71);
insert into Quiz (TestID, QuizID) values (15, 89);
insert into Quiz (TestID, QuizID) values (18, 43);
insert into Quiz (TestID, QuizID) values (19, 46);
insert into Quiz (TestID, QuizID) values (3, 33);
insert into Quiz (TestID, QuizID) values (16, 11);
insert into Quiz (TestID, QuizID) values (20, 26);
insert into Quiz (TestID, QuizID) values (1, 43);
insert into Quiz (TestID, QuizID) values (2, 76);
insert into Quiz (TestID, QuizID) values (10, 30);
insert into Quiz (TestID, QuizID) values (1, 55);
insert into Quiz (TestID, QuizID) values (8, 83);
insert into Quiz (TestID, QuizID) values (2, 35);
insert into Quiz (TestID, QuizID) values (14, 66);
insert into Quiz (TestID, QuizID) values (17, 71);
insert into Quiz (TestID, QuizID) values (17, 89);
insert into Quiz (TestID, QuizID) values (9, 43);
insert into Quiz (TestID, QuizID) values (13, 18);
insert into Quiz (TestID, QuizID) values (3, 63);
insert into Quiz (TestID, QuizID) values (13, 67);
insert into Quiz (TestID, QuizID) values (11, 17);
insert into Quiz (TestID, QuizID) values (14, 57);
insert into Quiz (TestID, QuizID) values (6, 65);
insert into Quiz (TestID, QuizID) values (18, 93);
insert into Quiz (TestID, QuizID) values (17, 79);
insert into Quiz (TestID, QuizID) values (7, 43);
insert into Quiz (TestID, QuizID) values (8, 25);
insert into Quiz (TestID, QuizID) values (1, 96);
insert into Quiz (TestID, QuizID) values (1, 37);
insert into Quiz (TestID, QuizID) values (18, 59);
insert into Quiz (TestID, QuizID) values (1, 31);
insert into Quiz (TestID, QuizID) values (3, 64);
insert into Quiz (TestID, QuizID) values (14, 12);
insert into Quiz (TestID, QuizID) values (8, 49);
insert into Quiz (TestID, QuizID) values (7, 30);
insert into Quiz (TestID, QuizID) values (8, 45);
insert into Quiz (TestID, QuizID) values (2, 79);
insert into Quiz (TestID, QuizID) values (7, 41);
insert into Quiz (TestID, QuizID) values (4, 14);
insert into Quiz (TestID, QuizID) values (19, 77);
insert into Quiz (TestID, QuizID) values (5, 25);
insert into Quiz (TestID, QuizID) values (15, 78);

insert into StuWork (StuID, TestID, TimesID, StuWork, DoneTime, Score) values ('SV05', 16, 1, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '14-02-2024', 78);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoneTime, Score) values ('SV08', 10, 2, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', '28-04-2023', 5);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoneTime, Score) values ('SV04', 13, 3, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', '04-11-2023', 22);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoneTime, Score) values ('SV11', 15, 1, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', '03-08-2023', 32);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoneTime, Score) values ('SV13', 14, 2, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', '17-04-2023', 8);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoneTime, Score) values ('SV12', 17, 1, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '22-06-2023', 33);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoneTime, Score) values ('SV09', 20, 3, 'Fusce consequat. Nulla nisl. Nunc nisl.', '07-12-2023', 45);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoneTime, Score) values ('SV17', 3, 1, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', '21-10-2023', 60);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoneTime, Score) values ('SV18', 4, 5, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '09-06-2023', 72);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoneTime, Score) values ('SV08', 14, 2, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '08-06-2023', 23);

insert into Study (StuID, ClassID) values ('SV17', 15);
insert into Study (StuID, ClassID) values ('SV09', 15);
insert into Study (StuID, ClassID) values ('SV13', 12);
insert into Study (StuID, ClassID) values ('SV14', 12);
insert into Study (StuID, ClassID) values ('SV04', 2);
insert into Study (StuID, ClassID) values ('SV12', 4);
insert into Study (StuID, ClassID) values ('SV11', 2);
insert into Study (StuID, ClassID) values ('SV03', 4);
insert into Study (StuID, ClassID) values ('SV12', 1);
insert into Study (StuID, ClassID) values ('SV07', 5);
insert into Study (StuID, ClassID) values ('SV13', 4);
insert into Study (StuID, ClassID) values ('SV05', 6);
insert into Study (StuID, ClassID) values ('SV16', 9);
insert into Study (StuID, ClassID) values ('SV16', 6);
insert into Study (StuID, ClassID) values ('SV13', 1);
insert into Study (StuID, ClassID) values ('SV08', 1);
insert into Study (StuID, ClassID) values ('SV13', 10);
insert into Study (StuID, ClassID) values ('SV13', 15);
insert into Study (StuID, ClassID) values ('SV11', 9);
insert into Study (StuID, ClassID) values ('SV05', 9);
insert into Study (StuID, ClassID) values ('SV03', 13);
insert into Study (StuID, ClassID) values ('SV07', 10);
insert into Study (StuID, ClassID) values ('SV04', 12);
insert into Study (StuID, ClassID) values ('SV06', 4);
insert into Study (StuID, ClassID) values ('SV01', 8);
insert into Study (StuID, ClassID) values ('SV10', 11);