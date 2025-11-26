import express from "express";

const app = express();
const PORT = 3002;
const APP_NAME = "App 2 - Product Service";

app.get("/", (req, res) => {
  res.json({
    app: APP_NAME,
    message: "Welcome to Product Service! 🛍️",
    timestamp: new Date().toISOString(),
    host: req.hostname,
    path: req.path
  });
});

app.get("/health", (req, res) => {
  res.json({ status: "healthy", app: APP_NAME });
});

app.get("/products", (req, res) => {
  res.json({
    app: APP_NAME,
    products: [
      { id: 101, name: "Laptop", price: 999 },
      { id: 102, name: "Mouse", price: 29 },
      { id: 103, name: "Keyboard", price: 79 }
    ]
  });
});

app.listen(PORT, () => {
  console.log(`${APP_NAME} running on port ${PORT}`);
});
