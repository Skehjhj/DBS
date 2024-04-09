CREATE TABLE Teach (
  ProfID    INTEGER,
  CourseID  CHAR(6)
  CONSTRAINT fk_teach_prof_ProfID FOREIGN KEY (ProfID) REFERENCES Professor (ProfID),
  CONSTRAINT fk_teach_course_CourseID FOREIGN KEY (CourseID) REFERENCES Course (CourseID),
  CONSTRAINT pk_teach PRIMARY KEY (ProfID, CourseID)
);

insert into Teach (ProfID, CourseID) values (1, 'BUS300');
insert into Teach (ProfID, CourseID) values (3, 'PSY250');
insert into Teach (ProfID, CourseID) values (17, 'ART150');
insert into Teach (ProfID, CourseID) values (16, 'ART150');
insert into Teach (ProfID, CourseID) values (4, 'ENG101');
insert into Teach (ProfID, CourseID) values (4, 'ART150');
insert into Teach (ProfID, CourseID) values (15, 'PSY250');
insert into Teach (ProfID, CourseID) values (4, 'CSC101');
insert into Teach (ProfID, CourseID) values (9, 'BUS300');
insert into Teach (ProfID, CourseID) values (19, 'CHE110');
insert into Teach (ProfID, CourseID) values (5, 'ENG101');
insert into Teach (ProfID, CourseID) values (10, 'CSC101');
insert into Teach (ProfID, CourseID) values (7, 'BUS300');
insert into Teach (ProfID, CourseID) values (6, 'MTH200');
insert into Teach (ProfID, CourseID) values (9, 'ENG101');
insert into Teach (ProfID, CourseID) values (11, 'ENG101');
insert into Teach (ProfID, CourseID) values (9, 'CSC101');
insert into Teach (ProfID, CourseID) values (14, 'ENG101');
insert into Teach (ProfID, CourseID) values (17, 'PHY201');
insert into Teach (ProfID, CourseID) values (19, 'PHY201');