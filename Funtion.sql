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

    