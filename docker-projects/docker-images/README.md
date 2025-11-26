# 🖼️ Optimized Docker Images

Production-ready Node.js app with security hardening and multi-stage builds. Demonstrates Docker best practices.

**🎯 Purpose**: Learn image optimization, security, and Docker best practices.

---

## 🚀 Quick Start

```bash
cd app
docker build -t optimized-node-app .
docker run -d -p 3000:3000 --name node-app optimized-node-app
```

**Access:** http://localhost:3000

---

## 🔒 Security Features

- 🛡️ **Non-root user** - Runs as `appuser` (not root)
- 🏔️ **Alpine base** - Minimal attack surface
- 🔍 **Production deps only** - No dev dependencies
- ❤️ **Healthcheck** - Monitors container health
- 📦 **Multi-stage build** - Smaller final image

---

## 📊 Optimization Benefits

| Feature | Before | After | Benefit |
|---------|--------|-------|---------|
| Image Size | ~1GB | ~150MB | 85% smaller |
| Security | Root user | Non-root | ✅ Hardened |
| Dependencies | All | Prod only | ✅ Reduced |
| Layers | Many | Optimized | ✅ Cached |

---

## 💡 What You'll Learn

- ✅ Multi-stage Docker builds
- ✅ Image optimization techniques
- ✅ Security best practices (non-root, Alpine)
- ✅ Healthchecks
- ✅ .dockerignore usage
- ✅ Layer caching

---

## 🧪 Testing

**Verify non-root user:**
```bash
docker exec node-app whoami
# Output: appuser
```

**Check image size:**
```bash
docker images optimized-node-app
```

**Test healthcheck:**
```bash
docker inspect node-app | grep -A 5 Health
```

**Access the app:**
```bash
curl http://localhost:3000
```

---

## 📁 Project Structure

```
docker-images/app/
├── Dockerfile          # Multi-stage build
├── .dockerignore       # Excludes node_modules, etc.
├── server.js           # Simple Express app
└── package.json        # Dependencies
```

---

## ⚠️ Troubleshooting

**Port conflict?**
```bash
docker run -d -p 3001:3000 optimized-node-app
```

**Build fails?**
```bash
docker build --no-cache -t optimized-node-app .
```

---

## 📈 Project Status

**Level**: 🟡 Intermediate  
**Status**: ✅ Completed  
**Time**: ⏱️ 2-3 hours  
**Difficulty**: ⭐⭐⭐ (3/5)

---

💡 **Pro Tip**: Always use multi-stage builds and non-root users in production!
