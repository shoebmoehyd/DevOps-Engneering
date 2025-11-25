# 🚀 Spring Boot Docker Application

A lightweight Spring Boot REST API containerized with Docker using multi-stage builds. This project demonstrates how to containerize Java applications efficiently, making them portable and ready to deploy anywhere - from your laptop to production cloud environments.

**🎯 Core Concept**: Package Java applications in containers for consistent deployment across any environment.

---

## 📂 Project Structure

```
java-springboot-application/
├── 📦 src/
│   ├── main/
│   │   ├── java/com/example/demo/
│   │   │   ├── DemoApplication.java
│   │   │   └── HelloController.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
├── 🐳 Dockerfile          # Multi-stage build
├── ⚙️  pom.xml            # Maven dependencies
├── 🔧 mvnw                # Maven wrapper
└── 📝 README.md
```

---

## ⚡ Quick Start

### 🎯 Option 1: Run Pre-built Image (Easiest)

Pull and run the pre-built image from Docker Hub:

```bash
docker run -p 8080:8080 shoebmoehyd/sbapp:1.0
```

### 🏗️ Option 2: Build From Source

Build your own Docker image:

```bash
docker build -t spring-boot-app:latest .
```

Run the container:

```bash
docker run -d -p 8080:8080 --name sb-app spring-boot-app:latest
```

### 🌍 Access Your Application

Open your browser: **http://localhost:8080**

### 🛑 Stop and Clean Up

```bash
docker stop sb-app
docker rm sb-app
docker rmi spring-boot-app:latest
```

---

## 🎯 What You'll Learn

✅ **Java containerization** - Package Spring Boot apps in Docker  
✅ **Multi-stage builds** - Separate build and runtime for smaller images  
✅ **Maven in Docker** - Build Java applications inside containers  
✅ **REST APIs** - Create simple HTTP endpoints with Spring Boot  
✅ **Docker Hub** - Pull and run pre-built container images  
✅ **Port mapping** - Expose container services to host system  

---

## 🛠️ Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| ☕ Framework | Spring Boot | 3.5.8 |
| 🔧 Build Tool | Maven | 3.8.5 |
| ☕ Java Version | OpenJDK | 17 |
| 📦 Build Image | Maven + OpenJDK | 17-slim |
| 🚀 Runtime Image | Eclipse Temurin | 17-jdk |
| 🐳 Container | Docker | Latest |

---

## 🔑 Key Concepts

### 🎯 Multi-Stage Build Process

The Dockerfile uses two stages for optimal image size:

**📦 Stage 1: Build** (maven:3.8.5-openjdk-17-slim)
- Copy source code and pom.xml
- Run Maven build to compile Java code
- Generate executable JAR file in `/target`

**🚀 Stage 2: Runtime** (eclipse-temurin:17-jdk)
- Copy only the compiled JAR from Stage 1
- No source code or build tools in final image
- Lightweight runtime environment

**Result**: Final image contains only Java runtime + JAR file!

### ☕ Spring Boot Features

- **REST API**: Simple HTTP endpoints (`/` returns "Hello World")
- **Embedded Server**: Tomcat server included, no external setup needed
- **Auto-configuration**: Minimal configuration required
- **Production-ready**: Built-in health checks and metrics

### 🐳 Docker Benefits

| Benefit | Description |
|---------|-------------|
| 🎯 **Portability** | Runs anywhere Docker is installed |
| 🔒 **Isolation** | App runs in its own environment |
| 📦 **No Dependencies** | No need to install Java or Maven |
| ⚡ **Fast Startup** | Container starts in seconds |
| 🔄 **Consistent** | Same behavior dev to production |

---

## 🔍 Verification & Testing

### Check Running Container
```bash
docker ps | grep sb-app
```

### View Application Logs
```bash
docker logs sb-app
```

### Test the API Endpoint
```bash
curl http://localhost:8080
```

### Check Image Size
```bash
docker images spring-boot-app
```

### Build Locally (Without Docker)
```bash
./mvnw clean package
java -jar target/*.jar
```

---

## 🏗️ For Developers

### Local Development Workflow

1. **Modify the code** in `src/main/java/`
2. **Rebuild the image**: `docker build -t spring-boot-app:latest .`
3. **Stop old container**: `docker stop sb-app && docker rm sb-app`
4. **Run new version**: `docker run -d -p 8080:8080 --name sb-app spring-boot-app:latest`

### Push to Docker Hub (Your Own Repository)

```bash
docker tag spring-boot-app:latest your-username/spring-boot-app:1.0
docker push your-username/spring-boot-app:1.0
```

### Environment Variables

Configure the app using environment variables:

```bash
docker run -p 8080:8080 -e SERVER_PORT=9090 spring-boot-app:latest
```

---

## 🚀 Deployment Options

This containerized application can run on:

- 💻 **Local Machine** - Docker Desktop
- ☁️ **Cloud Platforms** - AWS ECS, Azure Container Instances, Google Cloud Run
- ☸️ **Kubernetes** - Any K8s cluster (EKS, AKS, GKE)
- 🖥️ **Virtual Machines** - EC2, Azure VMs with Docker installed
- 🐳 **Docker Swarm** - Multi-host orchestration

---

## 🚀 Next Steps & Enhancements

Ready to expand? Try adding:

- 🗄️ **Database Integration** - Add PostgreSQL or MySQL
- 🔐 **Authentication** - Implement JWT security
- 📊 **Monitoring** - Add Prometheus metrics
- 🧪 **Testing** - Include unit and integration tests
- 🔄 **CI/CD Pipeline** - Automate builds with GitHub Actions
- 📝 **API Documentation** - Add Swagger/OpenAPI

---

## 📊 Project Status

**Level**: 🟡 Intermediate  
**Status**: ✅ Completed  
**Learning Time**: ~3-4 hours  
**Difficulty**: ⭐⭐⭐ (3/5)

---

💡 **Pro Tip**: This project is a foundation for microservices architecture. Once you understand containerizing a single Spring Boot app, scaling to multiple services becomes straightforward!