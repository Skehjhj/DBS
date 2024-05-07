insert into UserTable (userID, mail, name, DoB, sex) values ('GV01', 'lbaldick0@hcmut.edu.vn', 'Libbie Baldick', '28-08-2003', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV02', 'dhartegan1@hcmut.edu.vn', 'Devy Hartegan', '17-12-2004', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV03', 'vpurkis2@hcmut.edu.vn', 'Vinny Purkis', '28-03-2003', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV04', 'jjozefczak3@hcmut.edu.vn', 'Janos Jozefczak', '26-11-2002', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('GV05', 'nrichichi4@hcmut.edu.vn', 'Nina Richichi', '29-08-2004', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV01', 'pwelbrocka@hcmut.edu.vn', 'Pierette Welbrock', '06-07-2001', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV02', 'bsaltmanb@hcmut.edu.vn', 'Belicia Saltman', '23-01-2001', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV03', 'celcomec@hcmut.edu.vn', 'Carlynne Elcome', '29-05-2003', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV04', 'icorbend@hcmut.edu.vn', 'Irene Corben', '04-03-2001', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV05', 'alivzeye@hcmut.edu.vn', 'Augy Livzey', '13-02-2003', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV06', 'lzeplinf@hcmut.edu.vn', 'Lucien Zeplin', '11-01-2001', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV07', 'bloggg@hcmut.edu.vn', 'Bryant Logg', '24-10-2000', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV08', 'olampardh@hcmut.edu.vn', 'Oberon Lampard', '16-02-2001', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV09', 'rroxburghi@hcmut.edu.vn', 'Rinaldo Roxburgh', '11-10-2003', 'Male');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV10', 'abusainj@hcmut.edu.vn', 'Amandy Busain', '17-07-2000', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV11', 'abusaij@hcmut.edu.vn', 'Amand Busain', '17-06-2000', 'Female');
insert into UserTable (userID, mail, name, DoB, sex) values ('SV12', 'abusai@hcmut.edu.vn', 'Amand Busai', '17-06-2000', 'Female');


UPDATE UserTable
SET password = '1234567';


insert into Message (MessageID, Content, SenderID) values (1, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'GV01');
insert into Message (MessageID, Content, SenderID) values (2, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'SV01');
insert into Message (MessageID, Content, SenderID) values (3, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'SV02');
insert into Message (MessageID, Content, SenderID) values (4, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 'GV02');
insert into Message (MessageID, Content, SenderID) values (5, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'SV03');


insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV01', 1, '21-08-2023');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV02', 2, '02-04-2024');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('GV01', 3, '20-09-2023');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('GV03', 4, '19-01-2024');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV05', 5, '03-09-2023');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV02', 1, '09-11-2023');
insert into Receiver (ReceiverID, MessageID, ReceiveTime) values ('SV05', 2, '30-04-2023');


insert into Professor (ProfID, Degree) values ('GV01', 'M.S.');
insert into Professor (ProfID, Degree) values ('GV02', 'M.S.');
insert into Professor (ProfID, Degree) values ('GV03', 'Ph.D');
insert into Professor (ProfID, Degree) values ('GV04', 'Ph.D');
insert into Professor (ProfID, Degree) values ('GV05', 'Bachelor');

