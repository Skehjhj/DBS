CREATE DATABASE lms;
use lms;


SET DATEFORMAT dmy;
CREATE      TABLE       UserTable (
  userID    VARCHAR(9)   PRIMARY KEY,
  mail      VARCHAR(255),
  name      VARCHAR(255),
  DoB       DATE,
  sex       VARCHAR(10),
  password  VARCHAR(10)
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
    SenderID VARCHAR(9),
    CONSTRAINT fk_sender_user_SenderID FOREIGN KEY (SenderID) REFERENCES UserTable (userID),
);

CREATE TABLE Receiver(
  ReceiverID VARCHAR(9),
  CONSTRAINT fk_receiver_user_ReceiverID FOREIGN KEY (ReceiverID) REFERENCES UserTable (userID),
  MessageID INTEGER,
  CONSTRAINT fk_receiver_message_MessageID FOREIGN KEY (MessageID) REFERENCES Message (MessageID),
  ReceiveTime DATE
)

CREATE TABLE Professor (
  ProfID    VARCHAR(9)    PRIMARY KEY,
  CONSTRAINT   fk_prof_user_ProfID   FOREIGN KEY
                            (ProfID) REFERENCES UserTable (userID),
  Degree      VARCHAR(255),
);

CREATE TABLE Student (
  StuID    VARCHAR(9)     PRIMARY KEY,
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

CREATE TABLE Course (
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

CREATE TABLE Class (
  ClassID    INTEGER     PRIMARY KEY,
  SemesterID INTEGER,
  CONSTRAINT fk_class_semester_SemesterID FOREIGN KEY (SemesterID) REFERENCES Semester (SemesterID),
  Classroom  CHAR(3),
  CourseID  CHAR(6),
  CONSTRAINT  fk_class_course_CourseID FOREIGN KEY (CourseID) REFERENCES Course (CourseID),
  ProfID    VARCHAR(9),
  CONSTRAINT   fk_class_prof_ProfID   FOREIGN KEY
                            (ProfID) REFERENCES Professor (ProfID),
  Class_size INTEGER,
  Status VARCHAR(255)
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
  StuID VARCHAR(9) REFERENCES Student (StuID),
  TestID INTEGER REFERENCES Test (TestID),
  TimesID INTEGER,
  PRIMARY KEY (StuID, TestID, TimesID),
  StuWork VARCHAR(255),
  DoTime TIME,
  DoneTime DATE,
  Score DECIMAL(10,2)
);

CREATE TABLE FinalScore(
  StuID VARCHAR(9),
  TestID INT,
  TimesID INT,
  Score INT
);

--- Continues ---

CREATE TABLE Study(
    StuID VARCHAR(9) REFERENCES Student (StuID),
    ClassID INTEGER REFERENCES Class (ClassID),
    CONSTRAINT pk_study PRIMARY KEY (StuID, ClassID),
    Avg_Score DECIMAL(10,2)
);

CREATE TRIGGER UpdateClassSize -- Tested
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


DROP PROCEDURE IF EXISTS arange_student_on_score; -- Tested: EXEC arange_student_on_score 6
CREATE PROCEDURE arange_student_on_score(@ClassID INT)
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
        Class c ON c.ClassID = @ClassID
		WHERE s.ClassID = c.ClassID
    ORDER BY
        s.Avg_Score DESC;
END;

CREATE OR ALTER PROCEDURE get_course_enroll(
  @user_id VARCHAR(9)
)
AS
BEGIN
  SELECT c.CourseID
  FROM Class AS c
  JOIN Study AS s ON s.ClassID = c.ClassID
  WHERE s.StuID = @user_id
  ORDER BY c.CourseID ASC;
END; -- Tested: EXEC get_course_enroll SV01

-- Replace the trigger with a function and a procedure
CREATE OR ALTER FUNCTION CalculateAverageScore (@StuID VARCHAR(9), @ClassID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @AvgScore FLOAT;
    WITH FinalScore AS (
        SELECT StuID, TestID, MAX(Score) AS Score
        FROM StuWork
        GROUP BY StuID, TestID
    ),
    WeightedScores AS (
        SELECT
            Fs.StuID,
            c.ClassID,
            COALESCE(SUM(Fs.Score * Mc.Percentage), 0) / 100 AS Avg_Score
        FROM FinalScore AS Fs
        JOIN Test AS t ON Fs.TestID = t.TestID
        JOIN Class AS c ON t.ClassID = c.ClassID
        JOIN MarkColumns AS mc ON c.CourseID = mc.CourseID AND t.MarkName = mc.MarkName
        GROUP BY Fs.StuID, c.ClassID
    )

    SELECT @AvgScore = WeightedScores.Avg_Score
    FROM WeightedScores
    WHERE StuID = @StuID AND ClassID = @ClassID;
    RETURN @AvgScore;
END;
-- Tested: SELECT [dbo].CalculateAverageScore('SV01', 1)
CREATE OR ALTER PROCEDURE UpdateAvgScoreForStudy -- Update the Avg_Score of Study table
AS
BEGIN
    DECLARE @StuID VARCHAR(9);
    DECLARE @ClassID INTEGER;
    DECLARE @AvgScore DECIMAL(10, 2);

    -- Cursor to iterate over each StuID and ClassID combination
    DECLARE study_cursor CURSOR FOR
        SELECT StuID, ClassID
        FROM Study;

    OPEN study_cursor;

    -- Fetching the first StuID and ClassID
    FETCH NEXT FROM study_cursor INTO @StuID, @ClassID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calculate average score using the CalculateAverageScore function
        SET @AvgScore = dbo.CalculateAverageScore(@StuID, @ClassID);

        -- Update the Avg_Score in the Study table
        UPDATE Study
        SET Avg_Score = @AvgScore
        WHERE StuID = @StuID AND ClassID = @ClassID;

        -- Fetch the next StuID and ClassID
        FETCH NEXT FROM study_cursor INTO @StuID, @ClassID;
    END;

    CLOSE study_cursor;
    DEALLOCATE study_cursor;
END; -- Test: EXEC UpdateAvgScoreForStudy

-- Procedure to get 10% student of Semester with condition about Score and Amount of Courses register, 
-- then get by Scoree first, then with Amount of Courses register
CREATE OR ALTER PROCEDURE GetScholarshipStudents 
    @SemesterID NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TotalStudents INT;
    -- Calculate the total number of distinct students enrolled in the semester
    SELECT @TotalStudents = COUNT(DISTINCT s.StuID)
    FROM Study s
    JOIN Class c ON s.ClassID = c.ClassID
    WHERE c.SemesterID = @SemesterID;

    WITH StudentStats AS (
      SELECT
        s.StuID,
        [dbo].[GetStudentSemesterAverageGrade](s.StuID, @SemesterID) AS AverageGrade,
        COUNT(s.StuID) AS CountClass
      FROM Study s
      JOIN Class c ON s.ClassID = c.ClassID
      WHERE c.SemesterID = @SemesterID
      GROUP BY s.StuID
    ),
    QualifiedStudents AS (
      SELECT
        StuID,
        AverageGrade,
        CountClass
      FROM StudentStats
      GROUP BY StuID, AverageGrade, CountClass
      HAVING AverageGrade > 70
        AND CountClass >= 3
    ),
    TopStudents AS (
      SELECT *,
        ROW_NUMBER() OVER (ORDER BY AverageGrade DESC) AS RowNum
      FROM QualifiedStudents
    )
    -- Return the list of students who qualify for the scholarship
    SELECT StuID, AverageGrade, CountClass, RowNum as Rank
    FROM TopStudents
    WHERE RowNum <= CEILING(0.1 * @TotalStudents);
END; -- Test: EXEC GetScholarshipStudents 223

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
        SET @ErrorMessage = 'Email khong thuoc Truong DH Bach Khoa'
        RAISERROR (@ErrorMessage, 16, 1)
        RETURN
    END

    INSERT INTO UserTable (userID, mail, name, DoB, sex, password)
    SELECT INSERTED.userID, INSERTED.mail, INSERTED.name, INSERTED.DoB, INSERTED.sex, INSERTED.password FROM INSERTED
END -- Tested

-- Improve this Procedures like check Student has finished enough Test
CREATE OR ALTER PROCEDURE check_student_submission_count (@student_id VARCHAR(9), @classID INT)
AS
BEGIN
  DECLARE @submission_count INT
  DECLARE submission_cursor CURSOR FOR
    SELECT COUNT(*) AS submission_count
    FROM StuWork AS sw
	JOIN Class c ON c.ClassID = @classID
    WHERE sw.StuID = @student_id;

  OPEN submission_cursor;
  FETCH NEXT FROM submission_cursor INTO @submission_count;
  CLOSE submission_cursor;
  DEALLOCATE submission_cursor;

  IF @submission_count IS NULL
  BEGIN
    SELECT 'Sinh vien chua nop bai nao'
  END
  ELSE
  BEGIN
    SELECT CONCAT('Sinh vien da nop ', @submission_count, ' bai')
  END;
END;

CREATE OR ALTER PROCEDURE ArrangeClassByAvgScore(@profID VARCHAR(9), @courseID CHAR(6), @semesterID INT)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Class 
               WHERE ProfID = @profID AND CourseID = @courseID AND SemesterID = @SemesterID)
    BEGIN
        SELECT 'Giao vien khong day mon nay hoac khong day trong ki nay'
    END
END
SELECT s.ClassID, c.Classroom, AVG(Avg_Score) AS Avg_Score
FROM Study s
JOIN Class c ON s.ClassID = c.ClassID
WHERE ProfID = @profID AND SemesterID = @semesterID
GROUP BY s.ClassID, c.Classroom
ORDER BY Avg_Score DESC;
-- Tested: EXEC ArrangeClassByAvgScore GV01,  CHE101, 223

CREATE OR ALTER PROCEDURE GetStudentsWithCompletedTest (@classID INT)
AS
BEGIN
    SELECT StuID, name
    INTO #CompletedTest
    FROM Study s
    JOIN UserTable ut ON s.StuID = ut.userID AND s.ClassID = @classID
    WHERE EXISTS (SELECT 1 FROM FinalScore fs
                  JOIN Test t ON fs.TestID = t.TestID
                  WHERE t.ClassID = @classID AND fs.StuID = s.StuID
                  GROUP BY fs.StuID
                  HAVING COUNT(*) = (SELECT COUNT(*) FROM Test WHERE ClassID = @classID))
	SELECT * FROM #CompletedTest
	DROP TABLE #CompletedTest
END;

-- SELECT * FROM GetStudentsWithCompletedTest(1);

CREATE OR ALTER FUNCTION CountStudentsAboveScore(@ScoreIN DECIMAL(10,2), @ClassID INT)
RETURNS INT
AS
BEGIN
IF (@ScoreIN > 100)
    BEGIN
		RETURN NULL;
    END;
  DECLARE @Count INT = 0;
	DECLARE @Score DECIMAL(10,2);
    DECLARE myCursor CURSOR FOR
        SELECT Avg_Score
        FROM Study
        WHERE ClassID = @ClassID;

    OPEN myCursor;

    FETCH NEXT FROM myCursor INTO @Score;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @Score > @ScoreIN
        BEGIN
            SET @Count = @Count + 1;
        END

        FETCH NEXT FROM myCursor INTO @Score;
    END;

    CLOSE myCursor;
    DEALLOCATE myCursor;

    RETURN @Count;
END; -- Tested: SELECT [dbo].CountStudentsAboveScore(80, 6)

CREATE PROCEDURE DeleteUnusedProfessor
AS
BEGIN
  DELETE FROM Professor
  WHERE ProfID NOT IN (SELECT ProfID FROM Class)
END;

CREATE PROCEDURE UpdateClassStatus(@CurDATE DATETIME, @SemesterID INT)
AS
BEGIN
	IF @CurDATE BETWEEN (SELECT StartDate FROM Semester WHERE SemesterID = @SemesterID)
                     AND (SELECT EndDate FROM Semester WHERE SemesterID = @SemesterID)
    BEGIN
         SELECT 'Ongoing'
    END
	ELSE
	BEGIN
    UPDATE Class
    SET Status = 'closed'
    WHERE SemesterID = @SemesterID;
	END
END; -- Tested: EXECUTE [dbo].[UpdateClassStatus]
	-- @CurDATE = '2024-27-04',
	-- @SemesterID = 223

CREATE OR ALTER PROCEDURE UpdateMissingStuWorkScores
AS
BEGIN
    WITH TestThatStudentDontDo AS (
        SELECT tn.StuID, tn.TestID, Fs.Score
        FROM (
            SELECT StuID, t.TestID, t.Deadline
            FROM Study AS st
            JOIN Test AS t ON st.ClassID = t.ClassID
        ) AS tn
        LEFT JOIN (
            SELECT StuID, TestID, MAX(Score) AS Score
            FROM StuWork
            GROUP BY StuID, TestID
        ) AS Fs ON Fs.StuID = tn.StuID AND Fs.TestID = tn.TestID
        WHERE tn.Deadline < GETDATE()
    )
    INSERT INTO StuWork (StuID, TestID, TimesID, Score)
    SELECT tnd.StuID, tnd.TestID, 1, 0
    FROM TestThatStudentDontDo AS tnd
    WHERE tnd.Score IS NULL;
END; -- Tested: EXEC UpdateMissingStuWorkScores;


CREATE OR ALTER FUNCTION GetStudentSemesterAverageGrade(@StuID VARCHAR(9), @SemesterID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @StudentGrades TABLE(
        CourseID CHAR(6),
        Avg_Score DECIMAL(10,2)
    );

    INSERT INTO @StudentGrades
    SELECT CourseID, Avg_Score
    FROM Study s JOIN Class c ON s.ClassID = c.ClassID
    WHERE StuID = @StuID AND SemesterID = @SemesterID;

    DECLARE @AverageGrade DECIMAL(10,2);

    SELECT @AverageGrade = AVG(Avg_Score)
    FROM @StudentGrades;

    RETURN @AverageGrade;
END; -- Tested: select [dbo].GetStudentSemesterAverageGrade('SV01', 223)

insert into UserTable (userID, mail, name, DoB, sex) values ('GV01', 'lbaldick0@hcmut.edu.vn', 'Libbie Baldick', '28-08-2003', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV02', 'dhartegan1@hcmut.edu.vn', 'Devy Hartegan', '17-12-2004', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV03', 'vpurkis2@hcmut.edu.vn', 'Vinny Purkis', '28-03-2003', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV04', 'jjozefczak3@hcmut.edu.vn', 'Janos Jozefczak', '26-11-2002', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV05', 'nrichichi4@hcmut.edu.vn', 'Nina Richichi', '29-08-2004', 'Female');
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
insert into UserTable (userID, mail, name, DoB, sex) values ('SV11', 'abusaij@hcmut.edu.vn', 'Amand Busain', '17-06-2000', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV12', 'abusai@hcmut.edu.vn', 'Amand Busai', '17-06-2000', 'Female');


UPDATE UserTable
SET password = '1234567';


insert into Message (MessageID, Content, SenderID) values (1, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'GV01');
insert into Message (MessageID, Content, SenderID) values (2, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'SV01');
insert into Message (MessageID, Content, SenderID) values (3, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'SV02');
insert into Message (MessageID, Content, SenderID) values (4, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 'GV02');
insert into Message (MessageID, Content, SenderID) values (5, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'SV03');


insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV01', 1, '21-08-2023');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV02', 2, '02-04-2024');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('GV01', 3, '20-09-2023');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('GV03', 4, '19-01-2024');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV05', 5, '03-09-2023');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV02', 1, '09-11-2023');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV05', 2, '30-04-2023');


insert into Professor (ProfID, Degree) values ('GV01', 'M.S.');
insert into Professor (ProfID, Degree) values ('GV02', 'M.S.');
insert into Professor (ProfID, Degree) values ('GV03', 'Ph.D');
insert into Professor (ProfID, Degree) values ('GV04', 'Ph.D');
insert into Professor (ProfID, Degree) values ('GV05', 'Bachelor');

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
insert into Student (StuID, DateJoin, Major, Program) values ('SV11', '10/06/2022', 'Mathematics', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV12', '10/06/2022', 'Mathematics', 'DT');

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

insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (1, 223, 'CH-01', 'CHE101', 'GV01');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (2, 223, 'CH-02', 'CHE101', 'GV01');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (3, 223, 'CH-03', 'CHE101', 'GV01');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (4, 223, 'AR-01', 'ART606', 'GV03');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (5, 223, 'BU-01', 'BUS707', 'GV01');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (6, 223, 'SC-01', 'SCI505', 'GV03');

insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (1, 'Proposal_2021', 'Newsletter', 'https://hud.gov', 1, 'Wenona');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (2, 'Report_Q3', 'Presentation', 'https://illinois.edu', 2, 'Olimpia');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (3, 'Presentation_Final', 'Manual', 'https://taobao.com', 3, 'Kare');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (4, 'Invoice_12345', 'Newsletter', 'http://umich.edu', 4, 'Kelcie');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (5, 'Agreement_Template', 'Report', 'http://w3.org', 5, 'Davidde');

insert into QuizBank (QuizID, Context, Answer) values (1, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (2, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (3, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula', 'B');
insert into QuizBank (QuizID, Context, Answer) values (4, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (5, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (6, 'In congue. Etiam justo. Etiam pretium iaculis justo.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (7, 'In congue. Etiam justo. Etiam pretium iaculis justo.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (8, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (9, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (10, 'Quisque id justo sit amet', 'D');

insert into Study (StuID, ClassID) values ('SV01', 1);
insert into Study (StuID, ClassID) values ('SV02', 1);
insert into Study (StuID, ClassID) values ('SV03', 1);
insert into Study (StuID, ClassID) values ('SV04', 1);
insert into Study (StuID, ClassID) values ('SV05', 2);
insert into Study (StuID, ClassID) values ('SV06', 2);
insert into Study (StuID, ClassID) values ('SV07', 2);
insert into Study (StuID, ClassID) values ('SV08', 2);
insert into Study (StuID, ClassID) values ('SV09', 3);
insert into Study (StuID, ClassID) values ('SV10', 3);
insert into Study (StuID, ClassID) values ('SV11', 3);
insert into Study (StuID, ClassID) values ('SV12', 3);

insert into Study (StuID, ClassID) values ('SV01', 4);
insert into Study (StuID, ClassID) values ('SV02', 4);

insert into Study (StuID, ClassID) values ('SV03', 5);
insert into Study (StuID, ClassID) values ('SV04', 5);
insert into Study (StuID, ClassID) values ('SV05', 5);
insert into Study (StuID, ClassID) values ('SV06', 5);
insert into Study (StuID, ClassID) values ('SV07', 5);
insert into Study (StuID, ClassID) values ('SV08', 5);
insert into Study (StuID, ClassID) values ('SV09', 5);
insert into Study (StuID, ClassID) values ('SV10', 5);
insert into Study (StuID, ClassID) values ('SV11', 5);
insert into Study (StuID, ClassID) values ('SV12', 5);

insert into Study (StuID, ClassID) values ('SV01', 6);
insert into Study (StuID, ClassID) values ('SV02', 6);
insert into Study (StuID, ClassID) values ('SV03', 6);
insert into Study (StuID, ClassID) values ('SV04', 6);
insert into Study (StuID, ClassID) values ('SV05', 6);
insert into Study (StuID, ClassID) values ('SV06', 6);
insert into Study (StuID, ClassID) values ('SV07', 6);
insert into Study (StuID, ClassID) values ('SV08', 6);
insert into Study (StuID, ClassID) values ('SV09', 6);
insert into Study (StuID, ClassID) values ('SV10', 6);
insert into Study (StuID, ClassID) values ('SV11', 6);
insert into Study (StuID, ClassID) values ('SV12', 6);

INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (1, 1, '2024-21-06 00:00:00.000', N'Test4', N'Final');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (2, 2, '2024-21-06 00:00:00.000', N'Test1', N'Final');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (3, 3, '2024-21-06 00:00:00.000', N'Test2', N'Final');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (4, 4, '2024-21-06 00:00:00.000', N'Test5', N'Final');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (5, 4, '2024-21-06 00:00:00.000', N'Test4', N'Labs');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (6, 4, '2024-21-06 00:00:00.000', N'Test1', N'Midterm');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (7, 4, '2024-21-06 00:00:00.000', N'Test2', N'Tutorial');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (8, 5, '2024-21-06 00:00:00.000', N'Test3', N'Final');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (9, 5, '2024-21-06 00:00:00.000', N'Test2', N'Labs');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (10, 6, '2024-21-06 00:00:00.000', N'Test1', N'Final');


INSERT Into TestQuestions(TestID, QuestionID) VALUES (1, 1);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (1, 2);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (1, 3);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (1, 4);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (1, 5);

INSERT Into TestQuestions(TestID, QuestionID) VALUES (2, 6);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (2, 7);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (2, 8);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (2, 9);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (2, 1);

insert into MarkColumns (CourseID, MarkName, Percentage) values ('ART606', 'Tutorial', 10);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('ART606', 'Labs', 20);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('ART606', 'Midterm', 30);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('ART606', 'Final', 40);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('BUS707', 'Labs', 20);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('BUS707', 'Final', 80);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('CHE101', 'Final', 100);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('CSE101', 'Final', 100);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('ENG303', 'Final', 100);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('HIS404', 'Final', 100);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('MAT202', 'Tutorial', 20);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('MAT202', 'Midterm', 40);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('MAT202', 'Final', 40);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('MUS909', 'Final', 100);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('PHI808', 'Midterm', 50);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('PHI808', 'Final', 50);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('SCI505', 'Final', 100);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV01', 1, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 100);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV02', 1, 1, N'a', N'10:21:39.0000000', N'2024-04-20', 95);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV03', 1, 1, N'A', N'10:21:48.0000000', N'2024-04-20', 90);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV04', 1, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 85);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV05', 2, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 80);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV06', 2, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 75);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV07', 2, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 70);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV08', 2, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 75);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV09', 3, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 60);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV10', 3, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 55);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV11', 3, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 50);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV12', 3, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 45);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV01', 4, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 100);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV01', 5, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 100);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV01', 6, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 100);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV01', 7, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 100);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV02', 4, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 95);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV02', 5, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 95);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV02', 6, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 95);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV02', 7, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 95);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV03', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 90);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV03', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 90);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV04', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 85),
    (N'SV04', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 85);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV05', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 80),
    (N'SV05', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 80);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV06', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 75),
    (N'SV06', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 75);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV07', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 70),
    (N'SV07', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 70);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV08', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 65),
    (N'SV08', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 65);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV09', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 60),
    (N'SV09', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 60);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV10', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 55),
    (N'SV10', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 55);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV11', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 50),
    (N'SV11', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 50);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV12', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 45),
    (N'SV12', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 45);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV01', 10, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 100);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV02', 10, 1, N'a', N'10:21:39.0000000', N'2024-04-20', 95);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV03', 10, 1, N'A', N'10:21:48.0000000', N'2024-04-20', 90);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV04', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 85);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV05', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 80);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV06', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 75);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV07', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 70);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV08', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 75);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV09', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 60);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV10', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 55);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV11', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 50);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV12', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 45);


