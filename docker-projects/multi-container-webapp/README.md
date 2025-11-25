# 🔧 Multi-Container Web Application

A full-stack web application demonstrating multi-container orchestration using Docker Compose. This project showcases how to containerize and connect a frontend, backend API, and database into a cohesive application.

---

## 🏗️ Architecture Overview

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│  🌐 Frontend (HTML/CSS/JS)  →  Port 80/3000        │
│                     ↓                                │
│  ⚙️  Backend (Node.js API)  →  Port 4000           │
│                     ↓                                │
│  🗄️  Database (PostgreSQL)  →  Port 5432           │
│                                                      │
└──────────────────────────────────────────────────────┘
```

**Three services working together seamlessly through Docker networking!**

---

## 📂 Project Structure

```
multi-container-webapp/
├── 🌐 frontend/           # User interface
│   ├── index.html
│   └── Dockerfile
├── ⚙️ backend/            # REST API server
│   ├── server.js
│   ├── package.json
│   └── Dockerfile
├── 🗄️ database/           # Data storage
│   └── init.sql
└── 🐳 docker-compose.yml  # Orchestration magic
```

---

## 💡 What This Application Does

| Service | Purpose | Technology |
|---------|---------|------------|
| 🌐 **Frontend** | Serves web interface for user interaction | HTML/CSS/JavaScript |
| ⚙️ **Backend** | Provides REST API for data operations | Node.js + Express |
| 🗄️ **Database** | Stores user data with persistence | PostgreSQL |

The three services communicate seamlessly through Docker's internal networking, demonstrating real-world microservices architecture.

---

## ⚡ Quick Start

### 🚀 Start the Application

Run all services with a single command:

```bash
docker-compose up -d
```

### 🌍 Access Your Application

- **Frontend**: http://localhost:80 (or your configured port)
- **Backend API**: http://localhost:4000/api/users
- **Database**: localhost:5432 (internal access only)

### 🛑 Stop All Services

```bash
docker-compose down
```

### 🧹 Clean Up Everything (including data)

```bash
docker-compose down -v
```

---

## 🎯 What You'll Learn

✅ **Multi-container orchestration** with Docker Compose  
✅ **Service networking** and inter-container communication  
✅ **Environment variables** for configuration management  
✅ **Volume management** for database persistence  
✅ **Port mapping** and service exposure  
✅ **Dependency management** between services  
✅ **Health checks** and startup ordering  

---

## 🛠️ Technology Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| 🌐 Frontend | HTML/CSS/JS | User Interface |
| ⚙️ Backend | Node.js + Express | REST API |
| 🗄️ Database | PostgreSQL | Data Storage |
| 🐳 Orchestration | Docker Compose | Container Management |

---

## 🔍 Testing & Monitoring

### Test the Backend API
```bash
curl http://localhost:4000/api/users
```

### Check Running Containers
```bash
docker-compose ps
```

### View Live Logs
```bash
docker-compose logs -f
```

### Monitor Specific Service
```bash
docker-compose logs -f backend
```

---

## 📚 Key Concepts Demonstrated

| Concept | Description |
|---------|-------------|
| 🏗️ **Multi-stage Builds** | Optimized container images |
| 🌐 **Container Networking** | Service discovery and communication |
| ⚙️ **Environment Config** | Environment-based settings |
| 🗄️ **Database Init** | Automated seed data loading |
| 💾 **Volume Persistence** | Stateful data storage |
| 🏥 **Health Checks** | Service availability monitoring |
| 🔗 **Dependencies** | Startup order with `depends_on` |

---

## 🎓 Next Steps & Extensions

Ready to level up? Try adding:

- 🔴 **Redis** - Add caching layer for better performance
- 🔀 **Nginx** - Implement reverse proxy and load balancing
- 🔐 **Authentication** - Add JWT-based security
- 📊 **Monitoring** - Set up Prometheus + Grafana
- ☸️ **Kubernetes** - Deploy to production cluster

---

## 📊 Project Status

**Level**: 🔥 Advanced  
**Status**: ✅ Completed  
**Learning Time**: ~4-6 hours  
**Difficulty**: ⭐⭐⭐⭐ (4/5)

---

💡 **Pro Tip**: This project is a perfect foundation for understanding microservices architecture and serves as a stepping stone to Kubernetes!
