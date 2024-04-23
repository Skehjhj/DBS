
SELECT fn_CalculateAssignmentCompletionRate(123);

CREATE FUNCTION fn_GetStudentsWithCompletedAssignments(@CourseID INT)
RETURNS TABLE
AS
BEGIN
    -- Tạo bảng tạm thời để lưu trữ danh sách học viên
    CREATE TABLE #CompletedStudents (
        StudentID INT,
        FullName NVARCHAR(255)
    );

    -- Khai báo con trỏ để duyệt qua kết quả truy vấn
    DECLARE @StudentCursor CURSOR FOR
        SELECT StudentID, FullName FROM dbo.Students;

    -- Mở con trỏ
    OPEN @StudentCursor;

    -- Duyệt qua danh sách học viên
    FETCH NEXT FROM @StudentCursor INTO @StudentID, @FullName;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Kiểm tra xem học viên đã hoàn thành tất cả bài tập hay chưa
        IF (SELECT COUNT(*) FROM dbo.StudentAssignments
            WHERE StudentID = @StudentID AND CourseID = @CourseID AND Status = 'Completed')
            = (SELECT COUNT(*) FROM dbo.Assignments WHERE CourseID = @CourseID)
        BEGIN
            -- Thêm học viên vào bảng tạm thời
            INSERT INTO #CompletedStudents (StudentID, FullName)
            VALUES (@StudentID, @FullName);
        END;

        -- Lấy học viên tiếp theo
        FETCH NEXT FROM @StudentCursor INTO @StudentID, @FullName;
    END;

    -- Đóng con trỏ
    CLOSE @StudentCursor;

    -- Trả về bảng tạm thời chứa danh sách học viên đã hoàn thành
    SELECT * FROM #CompletedStudents;

    -- Xóa bảng tạm thời
    DROP TABLE #CompletedStudents;
END;



SELECT * FROM fn_GetStudentsWithCompletedAssignments(456);




