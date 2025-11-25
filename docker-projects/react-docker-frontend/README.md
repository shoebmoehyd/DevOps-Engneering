# ⚛️ React Docker Frontend

A modern React application built with Vite and containerized using Docker's multi-stage build process. This project demonstrates how to create lightweight, production-ready frontend containers served by Nginx - reducing image size by ~90% compared to single-stage builds.

**🎯 Core Concept**: Multi-stage builds separate build dependencies from runtime, creating minimal production images.

---

## 📂 Project Structure

```
my-react-app/
├── ⚛️  src/                # React source code
│   ├── App.jsx
│   ├── main.jsx
│   └── assets/
├── 🌐 public/             # Static assets
├── 🐳 Dockerfile          # Multi-stage build
├── 🔧 nginx.conf          # Nginx configuration
├── ⚙️  vite.config.js     # Vite build config
├── 📦 package.json        # Dependencies
└── 🚫 .dockerignore       # Exclude from build
```

---

## ⚡ Quick Start

### 🏗️ Build the Docker Image

```bash
docker build -t react-frontend:latest .
```

### 🚀 Run the Container

```bash
docker run -d -p 8080:80 --name react-app react-frontend:latest
```

### 🌍 Access Your Application

Open your browser: **http://localhost:8080**

### 🛑 Stop and Clean Up

```bash
docker stop react-app
docker rm react-app
docker rmi react-frontend:latest
```

---

## 🎯 What You'll Learn

✅ **Multi-stage Docker builds** - Separate build and runtime environments  
✅ **Image optimization** - Reduce size from ~200MB to ~25MB  
✅ **Frontend containerization** - Package React apps for deployment  
✅ **Nginx for SPAs** - Configure routing for single-page applications  
✅ **Production builds** - Vite optimization and asset bundling  
✅ **Layer caching** - Speed up rebuilds with proper Dockerfile structure  

---

## 🛠️ Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| ⚛️ Framework | React | 19.2.0 |
| ⚡ Build Tool | Vite | 7.2.4 |
| 📦 Build Image | Node.js Alpine | 22 |
| 🚀 Serve Image | Nginx Alpine | Latest |
| 🐳 Container | Docker | Latest |

---

## 🔑 Key Concepts

### 🎯 Multi-Stage Build Process

The Dockerfile uses two stages to create an optimized production image:

**📦 Stage 1: Build** (node:22-alpine)
- Install Node.js dependencies
- Compile React app with Vite
- Generate optimized production bundle in `/dist`

**🚀 Stage 2: Serve** (nginx:alpine)
- Copy only the compiled static files from Stage 1
- Configure Nginx for SPA routing
- Final image contains NO build tools or dependencies

**Result**: Production image is ~25MB instead of ~200MB+ 🎉

### 🌐 Nginx Configuration Highlights

Custom `nginx.conf` provides:
- **SPA Routing**: `try_files $uri /index.html` handles client-side routes
- **Static Serving**: Efficient delivery of HTML/CSS/JS assets
- **Error Handling**: Custom error pages
- **Port 80**: Standard HTTP serving

### ⚡ Vite Optimization Features

- Tree-shaking for minimal bundle size
- Code splitting for better performance
- Asset optimization (images, fonts)
- Fast production builds

---

## 📊 Image Size Comparison

| Build Type | Image Size | Contains |
|-----------|-----------|----------|
| 🚫 Single Stage (Node) | ~200MB+ | Build tools + runtime + source |
| ✅ Multi-Stage (Nginx) | ~25MB | Only static files + Nginx |

**Multi-stage builds reduce size by ~90%** - faster deployments, lower bandwidth, reduced attack surface!

---

## 🔍 Verification & Testing

### Check Running Container
```bash
docker ps | grep react-app
```

### View Container Logs
```bash
docker logs react-app
```

### Check Image Size
```bash
docker images react-frontend
```

### Test Locally (Development Mode)
```bash
npm install
npm run dev
```

---

## 🚀 Next Steps & Enhancements

Ready to level up? Try adding:

- 🌍 **Environment Variables** - Configure API URLs per environment
- 🗜️ **Gzip Compression** - Enable Nginx compression for faster loads
- 🔐 **HTTPS/SSL** - Add SSL certificates for secure connections
- 📊 **Health Checks** - Add Docker health check endpoint
- 🔄 **CI/CD Pipeline** - Automate build and deployment with GitHub Actions

---

## 📊 Project Status

**Level**: 🟢 Beginner  
**Status**: ✅ Completed  
**Learning Time**: ~2-3 hours  
**Difficulty**: ⭐⭐ (2/5)

---

💡 **Pro Tip**: Understanding multi-stage builds is fundamental for creating production-ready containerized applications. This technique applies to any language or framework!