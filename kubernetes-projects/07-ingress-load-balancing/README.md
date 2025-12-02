# 🌐 Project 7: Ingress & Load Balancing

**Level:** Advanced | **Status:** ✅ Complete

## 📚 What You'll Learn

Welcome to Project 7! Time to learn **production-grade routing**! 🚀

In this project, you'll:
- Install and use **Helm** (Kubernetes package manager)
- Deploy **NGINX Ingress Controller**
- Route traffic with **real URLs** (no more NodePort!)
- Handle multiple apps on one IP
- Learn **path-based** and **host-based** routing

**Say goodbye to port 30080! Hello `myapp.com`!** 🎉

---

## 🎯 What is Ingress?

**Before (NodePort):**
- Frontend: `http://192.168.49.2:30080` 😵
- Backend: `http://192.168.49.2:30081` 😵
- Every app needs a random port!

**After (Ingress):**
- Frontend: `http://myapp.local` 😎
- Backend: `http://api.myapp.local` 😎
- One IP, multiple apps, clean URLs!

**Like an airport:**
- NodePort = Each plane needs its own runway (port)
- Ingress = One terminal routes all planes to gates (apps)

---

## 🎯 What is Helm?

**Helm = App Store for Kubernetes**

Instead of writing 20 YAML files, install apps with one command:

```bash
helm install my-app app-chart
```

**Like Docker Compose for Kubernetes!**

**3 key concepts:**
1. **Chart** - Package of YAML files (like a zip file)
2. **Release** - Installed instance of a chart
3. **Repository** - Store of charts (like npm, apt)

---

## 📁 What You'll Build

```
07-ingress-load-balancing/
├── README.md
├── helm-chart/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│       ├── app1-deployment.yaml
│       ├── app2-deployment.yaml
│       ├── services.yaml
│       └── ingress.yaml
└── manifests/
    └── test-ingress.yaml
```

**Using Helm for the first time!**

---

## 🚀 Setup: Install Helm & Ingress Controller

**Before we start, you need two tools:**

### 1. Install Helm (if not installed)

```bash
# Check if you have it
helm version

# Windows (PowerShell as Admin):
choco install kubernetes-helm

# Or download directly from: https://github.com/helm/helm/releases
```

### 2. Install NGINX Ingress Controller

```bash
# Add Helm repo
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install (use port 30081 if 30080 is taken)
helm install nginx-ingress ingress-nginx/ingress-nginx \
  --set controller.service.type=NodePort \
  --set controller.service.nodePorts.http=30081

# Verify
kubectl get pods -l app.kubernetes.io/name=ingress-nginx
```

**Ready! Now let's build!** 🎉

---

## 📝 Exercise 1: Path-Based Routing

**Challenge:** Route different URLs to different apps!

**Scenario:** You have 2 microservices. Users should access:
- `http://yourapp:30081/app1` → App 1
- `http://yourapp:30081/app2` → App 2

**Your mission:** Create `manifests/test-ingress.yaml` with:
1. Two deployments (app1, app2) using `hashicorp/http-echo`
2. Two ClusterIP services
3. One Ingress with path-based routing

**Hints:**
- Use `hashicorp/http-echo` with args: `["-text=Hello from App 1!"]`
- Ingress needs `ingressClassName: nginx`
- Add annotation: `nginx.ingress.kubernetes.io/rewrite-target: /`

**Solution structure:**
```yaml
# App 1 Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app1
spec:
  replicas: 2
  selector:
    matchLabels:
      app: app1
  template:
    metadata:
      labels:
        app: app1
    spec:
      containers:
      - name: app1
        image: hashicorp/http-echo
        args:
        - "-text=Hello from App 1!"
        ports:
        - containerPort: 5678
---
# App 2 Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app2
spec:
  replicas: 2
  selector:
    matchLabels:
      app: app2
  template:
    metadata:
      labels:
        app: app2
    spec:
      containers:
      - name: app2
        image: hashicorp/http-echo
        args:
        - "-text=Hello from App 2!"
        ports:
        - containerPort: 5678
---
# App 1 Service
apiVersion: v1
kind: Service
metadata:
  name: app1-service
spec:
  selector:
    app: app1
  ports:
  - port: 5678
---
# App 2 Service
apiVersion: v1
kind: Service
metadata:
  name: app2-service
spec:
  selector:
    app: app2
  ports:
  - port: 5678
---
# Ingress - Path-based routing
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /app1
        pathType: Prefix
        backend:
          service:
            name: app1-service
            port:
              number: 5678
      - path: /app2
        pathType: Prefix
        backend:
          service:
            name: app2-service
            port:
              number: 5678
```

**Deploy and test:**
```bash
kubectl apply -f manifests/test-ingress.yaml
kubectl get ingress

# Test from inside cluster
kubectl run test-curl --image=curlimages/curl --rm -it --restart=Never -- \
  curl http://nginx-ingress-ingress-nginx-controller/app1

kubectl run test-curl --image=curlimages/curl --rm -it --restart=Never -- \
  curl http://nginx-ingress-ingress-nginx-controller/app2
```