DELETE StuWork

--xoa gv ko dung
SELECT *
FROM Professor

EXECUTE [dbo].[DeleteUnusedProfessor]

--check class size
SELECT * FROM Class

--khoa hoc cua sv
EXECUTE [dbo].[get_course_enroll]
    @user_id = 'SV03'

EXECUTE [dbo].[GetStudentsWithCompletedTest] --sai / nhieu hon van ko  tinh -> tinh tren FinalScore ->> fixed
    @classID = 1

	SELECT * FROM StuWork



EXECUTE [dbo].[check_student_submission_count]
	@student_id = 'SV11',
	@classID = 1;

--chua ket thuc mon nen chua tinh diem ->> chay ham update ben duoi ->> chay lai.
EXECUTE [dbo].[arange_student_on_score]
	@ClassID = 1;

	SELECT * FROM Study
----
EXECUTE [dbo].[UpdateClassStatus]
	@CurDATE = '2025-18-12',
	@SemesterID = 223

SELECT * FROM Class

EXECUTE [dbo].[CreateMissingStuWorks]
	@CurDATE = '2025-18-12'

	SELECT * FROM Study
-----


SELECT [dbo].[CountStudentsAboveScore](50,1)

SELECT * FROM Study

---CONTINUE


--- them 1 vai lop chung course nay
EXECUTE [dbo].[ArrangeClassByAvgScore]
	@profID = 'GV01',
	@courseID = 'ART606',
	@semesterID = 223


SELECT [dbo].[GetStudentSemesterAverageGrade]('SV03', 223)
	EXECUTE [dbo].[CreateMissingStuWorks]
	@CurDATE = '2025-18-12'

	SELECT * FROM Study