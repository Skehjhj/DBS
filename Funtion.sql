EXEC arange_student_on_score 6
EXEC get_course_enroll SV01
EXEC GetScholarshipStudents 223
EXEC check_student_submission_count 'SV01', 1
EXEC ArrangeClassByAvgScore GV01,  CHE101, 223

SELECT * FROM GetStudentsWithCompletedTest(1);
EXEC GetStudentsWithCompletedTest(1);

SELECT [dbo].CountStudentsAboveScore(80, 6)
EXEC DeleteUnusedProfessor

EXECUTE [dbo].[UpdateClassStatus]
	@CurDATE = '2024-27-04',
	@SemesterID = 223

EXEC UpdateMissingStuWorkScores '2024-04-20';
select [dbo].GetStudentSemesterAverageGrade('SV01', 223)
EXEC UpdateProfessorDegree 'GV06', 'Ed.D'
EXEC Insert_professor 'GV07', 'gv07@hcmut.edu.vn', 'Truong My Lan', '1980-04-20', 'Female', null, null
