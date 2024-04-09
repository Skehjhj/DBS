CREATE TABLE Class (
  ClassID    INTEGER PRIMARY KEY,
  Classroom  CHAR(3),
  Capacity   INTEGER,
  TA_ID      INTEGER,
  CourseID   CHAR(6),
  ProfID     INTEGER,

  CONSTRAINT fk_class_ta_TAID FOREIGN KEY (TA_ID) REFERENCES TA (TA_ID),
  CONSTRAINT fk_class_course_CourseID FOREIGN KEY (CourseID) REFERENCES Course (CourseID),
  CONSTRAINT fk_class_prof_ProfID FOREIGN KEY (ProfID) REFERENCES Professor (ProfID),

  -- Constraint to ensure that the ProfID and CourseID match in the Teach table
  CONSTRAINT fk_class_course_ProfID FOREIGN KEY (ProfID, CourseID) REFERENCES Teach (ProfID, CourseID)
);
INSERT INTO Class (ClassID, Classroom, Capacity, TA_ID, CourseID, ProfID)
VALUES (1, 'L01', 100, 19, 'BUS300', 1);

INSERT INTO Class (ClassID, Classroom, Capacity, TA_ID, CourseID, ProfID)
VALUES (2, 'L02', 100, 19, 'ART150', 17);

INSERT INTO Class (ClassID, Classroom, Capacity, TA_ID, CourseID, ProfID)
VALUES (3, 'L03', 100, 20, 'ENG101', 9);