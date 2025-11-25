const express = require("express");
const mysql = require("mysql2");

const app = express();

// Simple CORS so frontend (different port) can call this API
app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  next();
});

// DB connection using environment variables (from docker-compose)
const db = mysql.createConnection({
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "rootpassword",
  database: process.env.DB_NAME || "testdb",
});

db.connect((err) => {
  if (err) {
    console.error("❌ Database connection failed:", err);
  } else {
    console.log("✅ Connected to MySQL from backend container!");
  }
});

// Simple health check
app.get("/api", (req, res) => {
  res.json({ message: "Hello from Backend API!" });
});

// Get all users from DB
app.get("/api/users", (req, res) => {
  db.query("SELECT * FROM users", (err, results) => {
    if (err) {
      console.error("Error fetching users:", err);
      return res.status(500).json({ error: "DB query failed" });
    }
    res.json(results);
  });
});

app.listen(4000, () => {
  console.log("Backend running on port 4000");
});
