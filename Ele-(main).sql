SET DATEFORMAT dmy;

CREATE      TABLE       UserTable (
  userID    INTEGER   PRIMARY KEY,
  mail      VARCHAR(255) (email LIKE '%@hcmut.edu.vn'),
  name      VARCHAR(255),
  DoB       DATE,
  sex       VARCHAR(10)
);

ALTER TABLE UserTable
ADD CONSTRAINT CK_Sex
CHECK (sex IN ('Male', 'Female'));


CREATE TABLE Message(
    MessageID INTEGER PRIMARY KEY,
    Content VARCHAR(255),
    SenderID INTEGER,
    CONSTRAINT fk_sender_user_SenderID FOREIGN KEY (SenderID) REFERENCES UserTable (userID),
);

CREATE TABLE Receiver(
  ReceiverID INTEGER,
  CONSTRAINT fk_receiver_user_ReceiverID FOREIGN KEY (ReceiverID) REFERENCES User (userID),
  MessageID INTEGER,
  CONSTRAINT fk_receiver_message_MessageID FOREIGN KEY (MessageID) REFERENCES Message (MessageID),
  ReceiveTime DATE
)

CREATE      TABLE       Professor (
  ProfID    INTEGER    PRIMARY KEY,
  CONSTRAINT   fk_prof_user_ProfID   FOREIGN KEY 
                            (ProfID) REFERENCES User (userID),
  Degree      VARCHAR(255),
);

CREATE      TABLE       Student (
  StuID    INTEGER     PRIMARY KEY,
  CONSTRAINT   fk_stu_user_StuID   FOREIGN KEY 
                            (StuID) REFERENCES User (userID),
  StuStatus     VARCHAR(255),
  Major        VARCHAR(255),
);

CREATE      TABLE       TA (
  StuID    INTEGER     PRIMARY KEY,
  CONSTRAINT   fk_admin_user_StuID   FOREIGN KEY 
                            (StuID) REFERENCES Student (StuID),
  ProfID    INTEGER     PRIMARY KEY,
  CONSTRAINT   fk_teach_prof_ProfID   FOREIGN KEY 
                            (ProfID) REFERENCES Professor (ProfID),
  WorkType       VARCHAR(255),
);


CREATE      TABLE      Class (
  ClassID    INTEGER     PRIMARY KEY,
  Classroom  CHAR(3),
  Capacity   INTEGER,
  TAID       INTEGER,
  CONSTRAINT   fk_class_ta_TAID   FOREIGN KEY 
                             (TAID) REFERENCES TA (ProfID),
  CourseID  CHAR(6),
  CONSTRAINT   fk_class_course_CourseID   FOREIGN KEY 
                            (CourseID) REFERENCES Course (CourseID),
  ProfID    INTEGER,
  CONSTRAINT   fk_class_prof_ProfID   FOREIGN KEY 
                            (ProfID) REFERENCES Professor (ProfID),
);

/*
CREATE TABLE DatetoLearn(

)
*/

CREATE TABLE Semester(
    SemesterID INTEGER PRIMARY KEY,
    StartDate DATE,
    EndDate DATE,
);

CREATE      TABLE       Course (
  CourseID  CHAR(6)     PRIMARY KEY,
  Name      VARCHAR(255),
  Howtomark     VARCHAR(255),
  Credit     INTEGER,
  SemesterID        INTEGER,
  CONSTRAINT   fk_course_semester_SemesterID   FOREIGN KEY
                            (SemesterID) REFERENCES Semester (SemesterID),
  Prerequisites CHAR(6)  REFERENCES Course (CourseID),
  MinAttendance  INTEGER,
);

CREATE      TABLE       Teach (
  ProfID    INTEGER,
  CONSTRAINT   fk_teach_prof_ProfID   FOREIGN KEY 
                            (ProfID) REFERENCES Professor (ProfID),
  CourseID  CHAR(6),
  CONSTRAINT   fk_teach_course_CourseID   FOREIGN KEY 
                            (CourseID) REFERENCES Course (CourseID),
  CONSTRAINT pk_teach PRIMARY KEY (ProfID, CourseID)
);


--?---

CREATE TABLE Test(
    TestID INTEGER PRIMARY KEY,
    SendStatus BIT,
    MarkStatus BIT,
    TestType VARCHAR(255),
    DoTime TIME,
    Deadline DATE,
    Score INTEGER,
    ClassID  INTEGER,
    CONSTRAINT fk_test_class_ClassID FOREIGN KEY 
                            (ClassID) REFERENCES Class (ClassID)
);

CREATE TABLE QuizBank(
  QuizID INTEGER PRIMARY KEY,
  --TypeofQ VARCHAR(255), T nghi bh chi dung multiple choice thoi
  Context VARCHAR(255),
  Answer CHAR(1), 
);

ALTER TABLE QuizBank
ADD CONSTRAINT CK_Anwser
CHECK (Answer IN ('A', 'B', 'C', 'D', 'E'));


CREATE TABLE Quiz(
  TestID INTEGER PRIMARY KEY,
  CONSTRAINT fk_quiz_test_TestID FOREIGN KEY 
                          (TestID) REFERENCES Test (TestID),
  --Chua chay thu--               
  QuizID INTEGER[],
  CONSTRAINT fk_quiz_quizbank_QuizID FOREIGN KEY 
                (QuizID) REFERENCES QuizBank (QuizID),
  Answer CHAR[],
  CONSTRAINT fk_quiz_quizbank_Answer FOREIGN KEY 
                (Answer) REFERENCES QuizBank (Answer),
);

CREATE TABLE StuWork(
  StuID INTEGER REFERENCES Student (StuID),
  TestID INTEGER REFERENCES Test (TestID),
  TimesID INTEGER,
  PRIMARY KEY (StuID, TestID, TimesID),
  StuWork VARCHAR(255),
  DoneTime DATE,
  Score INTEGER,
);

ALTER TABLE Test(
  CONSTRAINT fk_test_score FOREIGN KEY (Score)
  REFERENCES StuWork (Score)
);

--- Continues ---

CREATE TABLE Study(
    StuID CHAR(6) REFERENCES Student (StuID),
    ClassID INTEGER REFERENCES Class (ClassID),
    CONSTRAINT pk_study PRIMARY KEY (StuID, ClassID)
);


