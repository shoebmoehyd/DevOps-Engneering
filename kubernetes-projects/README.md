# ☸️ Kubernetes Projects Collection

A comprehensive hands-on collection of Kubernetes projects covering container orchestration from basics to production-ready deployments. These projects demonstrate practical K8s concepts and best practices used in real-world scenarios.

## 📋 Projects Overview

### 1. 🎈 **basic-pod-deployment**
**Status:** ✅ Completed | **Level:** Beginner

Introduction to Kubernetes pods - the smallest deployable units. Learn pod lifecycle, kubectl basics, labels, and annotations.

**What you'll learn:**
- Pod creation and management
- kubectl commands
- Pod lifecycle and states
- Labels and selectors
- Pod logs and debugging

---

### 2. 📦 **deployments-replicasets**
**Status:** ✅ Completed | **Level:** Beginner

Deployments for scalable and reliable applications. Master rolling updates, rollbacks, and replica management.

**What you'll learn:**
- Deployment strategies
- ReplicaSets management
- Rolling updates and rollbacks
- Scaling applications
- Deployment history

---

### 3. 🌐 **services-networking**
**Status:** ✅ Completed | **Level:** Beginner

Service types and networking in Kubernetes. Expose applications using ClusterIP, NodePort, and LoadBalancer services.

**What you'll learn:**
- Service types (ClusterIP, NodePort, LoadBalancer)
- Service discovery
- DNS in Kubernetes
- Endpoints management
- Port forwarding

---

### 4. 🔧 **configmaps-secrets**
**Status:** ✅ Completed | **Level:** Intermediate

Configuration and secrets management in Kubernetes. Decouple configuration from application code securely.

**What you'll learn:**
- ConfigMaps for configuration
- Secrets for sensitive data
- Environment variables
- Volume mounts for configs
- Security best practices

---

### 5. 💾 **persistent-storage**
**Status:** ✅ Completed | **Level:** Intermediate

Persistent storage in Kubernetes. Work with PersistentVolumes, PersistentVolumeClaims, and StatefulSets for stateful applications.

**What you'll learn:**
- PersistentVolumes (PV)
- PersistentVolumeClaims (PVC)
- StorageClasses
- StatefulSets for databases
- Volume lifecycle

---

### 6. 🚀 **multi-tier-application**
**Status:** ✅ Completed | **Level:** Intermediate

Full-stack application deployment with frontend, backend, and database. Demonstrates service communication and namespace isolation.

**What you'll learn:**
- Multi-container deployments
- Service-to-service communication
- Namespace isolation
- Full application stack
- Environment configuration

---

### 7. 🔀 **ingress-load-balancing**
**Status:** ✅ Completed | **Level:** Advanced

Ingress controllers for HTTP/HTTPS routing. Implement path-based and host-based routing with SSL/TLS termination.

**What you'll learn:**
- Ingress controllers (Nginx)
- Path-based routing
- Host-based routing
- TLS/SSL certificates
- Load balancing strategies

---

### 8. ❤️ **health-checks-autoscaling**
**Status:** ✅ Completed | **Level:** Advanced

Production-ready deployments with health checks and autoscaling. Implement liveness/readiness probes and Horizontal Pod Autoscaler.

**What you'll learn:**
- Liveness probes
- Readiness probes
- Horizontal Pod Autoscaler (HPA)
- Resource limits and requests
- Production best practices

---

## 🎯 Getting Started

### Prerequisites

- **Docker knowledge** (completed docker-projects)
- **Kubernetes cluster**: Minikube, Kind, or Docker Desktop
- **kubectl** installed and configured
- Basic YAML knowledge

### Setup Your Environment

**Install Minikube (recommended for learning):**
```bash
# Windows (using Chocolatey)
choco install minikube

# Start cluster
minikube start

# Verify
kubectl cluster-info
kubectl get nodes
```

**Or use Docker Desktop:**
- Enable Kubernetes in Docker Desktop settings
- Wait for K8s to start
- Verify with `kubectl get nodes`

---

## 📚 Recommended Learning Path

Follow projects in order for best learning experience:

**Beginner (Projects 1-3):**
1. basic-pod-deployment
2. deployments-replicasets
3. services-networking

**Intermediate (Projects 4-6):**
4. configmaps-secrets
5. persistent-storage
6. multi-tier-application

**Advanced (Projects 7-8):**
7. ingress-load-balancing
8. health-checks-autoscaling

---

## 💡 Purpose

These projects provide hands-on experience with Kubernetes, covering 85-90% of what you'll use as a DevOps engineer. Each project builds on previous knowledge and includes working manifests, documentation, and real-world scenarios.

---

## 🚀 Future Extensions

After completing these 8 projects, consider adding:
- **Jobs & CronJobs** - Batch processing and scheduled tasks
- **RBAC & Security** - Role-based access control
- **Helm Charts** - Package management for K8s
- **Monitoring** - Prometheus & Grafana integration

---

**Legend:**
- ✅ Completed
- 🔄 In Progress
- 📝 Planned
