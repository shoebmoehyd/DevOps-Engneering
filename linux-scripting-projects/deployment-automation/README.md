# 🚀 Deployment Automation

Deploy applications to multiple servers via SSH. Auto-backup and rollback included.

**🎯 Purpose**: Learn SSH automation and deployment strategies.

---

## 🚀 Quick Start

```bash
chmod +x deploy.sh rollback.sh

# Deploy
./deploy.sh -s user@server1,user@server2 -f app.tar.gz

# Rollback
./rollback.sh user@server1
```

**Prerequisites:** SSH key authentication, sudo access

---

## 📋 Features

- 🔐 Deploy to multiple servers via SSH
- 💾 Auto-backup before deployment
- ❤️ Health checks after deployment
- ⏪ Rollback from backup
- 📊 Summary report

---

## 💡 What You'll Learn

- ✅ SSH automation with `ssh` and `scp`
- ✅ Remote command execution
- ✅ Arrays and loops
- ✅ Argument parsing
- ✅ Backup strategies

---

## 🧪 Testing

**Setup SSH:**
```bash
ssh-keygen -t rsa
ssh-copy-id user@server
```

**Create test app:**
```bash
tar -czf myapp.tar.gz myapp/
./deploy.sh -s user@server -f myapp.tar.gz
```

---

## 🔧 Configuration

Edit variables in `deploy.sh`:
```bash
DEPLOYMENT_DIR="/var/www/app"
BACKUP_DIR="/var/www/backups"
APP_SERVICE="myapp"
```

---

## ⚠️ Troubleshooting

**SSH failed?**
```bash
ssh-copy-id user@server
```

**Permission denied?**
```bash
chmod +x deploy.sh rollback.sh
```

---

## 📈 Project Status

**Level**: 🔴 Advanced  
**Status**: ✅ Completed  
**Time**: ⏱️ 5-6 hours  
**Difficulty**: ⭐⭐⭐⭐⭐ (5/5)

---

💡 **Pro Tip**: Test on staging before production!
