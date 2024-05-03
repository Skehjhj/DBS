insert into UserTable (userID, mail, name, DoB, sex) values ('GV06', 'lbaldick0@hcmut.edu.vn', 'Libbie Baldick', '28-08-2003', 'Female');
EXEC Insert_professor 'GV06', null, null, null, null, null, 'Ph.D'

SELECT * FROM Professor

EXEC Insert_professor 'P001', 'john.doe@hcmut.edu.vn', 'John Doe', '1990-01-01', 'Male', '1234567', 'PhD'

SELECT * FROM Professor

EXEC UpdateProfessorDegree 'GV06', 'Ed.D'

EXEC DeleteUnusedProfessor

SELECT * FROM Message

insert into Study (StuID, ClassID) values ('SV02', 2);
DELETE FROM Study Where StuID = 'SV02'
SELECT * FROM Class


INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES ('SV01', 10, 1, 'A', '10:19:54.0000000', '2024-04-20', 90);
SELECT * FROM UserTable

insert into UserTable (userID, mail, name, DoB, sex) values ('GV11', 'lbaldick0@gmail.com', 'Libbie Baldick', '28-08-2003', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV11', 'lbaldick0@hcmut.edu.vn', 'Libbie Baldick', '28-08-2003', 'haha');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV11', 'lbaldick0@hcmut.edu.vn', 'Libbie Baldick', '28-08-2003', 'Female');

EXECUTE [dbo].[arange_student_on_score]
  @ClassID = 1;

EXEC GetScholarshipStudents 223

EXECUTE [dbo].[check_student_submission_count]
  @student_id = 'SV11',
  @classID = 1;

insert into UserTable (userID, mail, name, DoB, sex) values ('SV13', 'abusai@hcmut.edu.vn', 'Amand Busai', '17-06-2000', 'Female');
insert into Student (StuID, DateJoin, Major, Program) values ('SV13', '07/03/2023', 'Psychology', 'DT');
insert into Study (StuID, ClassID) values ('SV13', 1);
EXECUTE [dbo].[check_student_submission_count]
  @student_id = 'SV13',
  @classID = 1;

SELECT * FROM StuWork Where StuID = 'SV11'

EXEC UpdateMissingStuWorkScores '2025-21-06 00:00:00.000'

SELECT dbo.CountStudentsAboveScore(80,1)

SELECT dbo.GetStudentSemesterAverageGrade('SV01',223)