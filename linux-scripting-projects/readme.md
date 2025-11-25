# 🐧 Linux & Shell Scripting Projects

A hands-on collection of Bash scripting projects covering essential Linux administration and automation skills for DevOps engineers. These projects demonstrate practical shell scripting techniques used in real-world DevOps scenarios.

**🎯 Core Concept**: Master the terminal and automation - the foundation of all DevOps work!

---

## 📋 Projects Overview

### 1. 📊 **system-monitor**
**Status:** 📝 Planned | **Level:** 🟢 Beginner

Real-time system monitoring and reporting script that tracks CPU, memory, disk usage, and running processes. Generates formatted reports for system health analysis.

**What you'll learn:**
- ✅ Basic Bash syntax and variables
- ✅ System commands (top, free, df, ps)
- ✅ Conditional statements
- ✅ Output formatting and reports

---

### 2. 🗄️ **automated-backup**
**Status:** 📝 Planned | **Level:** 🟡 Beginner-Intermediate

Automated backup and restore solution with compression, incremental backups, and scheduled execution using cron jobs.

**What you'll learn:**
- ✅ File operations and permissions
- ✅ Compression with tar and gzip
- ✅ Cron job scheduling
- ✅ Error handling and logging
- ✅ Backup rotation strategies

---

### 3. 🔍 **log-analyzer**
**Status:** 📝 Planned | **Level:** 🟡 Intermediate

Log parsing and analysis tool with pattern matching, error detection, and automated alerting system for critical events.

**What you'll learn:**
- ✅ Text processing with grep, awk, sed
- ✅ Regular expressions
- ✅ Pattern matching and filtering
- ✅ Email notifications
- ✅ Log rotation techniques

---

### 4. 👥 **service-manager**
**Status:** 📝 Planned | **Level:** 🔴 Intermediate-Advanced

User and service management automation including user provisioning, service health checks, and automated service recovery.

**What you'll learn:**
- ✅ User and group management
- ✅ Service control with systemctl
- ✅ Health check automation
- ✅ Functions and modular scripting
- ✅ Process management

---

### 5. 🚀 **deployment-automation**
**Status:** 📝 Planned | **Level:** 🔴 Advanced

Multi-server deployment automation script using SSH for remote execution, configuration deployment, and rollback capabilities.

**What you'll learn:**
- ✅ SSH automation and key management
- ✅ Remote command execution
- ✅ Loops and arrays
- ✅ Parallel processing
- ✅ Deployment pipelines
- ✅ Error handling and rollback

---

## 🚀 Quick Start Guide

### 📦 What Each Project Contains

| Component | Description |
|-----------|-------------|
| 📜 **Main Script** | Complete implementation ready to run |
| 📝 **README** | Detailed usage instructions and examples |
| 🧪 **Test Cases** | Sample data and testing scenarios |
| 📋 **Configs** | Configuration files (where applicable) |

### 🎓 Recommended Learning Path

Follow this progression for optimal learning:

1. 🟢 **system-monitor** → Learn Bash basics and system commands
2. 🟡 **automated-backup** → Master file operations and scheduling
3. 🟡 **log-analyzer** → Advanced text processing
4. 🔴 **service-manager** → System administration automation
5. 🔴 **deployment-automation** → Multi-server orchestration

---

## 💡 Skills You'll Master

| Skill Category | Topics Covered | Real-World Use |
|----------------|----------------|----------------|
| 🔧 **Bash Fundamentals** | Variables, conditionals, loops, functions | Foundation for all automation |
| 📂 **File Operations** | Read/write, permissions, compression, archiving | Backup systems, log management |
| 🔍 **Text Processing** | grep, awk, sed, regular expressions | Log analysis, configuration parsing |
| ⏰ **Scheduling** | Cron jobs, automated execution | Automated maintenance tasks |
| 🌐 **Remote Operations** | SSH, remote execution, multi-server management | Deployment automation |
| 📊 **System Admin** | Process management, service control, monitoring | Infrastructure maintenance |
| 📧 **Notifications** | Email alerts, logging, reporting | Incident response |
| 🔐 **Security** | User management, permissions, secure operations | Access control, hardening |

---

## 🛠️ Prerequisites

### Required

