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




