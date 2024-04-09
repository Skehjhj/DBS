CREATE      TABLE       TA (
  StuID    INTEGER     PRIMARY KEY,
  CONSTRAINT   fk_admin_user_StuID   FOREIGN KEY 
                            (StuID) REFERENCES Student (StuID),
  ProfID    INTEGER     PRIMARY KEY,
  CONSTRAINT   fk_teach_prof_ProfID   FOREIGN KEY 
                            (ProfID) REFERENCES Professor (ProfID),
   WorkType       VARCHAR(255),
);
insert into TA (TA_ID, WorkType) values (19, 'Lab Teacher');
insert into TA (TA_ID, WorkType) values (20, 'Assignment Grader');