- ✅ **Linux Environment** - Ubuntu/Debian/CentOS or WSL on Windows
- ✅ **Terminal Access** - Comfortable with basic navigation
- ✅ **Text Editor** - vim, nano, or VS Code

### Optional (For Advanced Projects)

- 🔹 **SSH Access** - For deployment automation project
- 🔹 **Multiple VMs/Servers** - For testing multi-server scripts
- 🔹 **Email Server** - For testing alerting systems

---

## 📚 Essential Commands Reference

### 🖥️ System Monitoring
```bash
top              # Real-time process monitoring
htop             # Interactive process viewer
free -h          # Memory usage
df -h            # Disk space usage
du -sh *         # Directory sizes
uptime           # System uptime and load
ps aux           # All running processes
```

### 📂 File Management
```bash
cp -r src dest   # Copy recursively
mv old new       # Move/rename files
rm -rf dir       # Remove directory
tar -czf         # Create compressed archive
tar -xzf         # Extract compressed archive
chmod 755        # Set permissions
chown user:group # Change ownership
```

### 🔍 Text Processing
```bash
grep "pattern"   # Search text patterns
awk '{print $1}' # Column extraction
sed 's/old/new/' # Stream editing
cut -d: -f1      # Cut fields
sort | uniq      # Sort and deduplicate
```

### ⚙️ Service Control
```bash
systemctl start  # Start service
systemctl stop   # Stop service
systemctl status # Check status
systemctl enable # Auto-start on boot
journalctl -u    # View service logs
```

### 🌐 Network & Remote
```bash
ssh user@host    # Connect to remote server
scp file host:   # Copy files securely
curl URL         # Fetch web content
wget URL         # Download files
netstat -tuln    # Network connections
```

### ⏰ Scheduling
```bash
crontab -e       # Edit cron jobs
crontab -l       # List cron jobs
at now + 1 hour  # Schedule one-time task
```

---

## 🎯 Learning Outcomes

After completing these 5 projects, you'll be able to:

| Outcome | Description |
|---------|-------------|
| 🤖 **Automate Tasks** | Write scripts to automate repetitive system tasks |
| 📊 **Monitor Systems** | Build custom monitoring and alerting solutions |
| 🗄️ **Manage Backups** | Implement automated backup and recovery systems |
| 🔍 **Analyze Logs** | Parse and extract insights from system logs |
| 🚀 **Deploy Applications** | Automate multi-server deployments |
| 🛠️ **Troubleshoot** | Debug issues using shell scripting techniques |
| 📝 **Document Work** | Write clear, maintainable shell scripts |

---

## 🚀 What's Next?

After mastering Linux scripting, you'll be ready for:

| Next Step | Why It Matters |
|-----------|----------------|
| 🐳 **Docker** | Containerize applications you can deploy with scripts |
| ☁️ **Cloud (AWS/Azure)** | Automate cloud infrastructure with your scripting skills |
| 🏗️ **Terraform** | IaC uses similar automation concepts |
| ☸️ **Kubernetes** | Orchestrate containers you understand from Docker |
| 🔄 **CI/CD** | Build pipelines using scripting fundamentals |
| 📊 **Monitoring** | Set up observability for automated systems |

**The progression**: Script → Containerize → Orchestrate → Automate → Monitor

---

## 📊 Progress Tracking

| Project | Difficulty | Estimated Time | Status |
|---------|-----------|----------------|--------|
| 📊 system-monitor | ⭐ Beginner | 2-3 hours | 📝 Planned |
| 🗄️ automated-backup | ⭐⭐ Beginner-Int | 3-4 hours | 📝 Planned |
| 🔍 log-analyzer | ⭐⭐⭐ Intermediate | 4-5 hours | 📝 Planned |
| 👥 service-manager | ⭐⭐⭐⭐ Int-Advanced | 5-6 hours | 📝 Planned |
| 🚀 deployment-automation | ⭐⭐⭐⭐⭐ Advanced | 6-8 hours | 📝 Planned |

**Total Learning Time**: ⏱️ 20-26 hours

---

**Legend:**
- ✅ Completed
- 🔄 In Progress
- 📝 Planned

---

💡 **Pro Tip**: These scripts form the foundation of DevOps automation. Many DevOps tools (Ansible, Terraform, Kubernetes) use similar concepts. Master Bash scripting, and you'll understand how automation really works under the hood!