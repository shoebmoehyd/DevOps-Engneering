import express from "express";
import fs from "fs";

const app = express();
const PORT = process.env.PORT || 4000;

// Read config from env vars
const CONFIG = {
  env: process.env.NODE_ENV || "development",
  dbHost: process.env.DB_HOST || "localhost",
  dbUser: process.env.DB_USER || "appuser",
  // never log the real password
  dbPassword: process.env.DB_PASSWORD || "changeme",
  apiKey: process.env.API_KEY || "not-set"
};

// Read secret from mounted file (if present)
let fileSecret = null;
const secretFilePath = process.env.SECRET_FILE || "/run/secrets/app_secret";

if (fs.existsSync(secretFilePath)) {
  fileSecret = fs.readFileSync(secretFilePath, "utf8").trim();
}

app.get("/", (req, res) => {
  res.json({
    message: "Config & Secrets Demo",
    environment: CONFIG.env,
    dbHost: CONFIG.dbHost,
    dbUser: CONFIG.dbUser,
    // NEVER return secrets in API responses
    apiKeyPresent: CONFIG.apiKey !== "not-set",
    fileSecretPresent: !!fileSecret
  });
});

// A debug route (simulates internal logging – masks secrets)
app.get("/debug", (req, res) => {
  res.json({
    env: CONFIG.env,
    dbHost: CONFIG.dbHost,
    dbUser: CONFIG.dbUser,
    dbPasswordMasked: CONFIG.dbPassword ? "****" : null,
    apiKeyMasked: CONFIG.apiKey !== "not-set" ? "****" : null,
    fileSecretMasked: fileSecret ? "****" : null
  });
});

app.listen(PORT, () => {
  console.log(`Config & Secrets demo running on port ${PORT}`);
  console.log(`NODE_ENV=${CONFIG.env}`);
  console.log(`DB_HOST=${CONFIG.dbHost}`);
  console.log(`DB_USER=${CONFIG.dbUser}`);
  console.log(`DB_PASSWORD=****`);
  console.log(`API_KEY=****`);
  console.log(`File secret present: ${fileSecret ? "yes" : "no"}`);
});
