CREATE TABLE Test (
    TestID INTEGER PRIMARY KEY,
    SendStatus BIT,
    MarkStatus BIT,
    TestType VARCHAR(255),
    DoTime DATETIME,
    Deadline DATE,
    Score INTEGER,
    ClassID INTEGER,
    CONSTRAINT fk_test_class_ClassID FOREIGN KEY (ClassID) REFERENCES Class (ClassID)
);

insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (1, 0, 0, 'Multiple Choice', '26-08-2023 16:27:42', '11-10-2023', 3, 1);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (2, 1, 1, 'Multiple Choice', '07-09-2023 10:29:14', '05-06-2023', 18, 1);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (3, 0, 0, 'Essay Exam', '01-08-2023 15:02:46', '09-04-2023', 36, 2);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (4, 1, 1, 'Essay Exam', '05-02-2024 15:10:54', '18-07-2023', 35, 1);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (5, 1, 0, 'Essay Exam', '29-03-2024 11:15:33', '13-04-2023', 52, 3);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (6, 1, 0, 'Essay Exam', '19-03-2024 15:47:01', '27-06-2023', 31, 3);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (7, 0, 0, 'Essay Exam', '14-11-2023 13:57:42', '28-05-2023', 90, 3);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (8, 0, 0, 'Multiple Choice', '13-02-2024 15:29:15', '11-04-2023', 21, 2);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (9, 0, 0, 'Multiple Choice', '10-07-2023 10:13:40', '14-08-2023', 59, 1);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (10, 1, 0, 'Essay Exam', '06-01-2024 13:00:35', '28-04-2023', 89, 1);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (11, 0, 0, 'Multiple Choice', '05-10-2023 13:52:49', '18-12-2023', 61, 3);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (12, 0, 1, 'Essay Exam', '20-05-2023 10:33:10', '04-02-2024', 27, 3);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (13, 1, 1, 'Essay Exam', '03-03-2024 15:41:28', '17-12-2023', 16, 3);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (14, 0, 1, 'Essay Exam', '15-01-2024 13:11:09', '29-11-2023', 88, 3);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (15, 1, 0, 'Multiple Choice', '07-07-2023 15:52:25', '27-06-2023', 66, 2);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (16, 1, 1, 'Multiple Choice', '04-06-2023 11:10:00', '10-03-2024', 100, 1);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (17, 1, 0, 'Multiple Choice', '30-06-2023 12:05:12', '03-10-2023', 6, 3);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (18, 0, 1, 'Essay Exam', '16-04-2023 12:38:34', '15-04-2023', 59, 2);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (19, 0, 0, 'Essay Exam', '05-05-2023 11:37:26', '21-05-2023', 12, 1);
insert into Test (TestID, SendStatus, MarkStatus, TestType, DoTime, Deadline, Score, ClassID) values (20, 0, 0, 'Multiple Choice', '15-11-2023 11:36:15', '28-08-2023', 69, 3);
