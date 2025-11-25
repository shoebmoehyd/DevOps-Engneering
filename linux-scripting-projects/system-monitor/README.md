# 📊 System Monitor

A simple Bash script that displays system information - CPU, memory, disk usage, and running processes. One command, all the info you need.

**🎯 Purpose**: Learn Bash basics while monitoring your system resources.

---

## 🚀 Quick Start

```bash
chmod +x monitor.sh
./monitor.sh
```

That's it! The script displays everything at once.

---

## 📋 What It Shows

- 🖥️ **System Info** - Hostname and uptime
- 💻 **CPU Usage** - Current usage percentage with top 5 processes
- 🧠 **Memory** - RAM usage with percentage
- 💾 **Disk Space** - All mounted filesystems
- ⚙️ **Processes** - Count of running, sleeping, and total processes

---

## 🎨 Color-Coded Alerts

| Resource | Green | Yellow | Red |
|----------|-------|--------|-----|
| CPU | < 50% | 50-80% | > 80% |
| Memory | < 60% | 60-80% | > 80% |

---

## 💡 What You'll Learn

- ✅ Bash script structure
- ✅ Using system commands (`top`, `free`, `df`, `ps`)
- ✅ Text processing with `awk` and `grep`
- ✅ Conditional statements
- ✅ Color-coded output
- ✅ Basic error handling

---

## 🔧 Customization

Want to change the alert thresholds? Edit these lines:

```bash
# CPU threshold (around line 27)
if (( $(echo "$cpu_usage > 80" | bc -l 2>/dev/null || echo 0) )); then

# Memory threshold (around line 44)
if (( $(echo "$mem_percent > 80" | bc -l 2>/dev/null || echo 0) )); then
```

---

## 🧪 Testing

```bash
# Run it
./monitor.sh

# That's it! Check if output looks correct
```

---

## ⚠️ Troubleshooting

**Permission denied?**
```bash
chmod +x monitor.sh
```

**bc not installed?** (For calculations)
```bash
sudo apt-get install bc
```

---

## 📈 Project Status

**Level**: 🟢 Beginner  
**Status**: ✅ Completed  
**Time**: ⏱️ 2-3 hours  
**Difficulty**: ⭐ (1/5)

---

💡 **Pro Tip**: Run this regularly to learn your system's normal resource usage patterns!
