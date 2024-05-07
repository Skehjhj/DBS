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

CREATE TABLE Study(
    StuID VARCHAR(9) REFERENCES Student (StuID),
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

CREATE OR ALTER TRIGGER trg_UpdateFinalScore
ON StuWork
AFTER INSERT
AS
BEGIN
    DELETE FROM FinalScore WHERE StuID = (SELECT StuID FROM inserted) AND TestID = (SELECT TestID FROM inserted)
    INSERT INTO FinalScore (StuID, TestID, TimesID, Score)
    SELECT
        s.StuID,
        s.TestID,
        s.TimesID,
        s.Score
    FROM StuWork s
    INNER JOIN (
        SELECT StuID, TestID, MAX(Score) AS MaxScore
        FROM StuWork
        WHERE StuID = (SELECT StuID FROM inserted) AND TestID = (SELECT TestID FROM inserted)
        GROUP BY StuID, TestID
    ) max_scores
    ON s.StuID = max_scores.StuID
    AND s.TestID = max_scores.TestID
    AND s.Score = max_scores.MaxScore;

    WITH WeightedScores AS (
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
    UPDATE s
    SET Avg_Score = WeightedScores.Avg_Score
    FROM Study AS s
	JOIN WeightedScores ON s.StuID = WeightedScores.StuID AND s.ClassID = WeightedScores.ClassID;
END;

CREATE OR ALTER PROCEDURE GetScholarshipStudents 
    @SemesterID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TotalStudents INT;

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

    SELECT StuID, AverageGrade, CountClass, RowNum as Rank
    FROM TopStudents
    WHERE RowNum <= CEILING(0.1 * @TotalStudents);
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
        SET @ErrorMessage = 'Email khong thuoc Truong DH Bach Khoa'
        RAISERROR (@ErrorMessage, 16, 1)
        RETURN
    END

    INSERT INTO UserTable (userID, mail, name, DoB, sex, password)
    SELECT INSERTED.userID, INSERTED.mail, INSERTED.name, INSERTED.DoB, INSERTED.sex, INSERTED.password FROM INSERTED
END

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

  IF @submission_count IS NULL OR @submission_count = 0
  BEGIN
    SELECT 'Sinh vien chua nop bai nao'
  END
  ELSE
  BEGIN
    SELECT CONCAT('Sinh vien da nop ', @submission_count, ' bai')
  END;
END;

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
END; 

CREATE OR ALTER PROCEDURE DeleteUnusedProfessor
AS
BEGIN
  DELETE FROM Professor
  WHERE ProfID NOT IN (SELECT ProfID FROM Class)
END;


CREATE OR ALTER PROCEDURE UpdateMissingStuWorkScores (@CurDATE DATETIME)
AS
BEGIN
  DECLARE @testID INT;
  DECLARE @stuID VARCHAR(9);
  DECLARE @classID INT;
  DECLARE @timesID INT;
  DECLARE test_cursor CURSOR FOR
    SELECT TestID, ClassID
    FROM Test
    WHERE Deadline < @CurDATE;

  OPEN test_cursor;

  FETCH NEXT FROM test_cursor INTO @testID, @classID;
  WHILE @@FETCH_STATUS = 0
  BEGIN
    DECLARE student_cursor CURSOR FOR
      SELECT StuID
      FROM Study
      WHERE ClassID = @classID
      AND NOT EXISTS (
        SELECT 1
        FROM StuWork
        WHERE TestID = @testID AND StuID = Study.StuID
      );

    OPEN student_cursor;

    FETCH NEXT FROM student_cursor INTO @stuID;
    WHILE @@FETCH_STATUS = 0
    BEGIN
      SET @timesID = 1;
      INSERT INTO StuWork (StuID, TestID, TimesID, Score)
      VALUES (@stuID, @testID, @timesID, 0);

      FETCH NEXT FROM student_cursor INTO @stuID;
    END;

    CLOSE student_cursor;
    DEALLOCATE student_cursor;
    FETCH NEXT FROM test_cursor INTO @testID, @classID;
  END;

  CLOSE test_cursor;
  DEALLOCATE test_cursor;
END;

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
END;

CREATE OR ALTER PROCEDURE Update_professor(
    @ProfID VARCHAR(9),
    @mail VARCHAR(255),
    @name VARCHAR(255),
    @DoB DATE,
    @sex VARCHAR(10),
    @Degree VARCHAR(255)
)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM UserTable WHERE userID = @ProfID)
    BEGIN
        UPDATE UserTable
        SET mail = @mail,
            name = @name,
            DoB = @DoB,
            sex = @sex
        WHERE userID = @ProfID;
        UPDATE Professor
        SET Degree = @Degree
        WHERE ProfID = @ProfID;
        PRINT 'Professor information updated successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Professor not found in the database.';
    END
END;

CREATE OR ALTER PROCEDURE Insert_professor(
    @mail VARCHAR(255),
    @name VARCHAR(255),
    @DoB DATE,
    @sex VARCHAR(10),
    @Degree VARCHAR(255)
)
AS
BEGIN
    DECLARE @ProfID VARCHAR(9);

    -- Get the largest professor ID from the database
    SELECT TOP 1 @ProfID = userID
    FROM UserTable
    WHERE userID LIKE 'GV%'
    ORDER BY CAST(RIGHT(userID, 2) AS INT) DESC;

    -- Increment the two-digit number by one
    IF @ProfID IS NOT NULL
    BEGIN
        SET @ProfID = 'GV' + RIGHT('0' + CAST(CAST(RIGHT(@ProfID, 2) AS INT) + 1 AS VARCHAR), 2);
    END
    ELSE
    BEGIN
        -- If no existing professor IDs found, start with GV01
        SET @ProfID = 'GV01';
    END

    -- Insert into UserTable
    INSERT INTO UserTable (userID, mail, name, DoB, sex)
    VALUES (@ProfID, @mail, @name, @DoB, @sex);

    -- Insert into Professor
    INSERT INTO Professor (ProfID, Degree)
    VALUES (@ProfID, @Degree);
END;

CREATE OR ALTER PROCEDURE DeleteProfessor
    @ProfID VARCHAR(9)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM UserTable WHERE userID = @ProfID)
    BEGIN
        DELETE FROM Professor WHERE ProfID = @ProfID;
        DELETE FROM UserTable WHERE userID = @ProfID;
        PRINT 'Professor deleted successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Professor not found in the database.';
    END
END;
