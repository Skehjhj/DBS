CREATE DATABASE lms;
use lms;


SET DATEFORMAT dmy;
CREATE      TABLE       UserTable (
  userID    CHAR(9)   PRIMARY KEY,
  mail      VARCHAR(255),
  name      VARCHAR(255),
  DoB       DATE,
  sex       VARCHAR(10),
  password  VARCHAR(10),
);


ALTER TABLE UserTable
ADD CONSTRAINT CK_Sex
CHECK (sex IN ('Male', 'Female'));

ALTER TABLE UserTable
ADD CONSTRAINT CK_mail
CHECK (mail LIKE '%@hcmut.edu.vn');


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
  CourseID  CHAR(6)     PRIMARY KEY,
  Name      VARCHAR(255),
  Credit     INTEGER,
  Prerequisites CHAR(6) NULL  REFERENCES Course (CourseID),
);

CREATE TABLE MarkColumns(
  CourseID  CHAR(6),
  MarkName CHAR(50),
  PRIMARY KEY (CourseID, MarkName),
  Percentage INTEGER,
);

CREATE      TABLE      Class (
  ClassID    INTEGER     PRIMARY KEY,
  SemesterID INTEGER,
  CONSTRAINT fk_class_semester_SemesterID FOREIGN KEY (SemesterID) REFERENCES Semester (SemesterID),
  Classroom  CHAR(3),
  CourseID  CHAR(6),
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

CREATE TABLE QuizBank (
  QuizID INTEGER PRIMARY KEY,
  Context VARCHAR(255),
  Answer VARCHAR(255)
);

CREATE TABLE Test (
  TestID INTEGER PRIMARY KEY,
  ClassID INTEGER,
  CONSTRAINT fk_test_class_ClassID FOREIGN KEY
                            (ClassID) REFERENCES Class (ClassID),
  Deadline DATETIME,
  Test_name VARCHAR(255),
  MarkName CHAR(50)
);

CREATE TABLE TestQuestions (
  TestID INTEGER REFERENCES Test (TestID),
  QuestionID INTEGER REFERENCES QuizBank (QuizID),
  PRIMARY KEY (TestID, QuestionID)
);


CREATE TABLE StuWork (
  StuID CHAR(9) REFERENCES Student (StuID),
  TestID INTEGER REFERENCES Test (TestID),
  TimesID INTEGER,
  PRIMARY KEY (StuID, TestID, TimesID),
  StuWork VARCHAR(255),
  DoTime TIME,
  DoneTime DATE,
  Score DECIMAL(10,2)
);

--- Continues ---

CREATE TABLE Study(
    StuID CHAR(9) REFERENCES Student (StuID),
    ClassID INTEGER REFERENCES Class (ClassID),
    CONSTRAINT pk_study PRIMARY KEY (StuID, ClassID),
    Avg_Score DECIMAL(10,2)
);

CREATE TRIGGER UpdateClassSize
ON Study
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted) OR EXISTS (SELECT 1 FROM deleted)
    BEGIN
        UPDATE c
        SET Class_size = s.StudentsCount
        FROM Class c
        INNER JOIN (
            SELECT ClassID, COUNT(StuID) AS StudentsCount
            FROM Study
            GROUP BY ClassID
        ) s ON c.ClassID = s.ClassID;
    END
END;

DROP PROCEDURE IF EXISTS arange_student_on_score;
CREATE PROCEDURE arange_student_on_score
	@_in INT
AS
BEGIN
    SELECT
        s.StuID,
        s.Avg_Score,
        u.name
    FROM
        Study s
    JOIN
        UserTable u ON u.userID = s.StuID
    JOIN
        Class c ON s.ClassID = c.ClassID
    JOIN
        Semester sem ON c.SemesterID = sem.SemesterID
    WHERE
        sem.SemesterID = @_in
    ORDER BY
        s.Avg_Score DESC;
END;

CREATE PROCEDURE get_course_enroll(
  @user_id CHAR(9)
)
AS
BEGIN
  SELECT c.CourseID
  FROM Class AS c
  JOIN Study AS s ON s.ClassID = c.ClassID
  WHERE s.StuID = @user_id
  ORDER BY c.CourseID ASC;
END;

DROP TABLE IF EXISTS #highest_scores;
CREATE TABLE #highest_scores (
    StuID INT, 
    TestID INT,
    Score INT
);
INSERT INTO #highest_scores (StuID, TestID, Score)
SELECT S.StuID, T.TestID, MAX(S.Score)
FROM StuWork AS S
INNER JOIN Test AS T ON T.TestID = S.TestID
GROUP BY S.StuID, T.TestID;

