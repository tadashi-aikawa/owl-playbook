-- deno_mysqlを動かさないなら WITH 'mysql_native_password' は不要
CREATE USER 'user'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'user'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

CREATE TABLE users (
    id int NOT NULL,
    name varchar(255) NOT NULL,
    date date,
    datetime datetime,
    bool boolean
) ENGINE=InnoDB;

INSERT INTO users VALUES
  (1,'one','2024-11-26', '2024-11-26 00:03:00', true),
  (2,'two', NULL, NULL, false),
  (3,'three', NULL, NULL, NULL);
