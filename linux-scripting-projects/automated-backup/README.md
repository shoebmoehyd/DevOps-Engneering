# 🗄️ Automated Backup

Two simple Bash scripts for backing up and restoring directories. Creates compressed archives with automatic rotation (keeps last 7 backups).

**🎯 Purpose**: Learn file operations, tar/gzip compression, and cron automation.

---

## 🚀 Quick Start

**Backup:**
```bash
chmod +x backup.sh restore.sh
./backup.sh ~/source_folder ~/backup_folder
```

**Restore:**
```bash
./restore.sh ~/backup_folder/backup_file.tar.gz ~/restore_location
```

**Test Everything:**
```bash
chmod +x test_backup.sh
./test_backup.sh
```

---

## 📋 What It Does

- 📦 **Compresses** directories into `.tar.gz` files
- ⏰ **Timestamps** each backup automatically
- 🔄 **Rotates** backups (keeps last 7, deletes old ones)
- 📝 **Logs** all operations
- 🔙 **Restores** from any backup file

---

## 💡 What You'll Learn

- ✅ `tar` and `gzip` for compression
- ✅ Command-line arguments (`$1`, `$2`)
- ✅ File tests (`-d`, `-f`, `-e`)
- ✅ Backup rotation logic
- ✅ Cron job scheduling
- ✅ Logging operations

---

## 🛠️ Cron Automation

Schedule automatic backups:

```bash
crontab -e

# Daily at 2 AM
0 2 * * * /path/to/backup.sh ~/documents ~/backups

# Weekly (Sundays at 3 AM)
0 3 * * 0 /path/to/backup.sh ~/projects ~/backups
```

**Cron syntax:**
```
* * * * * command
│ │ │ │ │
│ │ │ │ └─ Day of week (0-7)
│ │ │ └─── Month (1-12)
│ │ └───── Day (1-31)
│ └─────── Hour (0-23)
└───────── Minute (0-59)
```

---

## 🔧 Customization

Change how many backups to keep:

```bash
# Edit line 17 in backup.sh
KEEP_BACKUPS=7  # Change to any number
```

---

## 🧪 Testing

Run the automated test script:

```bash
./test_backup.sh
```

It will:
1. Create test files
2. Run 10 backups
3. Verify only 7 are kept
4. Test restore
5. Show summary

Clean up after testing:
```bash
rm -rf ~/test_source ~/test_backups ~/test_restore
```

---

## ⚠️ Troubleshooting

**Permission denied?**
```bash
chmod +x backup.sh restore.sh
```

**Need to exclude folders?**
```bash
# Edit the tar command in backup.sh to add:
tar -czf "$BACKUP_FILE" --exclude='node_modules' --exclude='.git' ...
```

---

## 📈 Project Status

**Level**: 🟡 Beginner-Intermediate  
**Status**: ✅ Completed  
**Time**: ⏱️ 3-4 hours  
**Difficulty**: ⭐⭐ (2/5)

---

💡 **Pro Tip**: Always test your restore process! A backup is only good if you can restore from it.