**Expected output:**
- App1: "Hello from App 1!"
- App2: "Hello from App 2!"

**Path-based routing complete!** 🎉

---

## 📝 Exercise 2: Build Your First Helm Chart

**Challenge:** Package the multi-tier app (from Project 6) as a reusable Helm Chart!

**Why Helm?** Imagine installing your entire app (frontend + backend + database) with ONE command instead of writing 10+ YAML files. That's Helm!

**Your mission:** 
1. Create chart structure: `helm-chart/Chart.yaml`, `values.yaml`, `templates/`
2. Convert Project 6 YAMLs to templates with `{{ .Values.* }}`
3. Make it configurable!

**Structure:**
```
helm-chart/
├── Chart.yaml        # Chart metadata
├── values.yaml       # Configuration (change values here!)
└── templates/
    ├── frontend.yaml
    ├── backend.yaml
    ├── database.yaml
    └── ingress.yaml
```

**Step 1: Create `Chart.yaml`**
```yaml
apiVersion: v2
name: myapp
description: Multi-tier application with Ingress
version: 1.0.0
appVersion: "1.0"
```

**Step 2: Create `values.yaml` (your config file!)**
```yaml
# Configuration values
frontend:
  replicas: 2
  image: nginx:alpine

backend:
  replicas: 2
  image: nginx:alpine

database:
  replicas: 1
  image: mysql:8.0
  password: "mypassword"
  storageSize: 1Gi

ingress:
  enabled: true
  host: myapp.local
```

**Step 3: Create templates** (see full YAML in `helm-chart/templates/`)

**Key concept:** Use `{{ .Values.frontend.replicas }}` instead of hardcoding `2`

**Example - `templates/frontend.yaml`:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: {{ .Values.frontend.replicas }}
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: {{ .Values.frontend.image }}
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  selector:
    app: frontend
  ports:
  - port: 80
```

**Also create `backend.yaml`, `database.yaml`, and `ingress.yaml` in templates!**

**Pro tip:** The `{{- if .Values.ingress.enabled }}` lets you toggle features on/off!

---

## 📝 Exercise 3: Deploy with Helm

**Now the magic happens!** Install your entire stack with ONE command:

```bash
cd C:\Users\shoeb\My Learnings\DevOps-Engneering\kubernetes-projects\07-ingress-load-balancing
helm install myapp ./helm-chart
```

**That's it!** Frontend + Backend + Database + Ingress all deployed!

**Check it:**
```bash
helm list
kubectl get all
kubectl get ingress
```

**Try these Helm superpowers:**

```bash
# Scale frontend to 5 replicas (no YAML editing!)
helm upgrade myapp ./helm-chart --set frontend.replicas=5
kubectl get pods -l app=frontend

# Made a mistake? Rollback!
helm rollback myapp
kubectl get pods -l app=frontend

# Clean up
helm uninstall myapp
```

**See the power?** Change `values.yaml` or use `--set`, then `helm upgrade`. No manual YAML editing! 🎉

---

## 📝 Exercise 4: Host-Based Routing

**Challenge:** Route different **domains** instead of paths!

**Scenario:** You want:
- `app1.local` → App 1
- `app2.local` → App 2

Instead of messy `/app1`, `/app2` paths!

**Your mission:** Create `manifests/host-ingress.yaml` with host-based rules

**Structure:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: host-ingress
spec:
  ingressClassName: nginx
  rules:
  - host: app1.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app1-service
            port:
              number: 5678
  - host: app2.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app2-service
            port:
              number: 5678
```

**Deploy and test:**
```bash
kubectl apply -f manifests/host-ingress.yaml
kubectl get ingress

# Test with Host header
kubectl run test-curl --image=curlimages/curl --rm -it --restart=Never -- \
  curl -H "Host: app1.local" http://nginx-ingress-ingress-nginx-controller

kubectl run test-curl --image=curlimages/curl --rm -it --restart=Never -- \
  curl -H "Host: app2.local" http://nginx-ingress-ingress-nginx-controller
```

**Expected:**
- app1.local → "Hello from App 1!"
- app2.local → "Hello from App 2!"

**Clean URLs achieved!** 🎉

**Bonus:** Add to `C:\Windows\System32\drivers\etc\hosts` to use real domains locally!

---

## 💡 Key Takeaways

✅ **Helm** = Package manager for Kubernetes  
✅ **Charts** = Reusable app templates  
✅ **Ingress** = Smart routing (no more NodePorts!)  
✅ **Path-based routing** = `/app1`, `/app2`  
✅ **Host-based routing** = `app1.local`, `app2.local`  
✅ **One IP, many apps** = Production-ready!  
✅ **values.yaml** = Easy configuration management  

---

## 🚀 What's Next?

**Problem:** Apps crash! No health checks! No auto-scaling!

**Solution:** Project 8 teaches **Health Checks & Autoscaling** - Keep apps alive and handle traffic spikes!

---

**You mastered production routing! 🌐**
