DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

PRAGMA foreign_keys = ON;

CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
    lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    body TEXT NOT NULL,
    reply_id INTEGER ,

    FOREIGN KEY (reply_id) REFERENCES replies(id),
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname,lname)
VALUES
  ('Mikey','Hollander'),
  ('Vivian','Chen');

INSERT INTO
  questions (title,body,user_id)
VALUES
  ('Address ??','What is the address??',(SELECT id FROM users WHERE fname = 'Mikey' AND lname = 'Hollander')),
  ('Is there a microwave on campus?','I was promised there would be a microwave on campus. What gives?',(SELECT id FROM users WHERE fname = 'Vivian' AND lname = 'Chen')),
  ('room ??','What about the room??',(SELECT id FROM users WHERE fname = 'Mikey' AND lname = 'Hollander'));

INSERT INTO
  question_follows (user_id,question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Mikey' AND lname = 'Hollander'),
  (SELECT id FROM questions WHERE title = 'Address ??')),

  ((SELECT id FROM users WHERE fname = 'Vivian' AND lname = 'Chen'),
  (SELECT id FROM questions WHERE title = 'Is there a microwave on campus?'));

INSERT INTO
  replies (user_id,question_id,body,reply_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Mikey' AND lname = 'Hollander'),
  (SELECT id FROM questions WHERE title = 'Is there a microwave on campus?'),
  ("There is a microwave on campus. Its in the other room."),
  null),

  
  ((SELECT id FROM users WHERE fname = 'Vivian' AND lname = 'Chen'),
  (SELECT id FROM questions WHERE title = 'Address ??'),
  ("90 5th Ave, NewYork,NY,10011"),
  null),

  ((SELECT id FROM users WHERE fname = 'Vivian' AND lname = 'Chen'),
  (SELECT id FROM questions WHERE title = 'Is there a microwave on campus?'),
  ("..thank you"),
  (SELECT id FROM replies WHERE body = 'There is a microwave on campus. Its in the other room.'));


INSERT INTO
  question_likes (user_id,question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Mikey' AND lname = 'Hollander'),
  (SELECT id FROM questions WHERE title = 'Is there a microwave on campus?')),

  ((SELECT id FROM users WHERE fname = 'Vivian' AND lname = 'Chen'),
  (SELECT id FROM questions WHERE title = 'Address ??'));

