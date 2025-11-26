# 🗄️ MySQL Database

MySQL 8 with Docker Compose. Persistent storage, auto-initialization, and custom config.

**🎯 Purpose**: Learn Docker volumes and database setup.

---

## 🚀 Quick Start

```bash
docker-compose up -d
docker exec -it mysql-db mysql -u appuser -pappuserpassword appdb
```

---

## 📋 Features

- 🐬 MySQL 8 database
- 💾 Persistent volume (data survives restarts)
- 📊 Auto-creates users table with sample data
- ⚙️ Custom MySQL configuration
- 🔐 Predefined users and database

---

## 💡 What You'll Learn

- ✅ Docker volumes for data persistence
- ✅ Environment variables
- ✅ Init scripts with volume mounting
- ✅ Custom MySQL config
- ✅ Port mapping

---

## 🔑 Credentials

| Field | Value |
|-------|-------|
| Host | localhost:3307 |
| Database | appdb |
| User | appuser |
| Password | appuserpassword |

---

## 🧪 Testing

**Query the data:**
```bash
docker exec -it mysql-db mysql -u appuser -pappuserpassword -e "SELECT * FROM appdb.users;"
```

**Test persistence:**
```bash
docker-compose down
docker-compose up -d
# Your data is still there!
```

---

## ⚠️ Troubleshooting

**Port conflict?**
Change `3307` to another port in `docker-compose.yml`

**Can't connect?**
```bash
docker-compose logs mysql
```

---

## 📈 Project Status

**Level**: 🟢 Beginner  
**Status**: ✅ Completed  
**Time**: ⏱️ 1-2 hours  
**Difficulty**: ⭐ (1/5)

---

💡 **Pro Tip**: Named volumes = persistent data. Always use them for databases!
