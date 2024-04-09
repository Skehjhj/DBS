CREATE      TABLE       Professor (
    ProfID    INTEGER     PRIMARY KEY,
    CONSTRAINT   fk_prof_user_ProfID   FOREIGN KEY 
                            (ProfID) REFERENCES User (userID),
    Degree    VARCHAR(255),
);
insert into Professor (ProfID, Degree) values (1, 'M.S.');
insert into Professor (ProfID, Degree) values (2, 'M.S.');
insert into Professor (ProfID, Degree) values (3, 'Ph.D');
insert into Professor (ProfID, Degree) values (4, 'M.S');
insert into Professor (ProfID, Degree) values (5, 'Ph.D');
insert into Professor (ProfID, Degree) values (6, 'Bachelor');
insert into Professor (ProfID, Degree) values (7, 'Bachelor');
insert into Professor (ProfID, Degree) values (8, 'M.S.');
insert into Professor (ProfID, Degree) values (9, 'Bachelor');
insert into Professor (ProfID, Degree) values (10, 'Bachelor');
insert into Professor (ProfID, Degree) values (11, 'Bachelor');
insert into Professor (ProfID, Degree) values (12, 'M.S.');
insert into Professor (ProfID, Degree) values (13, 'M.S.');
insert into Professor (ProfID, Degree) values (14, 'Bachelor');
insert into Professor (ProfID, Degree) values (15, 'Ph.D');
insert into Professor (ProfID, Degree) values (16, 'M.S.');
insert into Professor (ProfID, Degree) values (17, 'Ph.D');
insert into Professor (ProfID, Degree) values (18, 'Ph.D');
insert into Professor (ProfID, Degree) values (19, 'Undergraduate');
insert into Professor (ProfID, Degree) values (20, 'Undergraduate');

