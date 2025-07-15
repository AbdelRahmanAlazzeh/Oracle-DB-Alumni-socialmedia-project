-- db/schema/create_tables_and_constraints.sql
-- This script creates all tables for the Alumni socialmedia DB project
-- and defines their primary, foreign, and unique constraints.

-- 1- USERS Table
CREATE TABLE USERS (
    Adress          VARCHAR2(255)   DEFAULT NULL,
    Birthdate       DATE            DEFAULT NULL,
    Email           VARCHAR2(255)   NOT NULL,
    Enrollment_year DATE            DEFAULT NULL,
    First_name      VARCHAR2(255)   NOT NULL,
    Gender          VARCHAR2(255)   DEFAULT NULL,
    Graduation_year DATE            DEFAULT NULL,
    Last_name       VARCHAR2(255)   NOT NULL,
    Password        VARCHAR2(255)   NOT NULL,
    Phone_number    NUMBER          DEFAULT NULL,
    User_id         VARCHAR2(15)    NOT NULL,
    User_type       VARCHAR2(255)   NOT NULL,
    CONSTRAINT USERS_PK PRIMARY KEY (User_id)
);

-- Add UNIQUE constraint for Email, as noted in your documentation
ALTER TABLE USERS ADD CONSTRAINT USERS_UK1 UNIQUE (Email);

-- 6- GROUPS Table (Create before POSTS and MEMBERSHIPS as they reference it)
CREATE TABLE GROUPS (
    Group_description VARCHAR2(255) DEFAULT NULL,
    Group_id          NUMBER        NOT NULL,
    Group_name        VARCHAR2(255) NOT NULL,
    CONSTRAINT GROUPS_PK PRIMARY KEY (Group_id)
);

-- 3- PROFILES Table (References USERS)
CREATE TABLE PROFILES (
    Bio             VARCHAR2(255) DEFAULT NULL,
    Department      VARCHAR2(255) NOT NULL,
    Profile_id      NUMBER        NOT NULL,
    Skills          VARCHAR2(255) DEFAULT NULL,
    User_id         VARCHAR2(15)  NOT NULL,
    Profile_picture BLOB          DEFAULT NULL,
    CONSTRAINT PROFILES_PK PRIMARY KEY (Profile_id),
    CONSTRAINT PROFILES_FK1 FOREIGN KEY (User_id) REFERENCES USERS (User_id),
    CONSTRAINT PROFILES_UK UNIQUE (User_id) -- User can only have one profile
);

-- 4- EVENTS Table (References USERS)
CREATE TABLE EVENTS (
    Event_id        NUMBER        NOT NULL,
    Event_date      DATE          NOT NULL,
    Event_description VARCHAR2(255) NOT NULL,
    Event_location  VARCHAR2(255) NOT NULL,
    Event_name      VARCHAR2(255) NOT NULL,
    Event_Creator   VARCHAR2(15)  NOT NULL,
    CONSTRAINT EVENTS_PK PRIMARY KEY (Event_id),
    CONSTRAINT EVENTS_FK1 FOREIGN KEY (Event_Creator) REFERENCES USERS (User_id)
);

-- 2- MESSAGES Table (References USERS twice)
CREATE TABLE MESSAGES (
    Message_timestamp TIMESTAMP      NOT NULL,
    Message_content   VARCHAR2(1000) NOT NULL,
    Message_id        NUMBER         NOT NULL,
    Sender_id         VARCHAR2(15)   NOT NULL,
    Receiver_id       VARCHAR2(15)   NOT NULL,
    CONSTRAINT MESSAGES_PK PRIMARY KEY (Message_id),
    CONSTRAINT MESSAGES_FK1 FOREIGN KEY (Sender_id) REFERENCES USERS (User_id),
    CONSTRAINT MESSAGES_FK2 FOREIGN KEY (Receiver_id) REFERENCES USERS (User_id)
);

-- 5- FRIENDSHIPS Table (References USERS twice)
CREATE TABLE FRIENDSHIPS (
    Friendship_date   DATE          DEFAULT NULL,
    Friendship_status VARCHAR2(255) NOT NULL,
    User_id1          VARCHAR2(15)  NOT NULL,
    User_id2          VARCHAR2(15)  NOT NULL,
    CONSTRAINT FRIENDSHIPS_PK PRIMARY KEY (User_id1, User_id2),
    CONSTRAINT FRIENDSHIPS_FK1 FOREIGN KEY (User_id1) REFERENCES USERS (User_id),
    CONSTRAINT FRIENDSHIPS_FK2 FOREIGN KEY (User_id2) REFERENCES USERS (User_id)
);

-- 7- POSTS Table (References POSTS itself, USERS, and GROUPS)
CREATE TABLE POSTS (
    Post_timestamp TIMESTAMP      NOT NULL,
    Post_type      VARCHAR2(255)  NOT NULL,
    Post_id        NUMBER         NOT NULL,
    reply_id       NUMBER         DEFAULT NULL, -- Self-referencing for replies
    Creater_id     VARCHAR2(15)   NOT NULL,
    Likes          INTEGER        DEFAULT NULL,
    Group_id       NUMBER         DEFAULT NULL,
    CONSTRAINT POSTS_PK PRIMARY KEY (Post_id),
    CONSTRAINT POSTS_FK1 FOREIGN KEY (reply_id) REFERENCES POSTS (Post_id),
    CONSTRAINT POSTS_FK2 FOREIGN KEY (Creater_id) REFERENCES USERS (User_id),
    CONSTRAINT POSTS_FK3 FOREIGN KEY (Group_id) REFERENCES GROUPS (Group_id)
);

-- 8- MEMBERSHIPS Table (References GROUPS and USERS)
CREATE TABLE MEMBERSHIPS (
    Group_id       NUMBER       NOT NULL,
    Member_id      VARCHAR2(15) NOT NULL,
    Membership_date DATE         NOT NULL,
    CONSTRAINT MEMBERSHIPS_PK PRIMARY KEY (Group_id, Member_id),
    CONSTRAINT MEMBERSHIPS_FK1 FOREIGN KEY (Group_id) REFERENCES GROUPS (Group_id),
    CONSTRAINT MEMBERSHIPS_FK2 FOREIGN KEY (Member_id) REFERENCES USERS (User_id)
);

-- Optional: Add comments to tables and columns for better documentation
COMMENT ON TABLE USERS IS 'Stores user account information for the social network.';
COMMENT ON COLUMN USERS.User_id IS 'Unique identifier for each user.';
COMMENT ON COLUMN USERS.Email IS 'User''s email address, must be unique.';
-- ... continue for other tables and columns