insert into Student (StuID, DateJoin, Major, Program) values ('SV01', '07/03/2023', 'Psychology', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV02', '07/08/2021', 'English Literature', 'CLC');
insert into Student (StuID, DateJoin, Major, Program) values ('SV03', '09/10/2020', 'Psychology', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV04', '06/09/2020', 'Business Administration', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV05', '02/10/2019', 'Computer Science', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV06', '28/06/2019', 'Psychology', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV07', '10/10/2021', 'Computer Science', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV08', '16/09/2019', 'Engineering', 'CLC');
insert into Student (StuID, DateJoin, Major, Program) values ('SV09', '10/06/2022', 'Mathematics', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV10', '22/07/2020', 'Computer Science', 'VHVL');
insert into Student (StuID, DateJoin, Major, Program) values ('SV11', '10/06/2022', 'Mathematics', 'DT');
insert into Student (StuID, DateJoin, Major, Program) values ('SV12', '10/06/2022', 'Mathematics', 'DT');

insert into Semester (SemesterID, StartDate, EndDate) values (211, '05-09-2011', '31-12-2011');
insert into Semester (SemesterID, StartDate, EndDate) values (212, '01-01-2022', '21-06-2022');
insert into Semester (SemesterID, StartDate, EndDate) values (213, '22-06-2022', '02-09-2022');
insert into Semester (SemesterID, StartDate, EndDate) values (221, '05-09-2022', '31-12-2022');
insert into Semester (SemesterID, StartDate, EndDate) values (222, '01-01-2023', '21-06-2023');
insert into Semester (SemesterID, StartDate, EndDate) values (223, '22-06-2023', '02-09-2023');

INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('ART606', N'Photography Basics', 2, null);
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('ENG303', N'Digital Marketing Strategies', 4, null);
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('MAT202', N'Advanced Calculus', 3, null);
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('PHI808', N'Music Theory Fundamentals', 3, null);
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('BUS707', N'Nutrition and Wellness', 4, 'PHI808');
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('CSE101', N'Introduction to Psychology', 1, 'MAT202');
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('CHE101', N'Business Ethics', 1, 'CSE101');
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('SCI505', N'History of Ancient Civilizations', 1, 'ART606');
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('HIS404', N'Creative Writing Workshop', 2, 'SCI505');
INSERT INTO Course (CourseID, Name, Credit, Prerequisites) VALUES ('MUS909', N'Introduction to Computer Science', 4, 'CHE101');

insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (1, 223, 'L01', 'CHE101', 'GV01');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (2, 223, 'L02', 'CHE101', 'GV01');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (3, 223, 'L03', 'CHE101', 'GV01');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (4, 223, 'L01', 'ART606', 'GV03');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (5, 223, 'L01', 'BUS707', 'GV01');
insert into Class (ClassID, SemesterID, Classroom, CourseID, ProfID) values (6, 223, 'L01', 'SCI505', 'GV03');
UPDATE Class
Set Status = 'Ongoing'

insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (1, 'Proposal_2021', 'Newsletter', 'https://hud.gov', 1, 'Wenona');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (2, 'Report_Q3', 'Presentation', 'https://illinois.edu', 2, 'Olimpia');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (3, 'Presentation_Final', 'Manual', 'https://taobao.com', 3, 'Kare');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (4, 'Invoice_12345', 'Newsletter', 'http://umich.edu', 4, 'Kelcie');
insert into Document (DocID, DocName, DocType, Docpath, ClassID, Author) values (5, 'Agreement_Template', 'Report', 'http://w3.org', 5, 'Davidde');

insert into QuizBank (QuizID, Context, Answer) values (1, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'D');
insert into QuizBank (QuizID, Context, Answer) values (2, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (3, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula', 'B');
insert into QuizBank (QuizID, Context, Answer) values (4, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (5, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (6, 'In congue. Etiam justo. Etiam pretium iaculis justo.', 'A');
insert into QuizBank (QuizID, Context, Answer) values (7, 'In congue. Etiam justo. Etiam pretium iaculis justo.', 'B');
insert into QuizBank (QuizID, Context, Answer) values (8, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (9, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', 'C');
insert into QuizBank (QuizID, Context, Answer) values (10, 'Quisque id justo sit amet', 'D');

insert into Study (StuID, ClassID) values ('SV01', 1);
insert into Study (StuID, ClassID) values ('SV02', 1);
insert into Study (StuID, ClassID) values ('SV03', 1);
insert into Study (StuID, ClassID) values ('SV04', 1);
insert into Study (StuID, ClassID) values ('SV05', 2);
insert into Study (StuID, ClassID) values ('SV06', 2);
insert into Study (StuID, ClassID) values ('SV07', 2);
insert into Study (StuID, ClassID) values ('SV08', 2);
insert into Study (StuID, ClassID) values ('SV09', 3);
insert into Study (StuID, ClassID) values ('SV10', 3);
insert into Study (StuID, ClassID) values ('SV11', 3);
insert into Study (StuID, ClassID) values ('SV12', 3);

insert into Study (StuID, ClassID) values ('SV01', 4);
insert into Study (StuID, ClassID) values ('SV02', 4);

insert into Study (StuID, ClassID) values ('SV03', 5);
insert into Study (StuID, ClassID) values ('SV04', 5);
insert into Study (StuID, ClassID) values ('SV05', 5);
insert into Study (StuID, ClassID) values ('SV06', 5);
insert into Study (StuID, ClassID) values ('SV07', 5);
insert into Study (StuID, ClassID) values ('SV08', 5);
insert into Study (StuID, ClassID) values ('SV09', 5);
insert into Study (StuID, ClassID) values ('SV10', 5);
insert into Study (StuID, ClassID) values ('SV11', 5);
insert into Study (StuID, ClassID) values ('SV12', 5);

insert into Study (StuID, ClassID) values ('SV01', 6);
insert into Study (StuID, ClassID) values ('SV02', 6);
insert into Study (StuID, ClassID) values ('SV03', 6);
insert into Study (StuID, ClassID) values ('SV04', 6);
insert into Study (StuID, ClassID) values ('SV05', 6);
insert into Study (StuID, ClassID) values ('SV06', 6);
insert into Study (StuID, ClassID) values ('SV07', 6);
insert into Study (StuID, ClassID) values ('SV08', 6);
insert into Study (StuID, ClassID) values ('SV09', 6);
insert into Study (StuID, ClassID) values ('SV10', 6);
insert into Study (StuID, ClassID) values ('SV11', 6);
insert into Study (StuID, ClassID) values ('SV12', 6);

INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (1, 1, '2024-21-06 00:00:00.000', N'Test4', N'Final');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (2, 2, '2024-21-06 00:00:00.000', N'Test1', N'Final');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (3, 3, '2024-21-06 00:00:00.000', N'Test2', N'Final');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (4, 4, '2024-21-06 00:00:00.000', N'Test5', N'Final');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (5, 4, '2024-21-06 00:00:00.000', N'Test4', N'Labs');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (6, 4, '2024-21-06 00:00:00.000', N'Test1', N'Midterm');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (7, 4, '2024-21-06 00:00:00.000', N'Test2', N'Tutorial');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (8, 5, '2024-21-06 00:00:00.000', N'Test3', N'Final');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (9, 5, '2024-21-06 00:00:00.000', N'Test2', N'Labs');
INSERT INTO Test (TestID, ClassID, Deadline, Test_name, MarkName) VALUES (10, 6, '2024-21-06 00:00:00.000', N'Test1', N'Final');


INSERT Into TestQuestions(TestID, QuestionID) VALUES (1, 1);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (1, 2);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (1, 3);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (1, 4);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (1, 5);

INSERT Into TestQuestions(TestID, QuestionID) VALUES (2, 6);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (2, 7);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (2, 8);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (2, 9);
INSERT Into TestQuestions(TestID, QuestionID) VALUES (2, 1);

insert into MarkColumns (CourseID, MarkName, Percentage) values ('ART606', 'Tutorial', 10);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('ART606', 'Labs', 20);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('ART606', 'Midterm', 30);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('ART606', 'Final', 40);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('BUS707', 'Labs', 20);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('BUS707', 'Final', 80);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('CHE101', 'Final', 100);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('CSE101', 'Final', 100);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('ENG303', 'Final', 100);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('HIS404', 'Final', 100);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('MAT202', 'Tutorial', 20);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('MAT202', 'Midterm', 40);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('MAT202', 'Final', 40);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('MUS909', 'Final', 100);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('PHI808', 'Midterm', 50);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('PHI808', 'Final', 50);
insert into MarkColumns (CourseID, MarkName, Percentage) values ('SCI505', 'Final', 100);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV01', 1, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 100);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV02', 1, 1, N'a', N'10:21:39.0000000', N'2024-04-20', 95);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV03', 1, 1, N'A', N'10:21:48.0000000', N'2024-04-20', 90);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV04', 1, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 85);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV05', 2, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 80);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV06', 2, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 75);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV07', 2, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 70);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV08', 2, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 75);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV09', 3, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 60);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV10', 3, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 55);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV11', 3, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 50);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV12', 3, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 45);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV01', 4, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 100);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV01', 5, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 100);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV01', 6, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 100);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV01', 7, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 100);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV02', 4, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 95);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV02', 5, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 95);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV02', 6, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 95);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV02', 7, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 95);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV03', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 90);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV03', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 90);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV04', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 85),
    (N'SV04', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 85);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV05', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 80),
    (N'SV05', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 80);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV06', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 75),
    (N'SV06', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 75);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV07', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 70),
    (N'SV07', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 70);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV08', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 65),
    (N'SV08', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 65);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV09', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 60),
    (N'SV09', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 60);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV10', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 55),
    (N'SV10', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 55);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV11', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 50),
    (N'SV11', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 50);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) 
VALUES 
    (N'SV12', 8, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 45),
    (N'SV12', 9, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 45);

INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV01', 10, 1, N'A', N'10:19:54.0000000', N'2024-04-20', 100);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV02', 10, 1, N'a', N'10:21:39.0000000', N'2024-04-20', 95);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV03', 10, 1, N'A', N'10:21:48.0000000', N'2024-04-20', 90);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV04', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 85);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV05', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 80);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV06', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 75);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV07', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 70);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV08', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 75);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV09', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 60);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV10', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 55);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV11', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 50);
INSERT INTO StuWork (StuID, TestID, TimesID, StuWork, DoTime, DoneTime, Score) VALUES (N'SV12', 10, 1, N'A', N'10:21:49.0000000', N'2024-04-20', 45);

