CREATE      TABLE       Student (
  StuID    INTEGER     PRIMARY KEY,
  CONSTRAINT   fk_stu_user_StuID   FOREIGN KEY 
                            (StuID) REFERENCES User (userID),
  StuStatus     VARCHAR(255),
  Major        VARCHAR(255),
);
insert into Student (StuID, StuStatus, Major) values (19, 'Active', 'Engineering');
insert into Student (StuID, StuStatus, Major) values (20, 'Active', 'English Literature');
insert into Student (StuID, StuStatus, Major) values (21, 'Suspended', 'Psychology');
insert into Student (StuID, StuStatus, Major) values (22, 'Graduated', 'Art History');
insert into Student (StuID, StuStatus, Major) values (23, 'Graduated', 'Mathematics');
insert into Student (StuID, StuStatus, Major) values (24, 'Active', 'English Literature');
insert into Student (StuID, StuStatus, Major) values (25, 'Active', 'History');
insert into Student (StuID, StuStatus, Major) values (26, 'Active', 'Mathematics');
insert into Student (StuID, StuStatus, Major) values (27, 'Active', 'History');
insert into Student (StuID, StuStatus, Major) values (28, 'Graduated', 'Engineering');
insert into Student (StuID, StuStatus, Major) values (29, 'Active', 'Sociology');
insert into Student (StuID, StuStatus, Major) values (30, 'Suspended', 'Art History');
insert into Student (StuID, StuStatus, Major) values (31, 'Active', 'History');
insert into Student (StuID, StuStatus, Major) values (32, 'Active', 'Psychology');
insert into Student (StuID, StuStatus, Major) values (33, 'Suspended', 'Computer Science');
insert into Student (StuID, StuStatus, Major) values (34, 'Active', 'Art History');
insert into Student (StuID, StuStatus, Major) values (35, 'Active', 'Art History');
insert into Student (StuID, StuStatus, Major) values (36, 'Active', 'Art History');
insert into Student (StuID, StuStatus, Major) values (37, 'Active', 'Biology');
insert into Student (StuID, StuStatus, Major) values (38, 'Active', 'History');
insert into Student (StuID, StuStatus, Major) values (39, 'Suspended', 'English Literature');
insert into Student (StuID, StuStatus, Major) values (40, 'Active', 'Psychology');
insert into Student (StuID, StuStatus, Major) values (41, 'Suspended', 'Mathematics');
insert into Student (StuID, StuStatus, Major) values (42, 'Active', 'Sociology');
insert into Student (StuID, StuStatus, Major) values (43, 'Active', 'Psychology');
insert into Student (StuID, StuStatus, Major) values (44, 'Active', 'Biology');
insert into Student (StuID, StuStatus, Major) values (45, 'On Leave', 'History');
insert into Student (StuID, StuStatus, Major) values (46, 'On Leave', 'History');
insert into Student (StuID, StuStatus, Major) values (47, 'Suspended', 'Computer Science');
insert into Student (StuID, StuStatus, Major) values (48, 'Graduated', 'English Literature');
insert into Student (StuID, StuStatus, Major) values (49, 'Active', 'Computer Science');
insert into Student (StuID, StuStatus, Major) values (50, 'Active', 'Engineering');
/*
insert into Student (StuID, StuStatus, Major) values (51, 'Graduated', 'Engineering');
insert into Student (StuID, StuStatus, Major) values (52, 'Suspended', 'Computer Science');
insert into Student (StuID, StuStatus, Major) values (53, 'Active', 'Engineering');
insert into Student (StuID, StuStatus, Major) values (54, 'Active', 'Mathematics');
insert into Student (StuID, StuStatus, Major) values (55, 'Active', 'Computer Science');
insert into Student (StuID, StuStatus, Major) values (56, 'Graduated', 'Biology');
insert into Student (StuID, StuStatus, Major) values (57, 'Active', 'Psychology');
insert into Student (StuID, StuStatus, Major) values (58, 'Active', 'Art History');
insert into Student (StuID, StuStatus, Major) values (59, 'Active', 'English Literature');
insert into Student (StuID, StuStatus, Major) values (60, 'Active', 'Sociology');
insert into Student (StuID, StuStatus, Major) values (61, 'Active', 'Engineering');
insert into Student (StuID, StuStatus, Major) values (62, 'Active', 'English Literature');
insert into Student (StuID, StuStatus, Major) values (63, 'Active', 'Computer Science');
insert into Student (StuID, StuStatus, Major) values (64, 'Suspended', 'Art History');
insert into Student (StuID, StuStatus, Major) values (65, 'On Leave', 'Art History');
insert into Student (StuID, StuStatus, Major) values (66, 'Suspended', 'Computer Science');
insert into Student (StuID, StuStatus, Major) values (67, 'On Leave', 'History');
insert into Student (StuID, StuStatus, Major) values (68, 'Active', 'Psychology');
insert into Student (StuID, StuStatus, Major) values (69, 'Active', 'History');
insert into Student (StuID, StuStatus, Major) values (70, 'Active', 'Art History');
insert into Student (StuID, StuStatus, Major) values (71, 'Active', 'Art History');
insert into Student (StuID, StuStatus, Major) values (72, 'Active', 'Biology');
insert into Student (StuID, StuStatus, Major) values (73, 'Active', 'History');
insert into Student (StuID, StuStatus, Major) values (74, 'On Leave', 'History');
insert into Student (StuID, StuStatus, Major) values (75, 'Active', 'Computer Science');
insert into Student (StuID, StuStatus, Major) values (76, 'On Leave', 'History');
insert into Student (StuID, StuStatus, Major) values (77, 'Active', 'Biology');
insert into Student (StuID, StuStatus, Major) values (78, 'Graduated', 'Biology');
insert into Student (StuID, StuStatus, Major) values (79, 'Active', 'History');
insert into Student (StuID, StuStatus, Major) values (80, 'Active', 'Business Administration');
insert into Student (StuID, StuStatus, Major) values (81, 'Suspended', 'Art History');
insert into Student (StuID, StuStatus, Major) values (82, 'On Leave', 'Mathematics');
insert into Student (StuID, StuStatus, Major) values (83, 'Graduated', 'Mathematics');
insert into Student (StuID, StuStatus, Major) values (84, 'Suspended', 'Biology');
insert into Student (StuID, StuStatus, Major) values (85, 'Active', 'History');
insert into Student (StuID, StuStatus, Major) values (86, 'Graduated', 'Biology');
insert into Student (StuID, StuStatus, Major) values (87, 'Active', 'Mathematics');
insert into Student (StuID, StuStatus, Major) values (88, 'On Leave', 'Computer Science');
insert into Student (StuID, StuStatus, Major) values (89, 'Active', 'Biology');
insert into Student (StuID, StuStatus, Major) values (90, 'Active', 'Mathematics');
insert into Student (StuID, StuStatus, Major) values (91, 'Graduated', 'English Literature');
insert into Student (StuID, StuStatus, Major) values (92, 'Suspended', 'Biology');
insert into Student (StuID, StuStatus, Major) values (93, 'Suspended', 'Psychology');
insert into Student (StuID, StuStatus, Major) values (94, 'Active', 'English Literature');
insert into Student (StuID, StuStatus, Major) values (95, 'Suspended', 'History');
insert into Student (StuID, StuStatus, Major) values (96, 'On Leave', 'Art History');
insert into Student (StuID, StuStatus, Major) values (97, 'Active', 'Art History');
insert into Student (StuID, StuStatus, Major) values (98, 'On Leave', 'Computer Science');
*/