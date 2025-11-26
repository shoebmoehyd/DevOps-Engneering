# 🌐 Tomcat Server

Apache Tomcat 10.1 with JDK 17 running in Docker. Deploy Java webapps easily.

**🎯 Purpose**: Learn application server deployment with Docker.

---

## 🚀 Quick Start

```bash
docker build -t tomcat-server .
docker run -d -p 8080:8080 --name tomcat tomcat-server
```

**Access:** http://localhost:8080/demo

---

## 📋 Features

- 🚀 Tomcat 10.1 + JDK 17
- 📦 Demo webapp included
- 🌐 Ready to deploy custom apps
- 🔧 Auto-deploys WAR files

---

## 💡 What You'll Learn

- ✅ Running Tomcat in Docker
- ✅ Java webapp deployment
- ✅ Port mapping
- ✅ Webapp directory structure

---

## 🧪 Testing

```bash
curl http://localhost:8080/demo
docker logs tomcat
```

---

## ➕ Add Your Own App

Drop your webapp folder or WAR file in `webapps/` and rebuild!

```bash
webapps/
├── demo/
└── myapp/    # Your app here
```

---

## ⚠️ Troubleshooting

**Port conflict?**
Use `-p 8081:8080` instead

**Check logs:**
```bash
docker logs tomcat
```

---

## 📈 Project Status

**Level**: 🟡 Intermediate  
**Status**: ✅ Completed  
**Time**: ⏱️ 2-3 hours  
**Difficulty**: ⭐⭐ (2/5)

---

💡 **Pro Tip**: Tomcat auto-deploys WAR files - just drop them in webapps/!
