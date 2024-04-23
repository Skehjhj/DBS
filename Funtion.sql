USE lms_1

CREATE FUNCTION GetStudentSemesterAverageGrade(StuID INT, SemesterID INT)
RETURNS DECIMAL(3,2)
AS
BEGIN
    DECLARE @StudentGrades TABLE(
        CourseID INT,
        Grade DECIMAL(3,2)
    );

    INSERT INTO @StudentGrades
    SELECT CourseID, Grade
    FROM Grades
    WHERE StudentID = StuID AND SemesterID = SemesterID;

    DECLARE @AverageGrade DECIMAL(3,2);

    SELECT @AverageGrade = AVG(Grade)
    FROM @StudentGrades;

    RETURN @AverageGrade;
END;











--create funtion that arange all class that a professor teach arange from highest average score to lowest
DROP FUNCTION IF EXISTS ArrangeClassByAvgScore;
CREATE OR ALTER PROCEDURE ArrangeClassByAvgScore(@profID VARCHAR(9), @courseID CHAR(6))
RETURNS TABLE
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Class 
               WHERE ProfID = @profID AND CourseID = @courseID)
    BEGIN
        SELECT 'Giao vien khong day mon nay'
    END
END
SELECT ClassID, Classroom, AVG(Avg_Score) AS Avg_Score
FROM Study s
JOIN Class c ON s.ClassID = c.ClassID
WHERE ProfID = @profID
GROUP BY ClassID
ORDER BY Avg_Score DESC;

CREATE FUNCTION GetStudentsWithCompletedTest (@classID INT)
RETURNS TABLE(
		StuID VARCHAR(9),
		name VARCHAR(255)
	)
AS
BEGIN
	DECLARE StuID VARCHAR(9);
	DECLARE name VARCHAR(255);

	DECLARE @Stu CURSOR FOR
    SELECT StuID, name FROM Study s JOIN UserTable ut ON s.StuID = us.userID;

    OPEN @Stu;

    FETCH NEXT FROM @Stu INTO @StuID, @name;
	CLOSE @Stu;
	DEALLOCATE @Stu;
    IF (SELECT COUNT(*) FROM StuWork 
    WHERE StuID = @StuID AND TestID IN (SELECT TestID FROM Test WHERE ClassID = @classID)) = (SELECT COUNT(*) FROM Test WHERE ClassID = @classID)
        BEGIN
            INSERT INTO @ResultTable VALUES (@StuID, @name);
        END;
	END LOOP;

	CLOSE @Stu;
	RETURN @ResultTable
END;

SELECT * FROM GetStudentsWithCompletedTest(1)

INSERT INTO @CompletedTest
	SELECT s.StuID, ut.name
	FROM Study s
    JOIN UserTable ut ON s.StuID = ut.userID;
	WHERE EXISTS (
        SELECT 1
        FROM StuWork sw
        WHERE sw.StuID = s.StuID AND sw.TestID IN (
            SELECT TestID
            FROM Test
            WHERE ClassID = @classID
        )
    );
	SELECT *
    FROM @CompletedTest;
END;


SELECT StuID, name
    INTO CompletedTest
    FROM Study s
    JOIN UserTable ut ON s.StuID = ut.userID
    WHERE EXISTS (
        SELECT 1
        FROM StuWork sw
        WHERE sw.StuID = s.StuID AND sw.TestID IN (
            SELECT TestID
            FROM Test
            WHERE ClassID = @classID
        )
    );

    SELECT *
    FROM #CompletedTest;

    DROP TABLE #CompletedTest;
END;

CREATE FUNCTION dbo.GetSortedClassesByTeacher(@teacherID INT)
RETURNS TABLE
AS
BEGIN
    DECLARE @teacherClasses TABLE (
        ClassID INT,
        AverageScore DECIMAL(10,2)
    );

    INSERT INTO @teacherClasses
    SELECT c.ClassID, AVG(s.Score) AS AverageScore
    FROM Classes c
    INNER JOIN Enrollments e ON c.ClassID = e.ClassID
    INNER JOIN Students s ON e.StudentID = s.StudentID
    WHERE c.TeacherID = @teacherID
    GROUP BY c.ClassID;

    ... (rest of the function logic using @teacherClasses)
END;

CREATE FUNCTION fn_RemoveDuplicates(tableName VARCHAR(255))
RETURNS INT
BEGIN
    DECLARE done1 BOOL DEFAULT FALSE;
    DECLARE done2 BOOL DEFAULT FALSE;
    DECLARE recordId1 INT;
    DECLARE recordId2 INT;
    DECLARE recordValue1 VARCHAR(255);
    DECLARE recordValue2 VARCHAR(255);

    -- Mở con trỏ 1
    OPEN cursor cur_Records1 FOR
        SELECT recordId, value
        FROM tableName
        ORDER BY value;

    -- Lặp qua tất cả các bản ghi
    LOOP
        FETCH cur_Records1 INTO recordId1, recordValue1;

        -- Kiểm tra xem đã đến cuối con trỏ 1 hay chưa
        IF done1 THEN
            LEAVE LOOP;
        END IF;

        -- Mở con trỏ 2
        OPEN cursor cur_Records2 FOR
            SELECT recordId, value
            FROM tableName
            WHERE value = recordValue1;

        -- Lặp qua tất cả các bản ghi có cùng giá trị
        LOOP
            FETCH cur_Records2 INTO recordId2, recordValue2;

            -- Kiểm tra xem bản ghi tiếp theo có tồn tại hay không
            IF @@FETCH_STATUS() = 2 THEN
                LEAVE LOOP;
            END IF;

            -- Xóa bản ghi trùng lặp
            DELETE FROM tableName
            WHERE recordId = recordId2;
        END LOOP;

        -- Đóng con trỏ 2
        CLOSE cur_Records2;

        -- Kiểm tra xem bản ghi tiếp theo có tồn tại hay không
        IF @@FETCH_STATUS() = 2 THEN
            SET done1 = TRUE;
        END IF;
    END LOOP;

    -- Đóng con trỏ 


-- Function tinh tong so giao vien cua truong
2 CREATE OR REPLACE FUNCTION SUMOFTEACHERS
3 RETURN INT
4 AS
5 SUM_TEACHERS INT;
6 BEGIN
7 SELECT COUNT(*) INTO SUM_TEACHERS
8 FROM GIAOVIEN;
9
10 RETURN SUM_TEACHERS;
11 END;

CREATE FUNCTION GetStudentSemesterCourseCount(StuID INT, SemesterID INT)
RETURNS INT
AS
BEGIN
    DECLARE @CourseCount INT;

    SELECT @CourseCount = COUNT(*)
    FROM Enrollments
    WHERE StudentID = StuID AND SemesterID = SemesterID;

    RETURN @CourseCount;
END;


CREATE FUNCTION GetStudentClassRank(ClassID INT, StuID INT)
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @StudentAverage DECIMAL(3,2);
    DECLARE @StudentRank NVARCHAR(20);

    SELECT @StudentAverage = AVG(Grade)
    FROM Grades
    WHERE StudentID = StuID AND ClassID = ClassID;

    IF @StudentAverage >= 8 THEN
        SET @StudentRank = 'Giỏi';
    ELSE
        SET @StudentRank = 'Trung bình';
    END IF;

    RETURN @StudentRank;
END;

https://drive.google.com/file/d/1mLXN_ZYbvTjCWxvo8iXkCC7VlZ4wzB7P/view?fbclid=IwAR2A3_32yKFx1XvdmPZfD9YcKhKbqqsCE-OhngamkqAaiagcC3h2gwPFHeY