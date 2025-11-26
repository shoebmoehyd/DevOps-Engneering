CREATE DATABASE IF NOT EXISTS appdb;
USE appdb;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE
);

INSERT INTO users (name, email) VALUES
  ('Shoeb', 'shoeb@example.com'),
  ('Docker Admin', 'admin@example.com'),
  ('Jake Styiles', 'jake@example.com'),
  ('DevOps Engineer', 'devops@example.com');