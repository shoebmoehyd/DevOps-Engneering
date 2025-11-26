# 🔐 Config & Secrets Management

Secure configuration and secrets handling in Docker. Demonstrates environment variables, file-based secrets, and multi-environment setup.

**🎯 Purpose**: Learn to manage sensitive data and configurations securely in containerized apps.

---

## 🚀 Quick Start

```bash
docker-compose up --build
```

**Access:** http://localhost:4000

---

## 🔒 Security Approach

| Method | Use Case | Example |
|--------|----------|---------|
| 🌍 **Env Variables** | Non-sensitive config | DB_HOST, PORT |
| 📄 **File Secrets** | Sensitive data | Passwords, API keys |
| 🎭 **Masked Logging** | Debug safely | Shows **** not real values |

---

## 📂 Configuration Files

```
config-secrets/
├── .env.example        # Template (commit this)
├── .env.development    # Dev config (gitignored)
├── .env.production     # Prod config (gitignored)
├── secrets/
│   └── app_secret.txt  # File-based secret
└── app/
    ├── server.js       # Reads config & secrets
    └── Dockerfile
```

---

## 💡 What You'll Learn

- ✅ Environment-specific configurations
- ✅ Docker secrets with mounted files
- ✅ Secure secrets handling (never log/expose)
- ✅ `.env` file management
- ✅ Multi-environment setup (dev/prod)
- ✅ Security best practices

---

## 🧪 Testing

**Check config endpoint:**
```bash
curl http://localhost:4000/
```

**Debug endpoint (masked values):**
```bash
curl http://localhost:4000/debug
```

**Verify secret file mount:**
```bash
docker exec config-secrets-app cat /run/secrets/app_secret
```

**Switch environments:**
```yaml
# In docker-compose.yml, change:
env_file:
  - .env.development  # or .env.production
```

---

## 🔑 Secret Management

**Never commit real secrets!** Use `.gitignore`:
```gitignore
.env.development
.env.production
secrets/*.txt
```

**Template for team:**
Copy `.env.example` → `.env.development` and fill in values.

---

## 🎯 Best Practices

- ✅ Use `.env.example` as template
- ✅ Mount secrets as read-only files
- ✅ Mask secrets in logs/responses
- ✅ Different configs per environment
- ✅ Never hardcode secrets in code
- ❌ Never expose secrets via API

---

## ⚠️ Troubleshooting

**Secret file not found?**
```bash
# Check mount path
docker exec config-secrets-app ls -la /run/secrets/
```

**Environment not loading?**
```bash
# Verify .env file exists
ls -la .env.production
```

---

## 📈 Project Status

**Level**: 🔴 Advanced  
**Status**: ✅ Completed  
**Time**: ⏱️ 2-3 hours  
**Difficulty**: ⭐⭐⭐⭐ (4/5)

---

🔐 **Pro Tip**: Always use file-based secrets for production. Never log sensitive data!