DROP TABLE IF EXISTS #tests_to_mark_columns;
CREATE TABLE #tests_to_mark_columns (
    TestID INT, 
    CourseID INT,
    Percentage INT
);
INSERT INTO #tests_to_mark_columns (TestID, CourseID)
SELECT T.TestID, MC.CourseID
FROM Test AS T
INNER JOIN Class AS C ON T.ClassID = C.ClassID
INNER JOIN MarkColumns AS MC ON C.CourseID = MC.CourseID;


DROP TRIGGER IF EXISTS update_avg_score;
CREATE TRIGGER update_avg_score
ON Study
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
  DECLARE @StuID INT;
  SELECT @StuID = inserted.StuID FROM inserted;
  UPDATE highest_scores
  SET avg_score = (SELECT SUM(hs.Score * TMC.Percentage / 100)
                   FROM highest_scores AS hs
                   INNER JOIN tests_to_mark_columns AS TMC ON hs.TestID = TMC.TestID
                   WHERE hs.StuID = @StuID
                   GROUP BY hs.StuID)
  WHERE StuID = @StuID;
END;

CREATE OR ALTER TRIGGER check_add_user
ON UserTable
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @ErrorMessage NVARCHAR(100)
	
    IF NOT EXISTS (SELECT 1 FROM INSERTED WHERE INSERTED.sex LIKE 'Male' OR INSERTED.sex LIKE 'Female')
    BEGIN
        SET @ErrorMessage = 'Gioi tinh khong hop le'
        RAISERROR (@ErrorMessage, 16, 1)
        RETURN
    END
	
    IF NOT EXISTS (SELECT 1 FROM INSERTED WHERE INSERTED.mail LIKE '%@hcmut.edu.vn')
    BEGIN
        SET @ErrorMessage = 'Email khong hop le'
        RAISERROR (@ErrorMessage, 16, 1)
        RETURN
    END

    INSERT INTO UserTable (Sex, mail)
    SELECT INSERTED.sex, INSERTED.mail FROM INSERTED
END

CREATE PROCEDURE check_student_submission_count
(
  @student_id CHAR(9)
)
AS
BEGIN
  DECLARE @submission_count INT
  DECLARE submission_cursor CURSOR FOR
    SELECT COUNT(*) AS submission_count
    FROM StuWork AS sw
    WHERE sw.StuID = @student_id;

  OPEN submission_cursor;
  FETCH NEXT FROM submission_cursor INTO @submission_count;
  CLOSE submission_cursor;
  DEALLOCATE submission_cursor;

  IF @submission_count IS NULL
  BEGIN
    SELECT 'Sinh viên này chưa nộp bài'
  END
  ELSE
  BEGIN
    SELECT CONCAT('Sinh viên này đã nộp ', @submission_count, ' bài')
  END;
END;

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

UPDATE UserTable
SET password = '1234567';

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

