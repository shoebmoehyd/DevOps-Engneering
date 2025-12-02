# 🏗️ Project 6: Multi-tier Application

**Level:** Intermediate | **Status:** 🚧 In Progress

## 📚 What You'll Learn

Welcome to Project 6! Time to put everything together! 🎉

In this project, you'll:
- Deploy Frontend + Backend + Database
- Connect them using Services
- Use ConfigMaps for app config
- Use Secrets for passwords
- Use PVCs for database storage

**Everything from Projects 1-5 combined!**

---

## 🎯 What is a Multi-tier App?

**3 layers working together:**
- 🎨 **Frontend** - React app (users see this)
- ⚙️ **Backend** - Node.js API (business logic)
- 🗄️ **Database** - MySQL (stores data)

**Like a restaurant:**
- Frontend = Dining area (customers)
- Backend = Kitchen (cooks)
- Database = Pantry (ingredients)

---

## 📁 What You'll Build

```
06-multi-tier-application/
├── README.md
└── manifests/
    ├── database.yaml
    ├── backend.yaml
    └── frontend.yaml
```

**That's it!** Each file has EVERYTHING for that tier (deployment + service + config).

---

## 🚀 Setup

```bash
cd C:\Users\shoeb\My Learnings\DevOps-Engneering\kubernetes-projects\06-multi-tier-application
mkdir manifests
```

---

## 📝 Exercise 1: Deploy the Database

**Start with the foundation - MySQL!**

**Your mission:** Create `manifests/database.yaml`

**What it needs:**
- Secret for password
- PVC for 1Gi storage
- MySQL Deployment
- ClusterIP Service (internal only!)

**YAML structure:**
```yaml
# Secret
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
stringData:
  password: "mypassword"
---
# PVC
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: db-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
---
# Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: database
spec:
  replicas: 1
  selector:
    matchLabels:
      app: database
  template:
    metadata:
      labels:
        app: database
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: password
        - name: MYSQL_DATABASE
          value: myapp
        ports:
        - containerPort: 3306
        volumeMounts:
        - name: db-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: db-storage
        persistentVolumeClaim:
          claimName: db-pvc
---
# Service
apiVersion: v1
kind: Service
metadata:
  name: database
spec:
  selector:
    app: database
  ports:
  - port: 3306
```

**Deploy it:**
```bash
kubectl apply -f manifests/database.yaml
kubectl get pods -l app=database
```

**Database ready!** 🎉

---

## 📝 Exercise 2: Deploy the Backend

**Backend talks to database!**

**Your mission:** Create `manifests/backend.yaml`

**Simple Node.js API:**
- ConfigMap for DB connection
- Deployment with 2 replicas
- ClusterIP Service

**YAML structure:**
```yaml
# ConfigMap
apiVersion: v1
kind: ConfigMap
metadata:
  name: backend-config
data:
  DB_HOST: "database"
  DB_NAME: "myapp"
---
# Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: nginx:alpine  # Placeholder - use your backend image
        env:
        - name: DB_HOST
          valueFrom:
            configMapKeyRef:
              name: backend-config
              key: DB_HOST
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: password
        ports:
        - containerPort: 3000
---
# Service
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  selector:
    app: backend
  ports:
  - port: 3000
```

**Deploy it:**
```bash
kubectl apply -f manifests/backend.yaml
kubectl get pods -l app=backend
```

**Backend ready!** ⚙️

---

## 📝 Exercise 3: Deploy the Frontend

**Users see this!**

**Your mission:** Create `manifests/frontend.yaml`

**React app:**
- ConfigMap for backend URL
- Deployment with 3 replicas
- NodePort Service (external access!)

**YAML structure:**
```yaml
# ConfigMap
apiVersion: v1
kind: ConfigMap
metadata:
  name: frontend-config
data:
  BACKEND_URL: "http://backend:3000"
---
# Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 3
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
        image: nginx:alpine  # Placeholder - use your frontend image
        env:
        - name: BACKEND_URL
          valueFrom:
            configMapKeyRef:
              name: frontend-config
              key: BACKEND_URL
        ports:
        - containerPort: 80
---
# Service
apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  type: NodePort
  selector:
    app: frontend
  ports:
  - port: 80
    nodePort: 30080
```

**Deploy it:**
```bash
kubectl apply -f manifests/frontend.yaml
kubectl get pods -l app=frontend
```

**Access it:**
```bash
minikube service frontend --url
```

**Frontend ready!** 🎨

---

## 📝 Exercise 4: Test the Full Stack

**Check everything's running:**

```bash
kubectl get all
kubectl get pvc
```

**Test connections:**
```bash
# Backend can reach database?
kubectl exec -it <backend-pod> -- sh
# Inside: ping database (should resolve!)

# Frontend can reach backend?
kubectl exec -it <frontend-pod> -- sh
# Inside: wget -qO- http://backend:3000
```

**Full stack deployed!** 🎉

---

## 💡 Key Takeaways

✅ Multi-tier = Frontend + Backend + Database  
✅ Services connect tiers (DNS names!)  
✅ ConfigMaps for non-sensitive config  
✅ Secrets for passwords  
✅ PVCs for database persistence  
✅ ClusterIP for internal, NodePort for external  
✅ Everything from Projects 1-5 combined!  

---

## 🚀 What's Next?

**Problem:** NodePort is messy (random ports!). Production needs proper URLs!

**Solution:** Project 7 teaches **Ingress** - Real URLs like `myapp.com`! (Using Helm!)

---

**You built a full application stack! 🏗️**
