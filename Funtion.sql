SELECT
    s.StuID,
    --c.SemesterID,--
    s.Avg_Score,
    u.name
FROM
    Study s
JOIN
    Class c ON s.ClassID = c.ClassID
JOIN
    Semester sem ON c.SemesterID = sem.SemesterID
WHERE
    sem.SemesterID = :input_semester_id
JOIN
    UserTable u ON u.userID = s.StuID
ORDER BY
    s.Avg_Score DESC;


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

CREATE TABLE highest_scores (
    StuID INT,
    TestID INT,
    Score INT,
    PRIMARY KEY (StuID, TestID)
);

-- Chọn các bài làm có điểm cao nhất và chèn vào bảng mới
INSERT INTO highest_scores (StuID, TestID, Score)
SELECT StuID, TestID, MAX(Score)
FROM StuWork
GROUP BY StuID, TestID;

/*

-tìm diem trung binh cua 1 giang vien--
DELIMITER $$

CREATE PROCEDURE get_average_course_scores_by_instructor(
  @instructor_id INT
)
BEGIN

  SELECT c.course_name, AVG(s.score) AS average_score
  FROM courses AS c
  JOIN assignments AS a ON c.course_id = a.course_id
  JOIN submissions AS s ON a.assignment_id = s.assignment_id
  WHERE a.instructor_id = @instructor_id
  GROUP BY c.course_name
  HAVING AVG(s.score) >= 70
  ORDER BY average_score DESC;

END $$

DELIMITER ;


--tính điểm trung bình sv--
DELIMITER $$

CREATE PROCEDURE calculate_student_average_score(
  @student_id INT
)
BEGIN

  DECLARE student_average DECIMAL(10,2);
  DECLARE total_score DECIMAL(10,2);
  DECLARE assignment_count INT;
  DECLARE assignment_score DECIMAL(10,2);
  DECLARE assignment_cursor CURSOR FOR
    SELECT a.assignment_name, s.score
    FROM assignments AS a
    JOIN submissions AS s ON a.assignment_id = s.assignment_id
    WHERE s.student_id = @student_id;

  OPEN assignment_cursor;

  LOOP
    FETCH assignment_cursor INTO @assignment_name, @assignment_score;

    IF @assignment_score IS NULL THEN
      SET total_score = total_score;
      SET assignment_count = assignment_count;
    ELSE
      SET total_score = total_score + @assignment_score;
      SET assignment_count = assignment_count + 1;
    END IF;

    IF assignment_count = 0 THEN
      SET student_average = NULL;
    ELSE
      SET student_average = total_score / assignment_count;
    END IF;

    UPDATE students
    SET average_score = student_average
    WHERE student_id = @student_id;
  END LOOP;

  CLOSE assignment_cursor;

END $$

DELIMITER ;


--kiểm tra sv nộp bài chưa--
DELIMITER $$

CREATE PROCEDURE check_student_submission_count(
  @student_id INT
)
BEGIN

  DECLARE submission_count INT;
  DECLARE submission_cursor CURSOR FOR
    SELECT COUNT(*) AS submission_count
    FROM submissions AS s
    WHERE s.student_id = @student_id;

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

*/
