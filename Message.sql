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
);

INSERT INTO Message (MessageID, Content, SenderID) VALUES
    (1, 'Hello', 1),
    (2, 'How are you?', 6),
    (3, 'This is a message.', 31),
    (4, 'Testing.', 9),
    (5, 'Sample content.', 40),

INSERT INTO Receiver (ReceiverID, MessageID, ReceiveTime) VALUES
    (2, 1, '09-04-2024'),
    (3, 1, '09-04-2024'),
    (4, 1, '09-04-2024'),
    (5, 1, '09-04-2024'),
    (30, 2, '10-04-2024'),
    (31, 2, '10-04-2024'),
    (4, 3, '12-04-2024'),
    (6, 3, '12-04-2024'),
    (8, 3, '12-04-2024'),
    (31, 4, '14-04-2024'),
    (41, 5, '09-04-2024'),
    (42, 5, '09-04-2024'),
    (43, 5, '09-04-2024'),
