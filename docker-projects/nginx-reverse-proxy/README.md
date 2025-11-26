# 🔀 Nginx Reverse Proxy

Nginx reverse proxy routing traffic to multiple containerized applications. Demonstrates path-based routing, load balancing, and service orchestration.

**🎯 Purpose**: Learn reverse proxy configuration, traffic routing, and service discovery in Docker.

---

## 🚀 Quick Start

```bash
docker-compose up --build
```

**Access via Nginx (port 8080):**
- Info: http://localhost:8080
- Users: http://localhost:8080/users
- Products: http://localhost:8080/products

---

## 🌐 Architecture

```
Client Request
     ↓
Nginx (Port 8080)
     ↓
   Routing
     ├─→ /users → App1 (User Service:3001)
     └─→ /products → App2 (Product Service:3002)
```

---

## 🎯 Routing Rules

| Path | Backend Service | Port | Description |
|------|----------------|------|-------------|
| `/users` | app1 | 3001 | User Service API |
| `/products` | app2 | 3002 | Product Service API |
| `/nginx/health` | nginx | 80 | Proxy health check |

---

## 💡 What You'll Learn

- ✅ Nginx reverse proxy configuration
- ✅ Path-based routing
- ✅ Upstream server configuration
- ✅ Proxy headers (X-Real-IP, X-Forwarded-For)
- ✅ Service isolation with Docker networks
- ✅ Multi-container orchestration

---

## 🧪 Testing

**Test routing:**
```bash
# User service via proxy
curl http://localhost:8080/users

# Product service via proxy
curl http://localhost:8080/products

# Nginx health
curl http://localhost:8080/nginx/health
```

**Check proxy headers:**
```bash
docker logs nginx-proxy
```

**Verify network isolation:**
```bash
docker network inspect nginx-reverse-proxy_proxy-network
```

---

## 📁 Project Structure

```
nginx-reverse-proxy/
├── docker-compose.yml     # Orchestrates all services
├── nginx/
│   └── nginx.conf         # Proxy configuration
├── app1/
│   ├── Dockerfile
│   ├── server.js          # User Service
│   └── package.json
└── app2/
    ├── Dockerfile
    ├── server.js          # Product Service
    └── package.json
```

---

## 🔧 Configuration Highlights

**Upstream Servers:**
```nginx
upstream user_service {
    server app1:3001;
}
```

**Proxy Headers:**
```nginx
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
```

---

## ⚙️ Advanced Features

**Add load balancing:**
```yaml
# In docker-compose.yml, scale services:
docker-compose up --scale app1=3
```

**Update nginx.conf upstream:**
```nginx
upstream user_service {
    server app1:3001;
    server app1:3001;
    server app1:3001;
}
```

---

## ⚠️ Troubleshooting

**502 Bad Gateway?**
```bash
# Check backend services
docker-compose ps

# View nginx logs
docker logs nginx-proxy
```

**Port conflict?**
```yaml
# Change in docker-compose.yml:
ports:
  - "9090:80"
```

**Configuration not updating?**
```bash
docker-compose restart nginx
```

---

## 📈 Project Status

**Level**: 🔴 Advanced  
**Status**: ✅ Completed  
**Time**: ⏱️ 3-4 hours  
**Difficulty**: ⭐⭐⭐⭐ (4/5)

---

🔀 **Pro Tip**: Use reverse proxies to route traffic, handle SSL, and provide a single entry point for microservices!
