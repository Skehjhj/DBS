DROP PROCEDURE IF EXISTS arange_student_on_score;
DELIMITER $$
CREATE PROCEDURE arange_student_on_score(
  IN input_semester_id INT
)
BEGIN 

SELECT
    s.StuID,
    s.Avg_Score,
    s.name
FROM
    Study s
JOIN
    UserTable u ON u.userID = s.StuID
JOIN
    Class c ON s.ClassID = c.ClassID
JOIN
    Semester sem ON c.SemesterID = sem.SemesterID
WHERE
    sem.SemesterID = @input_semester_id
ORDER BY
    s.Avg_Score DESC;
END;

DELIMITER ;


--AI Gen 1 số code só j tham khảo


--xem 1 học sinh đk môn gì--
DELIMITER $$
CREATE PROCEDURE get_course_enroll(
  @user_id CHAR(9)
)
BEGIN
  SELECT c.CourseID
  FROM Class AS c
  JOIN Study AS s ON s.ClassID = c.ClassID
  WHERE s.StuID = @user_id
  ORDER BY c.CourseID ASC;
END $$
DELIMITER ;

DROP TABLE IF EXISTS highest_scores;
CREATE TEMPORARY TABLE highest_scores (
    StuID INT, 
    TestID INT,
    Score INT
);
INSERT INTO highest_scores (StuID, TestID, Score)
SELECT S.StuID, T.TestID, MAX(S.Score)
FROM Students AS S
INNER JOIN Tests AS T ON T.TestID = S.TestID
GROUP BY S.StuID, T.TestID;

DROP TABLE IF EXISTS tests_to_mark_columns;
CREATE TEMPORARY TABLE tests_to_mark_columns (
    TestID INT, 
    CourseID INT,
    Percentage INT
);
INSERT INTO tests_to_mark_columns (TestID, CourseID)
SELECT T.TestID, MC.CourseID
FROM Tests AS T
INNER JOIN Class AS C ON T.ClassID = C.ClassID
INNER JOIN MarkingColumns AS MC ON C.CourseID = MC.CourseID;

--bang
/*
SELECT HS.StuID, MC.CourseID
FROM highest_scores AS HS
INNER JOIN tests_to_mark_columns AS TMC ON HS.TestID = TMC.TestID
INNER JOIN MarkColumns AS MC ON TMC.CourseID = MC.CourseID
WHERE HS.StuID = @user_id;
*/

DROP TRIGGER IF EXISTS update_avg_score;
DELIMITER //
CREATE TRIGGER update_avg_score
ON Study s
AFTER INSERT, DELETE, UPDATE
FOR EACH ROW
BEGIN
  SELECT s.StuID, SUM(hs.Score * TMC.Percentage / 100) AS avg_score
  FROM highest_scores AS hs
  INNER JOIN tests_to_mark_columns AS TMC ON hs.TestID = TMC.TestID
  WHERE hs.StuID = s.StuID
  GROUP BY s.StuID;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS add_user;
DELIMITER //
CREATE PROCEDURE add_user(
  IN userID CHAR(9),
  IN name VARCHAR(255),
  IN mail VARCHAR(255),
  IN DoB DATE,
  IN Sex VARCHAR(10),
  IN password VARCHAR(255)
)
BEGIN
  IF Sex NOT IN ('Male', 'Female') THEN
  SELECT 'Gioi tinh khong hop le';
  END IF;

  DECLARE check_mail BOOLEAN;
  SET check_mail = LOCATE('@hcmut.edu.vn', mail) > 0;

  IF check_mail != 1 THEN
  SELECT 'Email khong hop le';
  END IF;

  INSERT INTO UserTable (userID, name, mail, DoB, Sex, password)
  VALUES (userID, name, mail, DoB, Sex, password);
END //
DELIMITER ;

--kiểm tra sv nộp bài chưa--
DELIMITER $$

CREATE PROCEDURE check_student_submission_count(
  @student_id CHAR(9)
)
BEGIN

  DECLARE submission_count INT;
  DECLARE submission_cursor CURSOR FOR
    SELECT COUNT(*) AS submission_count
    FROM StuWork AS sw
    WHERE sw.student_id = @student_id;

  OPEN submission_cursor;
  FETCH submission_cursor INTO @submission_count;
  CLOSE submission_cursor;

  IF @submission_count IS NULL THEN
    SELECT 'Sinh viên này chưa nộp bài';
  ELSE
    SELECT CONCAT('Sinh viên này đã nộp ', @submission_count, ' bài');
  END IF;

END $$

DELIMITER ;


