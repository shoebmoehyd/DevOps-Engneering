import express from "express";

const app = express();
const PORT = 3001;
const APP_NAME = "App 1 - User Service";

app.get("/", (req, res) => {
  res.json({
    app: APP_NAME,
    message: "Welcome to User Service! 👤",
    timestamp: new Date().toISOString(),
    host: req.hostname,
    path: req.path
  });
});

app.get("/health", (req, res) => {
  res.json({ status: "healthy", app: APP_NAME });
});

app.get("/users", (req, res) => {
  res.json({
    app: APP_NAME,
    users: [
      { id: 1, name: "Alice", role: "Admin" },
      { id: 2, name: "Bob", role: "User" },
      { id: 3, name: "Charlie", role: "User" }
    ]
  });
});

app.listen(PORT, () => {
  console.log(`${APP_NAME} running on port ${PORT}`);
});
