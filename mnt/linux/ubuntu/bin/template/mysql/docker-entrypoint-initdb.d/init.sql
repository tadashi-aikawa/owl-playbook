-- deno_mysqlを動かさないなら WITH 'mysql_native_password' は不要
CREATE USER 'user'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'user'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

CREATE TABLE types (
    `int` INT PRIMARY KEY,
    `varchar` VARCHAR(255) NOT NULL,
    `date` DATE,
    `time` TIME,
    `datetime` DATETIME,
    `timestamp` TIMESTAMP,
    `enum` ENUM('option1', 'option2', 'option3'),
    `bool` BOOLEAN
) ENGINE=InnoDB;

INSERT INTO types VALUES
  (
    1,
    'one',
    '2024-11-26',
    '11:22:33',
    '2024-11-26 00:03:00',
    '2024-11-26 00:03:01',
    'option1',
    true
  ),
  (
    2,
    'two',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
  );

CREATE TABLE pets (
    `id` VARCHAR(32) PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `stay` BOOLEAN NOT NULL,
    `price` INT,
    `joined_year` YEAR NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO pets
  (`id`, `name`, `stay`, `price`, `joined_year`)
VALUES
  ("tatsuwo", "タツヲ", 1, 9000, 2009),
  ("seikichi", "セイキチ", 1, 5000, 2007),
  ("masaharu", "マサハル", 1, 42000, 2021),
  ("mitarashi", "みたらし", 1, 44000, 2021),
  ("wanbe", "わんべえ", 1, 3000, 2010),
  ("hyosuke", "ヒョウスケ", 1, NULL, 2014),
  ("raizo", "ライゾウ", 1, NULL, 2014),
  ("robao", "ロバオ", 0, NULL, 1987),
  ("mimizo", "みみぞう", 0, NULL, 2004),
  ("mimiko", "みみこ", 0, NULL, 2006),
  ("momochi", "ももち", 0, NULL, 2019);

