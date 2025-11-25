# 📊 Log Analyzer

Interactive log analyzer. Navigate through errors, warnings, and patterns with ease.

**🎯 Purpose**: Learn grep, awk, and text processing.

---

## 🚀 Quick Start

```bash
chmod +x log-analyzer.sh test_logs.sh

# Test it first
./test_logs.sh

# Then analyze the log interactively
./log-analyzer.sh sample_app.log
```

---

## 📋 Features

- 🎯 **Interactive Menu** - Easy navigation
- 📈 **Summary View** - All log level counts
- 🔍 **Error Patterns** - Most common issues
- 📝 **Recent Errors** - Latest problems
- 🎨 **Color-Coded Output** - Visual clarity

---

## 💡 What You'll Learn

- ✅ `grep` for pattern matching
- ✅ `awk` for text processing and counting
- ✅ Interactive menus with `while` loops
- ✅ `case` statements for menu options
- ✅ Functions for code organization
- ✅ `read` for user input

---

## 🧪 Testing

```bash
./test_logs.sh
```

Creates `sample_app.log` with 40 entries, then explore it interactively!

---

## ⚠️ Troubleshooting

**Permission denied?**
```bash
chmod +x log-analyzer.sh
```

**Can't read system logs?**
```bash
sudo ./log-analyzer.sh /var/log/syslog
```

---

## 📈 Project Status

**Level**: 🟡 Intermediate  
**Status**: ✅ Completed  
**Time**: ⏱️ 3-4 hours  
**Difficulty**: ⭐⭐⭐ (3/5)

---

💡 **Pro Tip**: Try it on real system logs to see actual errors!