insert into Student (StuID, DateJoin, Major, Program) values ('SV01', '07/03/2023', 'Psychology', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV02', '07/08/2021', 'English Literature', 'CLC');
insert into Student (StuID, DateJoin, Major, Program) values ('SV03', '09/10/2020', 'Psychology', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV04', '06/09/2020', 'Business Administration', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV05', '02/10/2019', 'Computer Science', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV06', '28/06/2019', 'Psychology', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV07', '10/10/2021', 'Computer Science', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV08', '16/09/2019', 'Engineering', 'CLC');
insert into Student (StuID, DateJoin, Major, Program) values ('SV09', '10/06/2022', 'Mathematics', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV10', '22/07/2020', 'Computer Science', 'VHVL');
insert into Student (StuID, DateJoin, Major, Program) values ('SV11', '11/09/2022', 'History', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV12', '13/02/2022', 'Mathematics', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV13', '07/07/2019', 'Engineering', 'VHVL');
insert into Student (StuID, DateJoin, Major, Program) values ('SV14', '01/04/2021', 'History', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV15', '02/07/2020', 'Sociology', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV16', '06/01/2021', 'Psychology', 'VHVL');
insert into Student (StuID, DateJoin, Major, Program) values ('SV17', '07/01/2022', 'Mathematics', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV18', '11/04/2021', 'Engineering', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV19', '29/07/2019', 'Computer Science', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV20', '15/03/2020', 'History', 'CTTT');

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

INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('ART606', N'Photography Basics', 2, null);
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('ENG303', N'Digital Marketing Strategies', 4, null);
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('MAT202', N'Advanced Calculus', 3, null);
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('PHI808', N'Music Theory Fundamentals', 3, null);
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('BUS707', N'Nutrition and Wellness', 4, 'PHI808');
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('CSE101', N'Introduction to Psychology', 1, 'MAT202');
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('CHE101', N'Business Ethics', 1, 'CSE101');
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('SCI505', N'History of Ancient Civilizations', 1, 'ART606');
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('HIS404', N'Creative Writing Workshop', 2, 'SCI505');
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('MUS909', N'Introduction to Computer Science', 4, 'CHE101');

insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (1, 223, 'L01', 'PHI808', 'GV10');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (2, 213, 'C02', 'CHE101', 'GV03');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (3, 192, 'J03', 'BUS707', 'GV09');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (4, 211, 'L04', 'SCI505', 'GV03');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (5, 213, 'C05', 'MAT202', 'GV09');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (6, 201, 'J01', 'ENG303', 'GV09');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (7, 211, 'L02', 'ART606', 'GV09');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (8, 193, 'C03', 'SCI505', 'GV10');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (9, 201, 'J04', 'CHE101', 'GV07');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (10, 213, 'L05', 'PHI808', 'GV10');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (11, 191, 'L03', 'CHE101', 'GV06');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (12, 193, 'C04', 'BUS707', 'GV02');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (13, 223, 'J05', 'CSE101', 'GV09');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (14, 212, 'L01', 'MUS909', 'GV01');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (15, 201, 'C02', 'HIS404', 'GV10');

insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (1, 'Proposal_2021', 'Newsletter', 'https://hud.gov', 11, 'Wenona');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (2, 'Report_Q3', 'Presentation', 'https://illinois.edu', 13, 'Olimpia');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (3, 'Presentation_Final', 'Manual', 'https://taobao.com', 8, 'Kare');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (4, 'Invoice_12345', 'Newsletter', 'http://umich.edu', 15, 'Kelcie');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (5, 'Agreement_Template', 'Report', 'http://w3.org', 5, 'Davidde');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (6, 'Manual_UserGuide', 'Manual', 'https://mozilla.com', 12, 'Yance');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (7, 'Policy_HR', 'Brochure', 'http://163.com', 2, 'Merissa');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (8, 'Survey_Results', 'Manual', 'https://toplist.cz', 9, 'Wittie');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (9, 'Newsletter_March', 'Agreement', 'http://google.co.jp', 6, 'Chariot');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (10, 'Training_Module', 'Report', 'https://spiegel.de', 9, 'Florence');

insert into QuizBank (QuizID, Context, Answer) values (1, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (2, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (3, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (4, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (5, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (6, 'In congue. Etiam justo. Etiam pretium iaculis justo.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (7, 'In congue. Etiam justo. Etiam pretium iaculis justo.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (8, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (9, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (10, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (11, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (12, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (13, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (14, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (15, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (16, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (17, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (18, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (19, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (20, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (21, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (22, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (23, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (24, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (25, 'Fusce consequat. Nulla nisl. Nunc nisl.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (26, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (27, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (28, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (29, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (30, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', 'D');

insert into Test (TestID, ClassID, Deadline, Test_name) values (1, 2, '18/02/2024', 'Test4');
insert into Test (TestID, ClassID, Deadline, Test_name) values (2, 9, '10/01/2024', 'Test1');
insert into Test (TestID, ClassID, Deadline, Test_name) values (3, 8, '06/07/2023', 'Test2');
insert into Test (TestID, ClassID, Deadline, Test_name) values (4, 8, '24/10/2023', 'Test5');
insert into Test (TestID, ClassID, Deadline, Test_name) values (5, 2, '04/06/2023', 'Test3');

INSERT Into TestQuestions(TestID, QuestionID) VALUES (1, 1);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (1, 2);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (1, 3);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (1, 4);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (1, 5);

INSERT Into TestQuestions(TestID, QuestionID) VALUES (2, 6);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (2, 7);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (2, 1);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (2, 2);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (2, 3);

insert into StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) values ('SV05', 1, 1, '1C2C3C4C5C', '14-02-2024', '14-02-2024', 78);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) values ('SV08', 2, 1, '1C2C3C4C5C', '28-04-2023', '28-04-2023', 5);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) values ('SV04', 3, 1, '1C2C3C4C5C', '03-08-2023', '03-08-2023', 32);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) values ('SV13', 4, 1, '1C2C3C4C5C', '17-04-2023', '17-04-2023', 8);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) values ('SV12', 1, 1, '1C2C3C4C5C', '22-06-2023', '22-06-2023', 33);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) values ('SV09', 2, 1, '1C2C3C4C5C', '07-12-2023', '07-12-2023', 45);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) values ('SV17', 3, 1, '1C2C3C4C5C', '21-10-2023', '21-10-2023', 60);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) values ('SV18', 4, 1, '1C2C3C4C5C', '09-06-2023', '09-06-2023', 72);
insert into StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) values ('SV08', 2, 2, '1C2C3C4C5C', '08-06-2023', '08-06-2023', 23);

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