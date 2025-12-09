# 📝 Exercise 4: Deploy to Kubernetes

**🎯 Goal:** Deploy your K8s Health Dashboard to your Minikube cluster using Kubernetes manifests.

**⏱️ Time:** 25-30 minutes

---

## 📂 What We're Building

```
02-k8s-health-dashboard/
└── k8s/
    ├── backend-deployment.yaml    ← Backend pods
    ├── backend-service.yaml       ← Backend networking
    ├── frontend-deployment.yaml   ← Frontend pods
    ├── frontend-service.yaml      ← Frontend networking (NodePort)
    └── configmap.yaml            ← Configuration
```

---

## 🎯 Why Deploy to Kubernetes?

- ✅ **Real production environment** - Same as what companies use
- ✅ **Self-healing** - Pods restart automatically if they crash
- ✅ **Scaling** - Can easily run multiple replicas
- ✅ **Service discovery** - Pods can find each other by name
- ✅ **Rolling updates** - Zero-downtime deployments

---

## 📋 Prerequisites

**Make sure:**
- ✅ Minikube is running: `minikube status`
- ✅ Your Exercise 2 code works (backend + frontend)

---

## 🚀 Step 1: Create Kubernetes Manifests Directory

**Create the k8s folder:**

```bash
cd "C:/Users/shoeb/My Learnings/DevOps-Engneering/cicd-projects/02-k8s-health-dashboard"

mkdir k8s
```

**I'll create all the Kubernetes YAML files for you!**

---

## 🚀 Step 2: Build Docker Images with Minikube

**Important:** We'll build images **inside Minikube's Docker**, so they're available to Kubernetes!

```bash
# Point your terminal to Minikube's Docker daemon
eval $(minikube docker-env)

# Build backend image
cd backend
docker build -t k8s-dashboard-backend:v1 .

# Build frontend image  
cd ../frontend
docker build -t k8s-dashboard-frontend:v1 .

# Verify images
docker images | grep k8s-dashboard
```

**Expected output:**
```
k8s-dashboard-backend    v1    ...   2 minutes ago   ...
k8s-dashboard-frontend   v1    ...   1 minute ago    ...
```

---

## 🚀 Step 3: Deploy to Kubernetes

**Apply all manifests:**

```bash
cd "C:/Users/shoeb/My Learnings/DevOps-Engneering/cicd-projects/02-k8s-health-dashboard"

# Apply all Kubernetes resources
kubectl apply -f k8s/
```

**Expected output:**
```
configmap/dashboard-config created
deployment.apps/k8s-dashboard-backend created
service/backend-service created
deployment.apps/k8s-dashboard-frontend created
service/frontend-service created
```

---

## 🚀 Step 4: Verify Deployment

**Check if pods are running:**

```bash
kubectl get pods
```

**Expected output:**
```
NAME                                      READY   STATUS    RESTARTS   AGE
k8s-dashboard-backend-xxxxx              1/1     Running   0          30s
k8s-dashboard-frontend-xxxxx             1/1     Running   0          30s
```

**Check services:**

```bash
kubectl get services
```

**Expected output:**
```
NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
backend-service    ClusterIP   10.x.x.x        <none>        3000/TCP         1m
frontend-service   NodePort    10.x.x.x        <none>        80:30080/TCP     1m
```

---

## 🚀 Step 5: Access Your Dashboard

**Get the dashboard URL:**

```bash
minikube service frontend-service --url
```

**Expected output:**
```
http://192.168.49.2:30080
```

**Open that URL in your browser!** 🎉

---

## ✅ Success Checklist

- ✅ Docker images built in Minikube
- ✅ All pods running (2/2)
- ✅ Services created
- ✅ Dashboard accessible via Minikube IP
- ✅ Backend connecting to Kubernetes API
- ✅ Frontend displaying cluster data

---

## 🎓 What You Learned

- ✅ Kubernetes Deployments (managing pods)
- ✅ Kubernetes Services (networking)
- ✅ ConfigMaps (configuration management)
- ✅ NodePort service type (external access)
- ✅ Building images in Minikube
- ✅ kubectl commands
- ✅ Service discovery in K8s

---

## 🐛 Troubleshooting

**Pods not starting:**
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

**ImagePullBackOff error:**
- Make sure you built images with `eval $(minikube docker-env)`
- Check image names match in YAML files

**Backend can't connect to K8s API:**
```bash
# Check if ServiceAccount has proper permissions
kubectl get serviceaccount dashboard-sa
kubectl describe clusterrolebinding dashboard-cluster-reader
```

**Can't access dashboard:**
```bash
# Make sure Minikube is running
minikube status

# Get the correct URL
minikube service frontend-service --url
```

---

## 🔍 Useful Commands

**View all resources:**
```bash
kubectl get all
```

**Check pod logs:**
```bash
kubectl logs deployment/k8s-dashboard-backend
kubectl logs deployment/k8s-dashboard-frontend
```

**Restart deployment:**
```bash
kubectl rollout restart deployment/k8s-dashboard-backend
kubectl rollout restart deployment/k8s-dashboard-frontend
```

**Delete everything:**
```bash
kubectl delete -f k8s/
```

**Port forward (alternative access method):**
```bash
kubectl port-forward service/frontend-service 8080:80
# Then open http://localhost:8080
```

---

## 🎉 Exercise 4 Complete!

**When your dashboard is running in Kubernetes and accessible via browser, come back and tell me "Exercise 4 done"!**

**Next:** Exercise 5 - Setup CI/CD with GitHub Actions! 🚀

---

## 📝 Notes

**Why This Works Better Than Docker Compose:**
- Kubernetes handles service discovery automatically
- No Windows path issues with volumes
- Backend runs with ServiceAccount that has K8s API access
- More realistic production environment
- Proper container orchestration
