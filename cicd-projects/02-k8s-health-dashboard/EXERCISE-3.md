# 📝 Exercise 3: Dockerize the Application

**🎯 Goal:** Package both frontend and backend into Docker containers for easy deployment anywhere.

**⏱️ Time:** 20-25 minutes

---

## 📂 What We're Building

```
02-k8s-health-dashboard/
├── backend/
│   ├── Dockerfile           ← NEW! Backend container
│   ├── .dockerignore        ← NEW! Ignore node_modules
│   └── ... (existing files)
├── frontend/
│   ├── Dockerfile           ← NEW! Frontend container (multi-stage)
│   ├── .dockerignore        ← NEW! Ignore node_modules
│   ├── nginx.conf           ← NEW! Nginx configuration
│   └── ... (existing files)
└── docker-compose.yml       ← NEW! Run both containers together
```

---

## 🎯 Why Dockerize?

- ✅ **Portability** - Run anywhere (laptop, server, cloud)
- ✅ **Consistency** - Same environment every time
- ✅ **Easy deployment** - Single command to start everything
- ✅ **Production-ready** - Best practices built-in

---

## 🚀 Step 1: Create Backend Dockerfile

**Navigate to backend folder:**

```bash
cd "C:/Users/shoeb/My Learnings/DevOps-Engneering/cicd-projects/02-k8s-health-dashboard/backend"
```

**I'll create these files for you:**
- `Dockerfile` - Instructions to build backend image
- `.dockerignore` - Files to exclude from image

**Wait for confirmation before proceeding!**

---

## 🚀 Step 2: Create Frontend Dockerfile

**The frontend Dockerfile will:**
1. **Stage 1 (Builder):** Build React app with Vite
2. **Stage 2 (Production):** Serve static files with Nginx

**Why multi-stage?** Smaller final image (only includes built files, not source code)

**I'll create these files:**
- `frontend/Dockerfile` - Multi-stage build
- `frontend/.dockerignore` - Exclude unnecessary files
- `frontend/nginx.conf` - Nginx configuration for React Router

**Wait for confirmation!**

---

## 🚀 Step 3: Create Docker Compose

**What is Docker Compose?** Tool to run multiple containers together with one command.

**Our docker-compose.yml will:**
- Start backend container (port 3000)
- Start frontend container (port 80)
- Create network so they can communicate
- Mount kubeconfig for Kubernetes access

**I'll create:** `docker-compose.yml` in project root

---

## 🚀 Step 4: Build and Test!

**Make sure Docker Desktop is running!**

**Build the images:**

```bash
cd "C:/Users/shoeb/My Learnings/DevOps-Engneering/cicd-projects/02-k8s-health-dashboard"

# Build both images
docker-compose build
```

**Expected output:**
```
[+] Building 45.2s (23/23) FINISHED
 => [backend] ...
 => [frontend] ...
Successfully built!
```

**This may take 2-3 minutes the first time!**

---

## 🚀 Step 5: Run the Containers!

**Start everything:**

```bash
docker-compose up
```

**Expected output:**
```
[+] Running 2/2
 ✔ Container k8s-dashboard-backend   Started
 ✔ Container k8s-dashboard-frontend  Started
```

**You should see logs from both containers!**

---

## 🚀 Step 6: Test in Browser

**Open your browser and go to:** `http://localhost`

**You should see:**
- 🎨 Same beautiful dashboard
- 📊 Cluster data loading
- 🔄 Auto-refresh working

**The difference?** Now it's running in containers! 🐳

---

## ✅ Success Checklist

- ✅ Docker images built successfully
- ✅ Containers started without errors
- ✅ Dashboard accessible at `http://localhost`
- ✅ Backend API responding (check logs)
- ✅ Frontend displays cluster data

---

## 🎓 What You Learned

- ✅ Docker fundamentals (images, containers)
- ✅ Writing Dockerfiles (single-stage and multi-stage)
- ✅ Docker Compose for multi-container apps
- ✅ `.dockerignore` for optimizing builds
- ✅ Nginx as a production web server
- ✅ Container networking and port mapping

---

## 🐛 Troubleshooting

**"Docker daemon is not running":**
- Start Docker Desktop
- Wait for it to fully start (whale icon in tray)

**"Cannot connect to Kubernetes":**
- Make sure Minikube is running: `minikube status`
- Check that kubeconfig path is correct in docker-compose.yml

**"Port already in use":**
- Stop other containers: `docker-compose down`
- Or stop your local dev servers (from Exercise 2)

**Frontend shows errors:**
- Check backend logs: `docker-compose logs backend`
- Verify API URL in frontend is correct

---

## 🔍 Useful Commands

**View running containers:**
```bash
docker-compose ps
```

**View logs:**
```bash
docker-compose logs          # All containers
docker-compose logs backend  # Just backend
docker-compose logs -f       # Follow logs
```

**Stop containers:**
```bash
docker-compose down
```

**Rebuild after changes:**
```bash
docker-compose up --build
```

---

## 🎉 Exercise 3 Complete!

**When your dashboard is running in Docker containers, come back and tell me "Exercise 3 done"!**

**Next:** Exercise 4 - We'll deploy this to Kubernetes! 🚀
