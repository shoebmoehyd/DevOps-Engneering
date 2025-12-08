# 🚀 CI/CD Projects Collection

A comprehensive hands-on collection of CI/CD projects where you'll build **REAL DevOps tools** instead of generic "hello world" apps. These projects showcase production-ready continuous integration and delivery workflows while creating actual tools you'll use in your DevOps career.

## 💡 Why These Projects Are Different

**Instead of building:**
- ❌ Another "hello world" app
- ❌ Simple Node.js servers
- ❌ Basic CRUD applications

**You'll build:**
- ✅ **DevOps tools** that solve real problems
- ✅ **Dashboards and UIs** for infrastructure
- ✅ **Integration tools** with Docker, K8s, ArgoCD APIs
- ✅ **Portfolio-worthy projects** that impress recruiters

---

## 📋 Projects Overview

### 1. 🐳 **Docker Registry Explorer**
**Status:** ✅ Complete | **Level:** Beginner

Build a web UI to explore Docker Hub repositories, tags, and image details. Learn CI/CD basics while creating a tool to visualize your Docker images.

**What you'll build:**
- Python Flask API + Simple frontend
- Docker Hub API integration
- List repos, tags, sizes, layers
- Quick pull commands (copy-paste)
- Automated Docker build & push pipeline

**What you'll learn:**
- GitHub Actions workflows
- Docker multi-stage builds
- REST API integration (Docker Hub API)
- Python web applications
- Secrets management
- CI pipeline basics

---

### 2. ☸️ **K8s Health Dashboard**
**Status:** 📝 Planned | **Level:** Intermediate

Build a real-time Kubernetes cluster viewer that shows pods, deployments, services, and health status with color-coded indicators.

**What you'll build:**
- Node.js + React dashboard
- Kubernetes API integration
- Real-time pod status viewer
- Resource usage display (CPU/memory)
- Color-coded health indicators
- Auto-deploy to K8s via CI/CD

**What you'll learn:**
- K8s API programming
- Real-time data updates
- React frontend development
- Automated K8s deployments
- Image version management
- kubectl automation in CI/CD

---

### 3. 🔄 **GitOps Sync Monitor**
**Status:** 📝 Planned | **Level:** Intermediate

Create a monitoring tool for ArgoCD that tracks sync status, shows Git commit → deployed version mapping, and displays sync history timeline.

**What you'll build:**
- Go backend + Simple frontend
- ArgoCD API integration
- Sync status dashboard (synced/out-of-sync)
- Git commit tracker
- Deployment timeline visualization
- GitOps-based deployment

**What you'll learn:**
- GitOps principles
- ArgoCD API programming
- Go web services
- Declarative deployments
- Auto-sync vs manual approval
- Git as single source of truth

---

### 4. 🌍 **Multi-Env Deployment Manager**
**Status:** 📝 Planned | **Level:** Intermediate

Build a deployment management UI that lets you deploy to dev/staging/prod environments with approval workflows and deployment history tracking.

**What you'll build:**
- Node.js + React + SQLite database
- Environment selector UI
- Approval workflow system
- Deployment history per environment
- Rollback capabilities
- Multi-environment pipeline

**What you'll learn:**
- Environment management
- Approval gates in CI/CD
- Branch strategies
- Environment-specific secrets
- State management with databases
- Complex workflow automation

---

### 5. 🔒 **Security Scanner Dashboard**
**Status:** 📝 Planned | **Level:** Advanced

Create a security dashboard that scans Docker images with Trivy, displays CVE details with severity levels, and tracks security trends over time.

**What you'll build:**
- Python FastAPI backend + React frontend
- Trivy CLI integration
- Image upload & scan functionality
- CVE database viewer (severity, fix versions)
- Historical trend charts
- Automated security scanning in CI/CD

**What you'll learn:**
- Container vulnerability scanning (Trivy)
- Security analysis automation
- Data visualization
- Python FastAPI development
- Security-first pipelines
- Quality gates in CI/CD

---

### 6. 🎯 **DevOps Control Center**
**Status:** 📝 Planned | **Level:** Advanced

Build an all-in-one DevOps platform combining CI/CD status, K8s health, security scans, and deployment timelines with alert notifications.

**What you'll build:**
- Microservices architecture (Python + Go + React)
- GitHub Actions status integration
- K8s cluster health monitoring
- Security scan result aggregation
- Unified deployment timeline
- Alert notification system
- Production-grade pipeline for multi-service app

**What you'll learn:**
- End-to-end automation
- Microservices CI/CD
- Blue-green deployments
- Automated rollbacks
- Multi-service orchestration
- Production best practices

---

## 🎯 Getting Started

### Prerequisites

- **Docker** installed and running
- **Git & GitHub** account
- **Kubernetes** (Minikube or Docker Desktop K8s)
- **kubectl** installed
- **Docker Hub** account (free tier)
- **Python 3.9+** (Projects 1, 5, 6)
- **Node.js 18+** (Projects 2, 4, 6)
- **Go 1.21+** (Projects 3, 6)
- **ArgoCD** (Project 3 onwards)

### Setup Your Environment

**1. Docker Hub Account:**
```bash
# Login to Docker Hub
docker login
```

**2. GitHub Repository:**
- Fork or create a new repo
- Enable GitHub Actions
- Add Docker Hub credentials as secrets

**3. Local Kubernetes:**
```bash
# Start Minikube
minikube start

# Verify
kubectl get nodes
```

---

## 📚 Recommended Learning Path

Follow projects in order for best learning experience:

**Beginner (Projects 1-2):**
1. **Docker Registry Explorer** - Python Flask + Docker Hub API
2. **K8s Health Dashboard** - Node.js + React + K8s API

**Intermediate (Projects 3-4):**
3. **GitOps Sync Monitor** - Go + ArgoCD API
4. **Multi-Env Deployment Manager** - Node.js + React + Database

**Advanced (Projects 5-6):**
5. **Security Scanner Dashboard** - Python FastAPI + Trivy
6. **DevOps Control Center** - Microservices (Python + Go + React)

---

## 💡 Purpose

These projects teach modern CI/CD by building **real DevOps tools** you'll actually use. Instead of generic applications, you'll create dashboards, monitoring tools, and integrations that solve real infrastructure problems.

**Why this approach?**
- 🎯 **Portfolio Impact** - Recruiters see you built actual tools, not tutorials
- 🔧 **Practical Learning** - Work with real APIs (Docker Hub, K8s, ArgoCD, GitHub)
- 💼 **Career Ready** - Build tools you'll use in DevOps roles
- 🚀 **Unique Projects** - Stand out from other candidates

**What you'll master:**
- **Speed** - Fast, automated deployments across multiple languages
- **Security** - Vulnerability scanning and secrets management
- **Integration** - Real API programming (not just REST basics)
- **Architecture** - From simple apps to microservices

---

## 🚀 Key Technologies

- **Languages:** Python, Node.js, Go, React
- **CI/CD Tools:** GitHub Actions, ArgoCD
- **Containers:** Docker, Kubernetes
- **APIs:** Docker Hub API, Kubernetes API, ArgoCD API, GitHub API
- **Security:** Trivy, CVE scanning, Secret management
- **Databases:** SQLite, PostgreSQL
- **Frontend:** React, HTML/CSS/JS
- **Backend:** Flask, FastAPI, Express, Go net/http

---

**Legend:**
- ✅ Completed
- 🔄 In Progress
- 📝 Planned
