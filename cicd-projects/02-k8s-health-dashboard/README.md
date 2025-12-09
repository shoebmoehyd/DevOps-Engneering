# K8s Health Dashboard

**Status:** ✅ Complete | **Level:** Intermediate | **Time:** ~6-8 hours across all components

> A production-ready real-time Kubernetes cluster monitoring dashboard. Query your cluster's state, visualize pod health, and deploy via CI/CD. Learn K8s API programming, React frontends, and automated deployments.

---

## What You've Built

A **working DevOps tool** that demonstrates:
- **Backend (Node.js):** REST API querying the Kubernetes cluster via @kubernetes/client-node
- **Frontend (React):** Real-time dashboard with auto-refresh and status indicators
- **Containerization:** Multi-stage Docker builds (backend, frontend + nginx)
- **K8s Deployment:** Full manifests for Deployments, Services, RBAC, ConfigMaps
- **CI/CD Pipeline:** GitHub Actions for automated tests, builds, and image pushes
- **Testing:** Jest unit tests with ESM support, integrated into CI

### Dashboard Features

The dashboard displays:
- 🟢 **Pod Status** - Live pod state (Running, Pending, Failed) with color indicators
- 📊 **Nodes** - Cluster node list with readiness state
- 🚀 **Deployments** - Active deployments and their replica status
- 🔄 **Auto-Refresh** - Updates every 10 seconds (toggle on/off)
- ⏱️ **Timestamps** - Last update time to track freshness
- 🔍 **Error Handling** - User-friendly messages and retry buttons

---

## Quick Start

### 1. Prerequisites

Ensure you have:
- `kubectl` installed and configured
- `minikube` running (or Docker Desktop K8s)
- `docker` for building images
- Node.js 18+ and npm

### 2. Start Your Cluster

```bash
# Start Minikube
minikube start

# On Windows PowerShell: configure Docker daemon
minikube -p minikube docker-env --shell powershell | Invoke-Expression

# Verify cluster is ready
kubectl get nodes
```

### 3. Deploy the Application

```bash
# From repo root, deploy all K8s manifests
kubectl apply -f k8s/

# Verify pods are running
kubectl get pods --watch
```

### 4. Access the Dashboard

```bash
# Port-forward frontend (in one terminal)
kubectl port-forward service/frontend-service 8080:80

# Port-forward backend (in another terminal, optional but recommended)
kubectl port-forward service/backend-service 3000:3000

# Open browser
# http://localhost:8080
```

Once open, you should see your cluster's real-time status in seconds.

---

## Project Structure

```
.
├── backend/                          # Node.js Express API
│   ├── server.js                     # Main server (ES modules)
│   ├── package.json                  # Dependencies & test scripts
│   ├── jest.config.js                # Test configuration
│   ├── tests/
│   │   └── api.test.js               # API endpoint tests
│   ├── Dockerfile                    # Multi-stage build for production
│   └── .dockerignore
├── frontend/                         # React + Vite
│   ├── src/
│   │   ├── App.jsx                   # Main React component
│   │   ├── App.css                   # Styling
│   │   └── main.jsx                  # Entry point
│   ├── nginx.conf                    # Production Nginx config
│   ├── Dockerfile                    # Multi-stage build (Vite → Nginx)
│   └── package.json
├── k8s/                              # Kubernetes manifests
│   ├── backend-deployment.yaml       # Backend Deployment
│   ├── backend-service.yaml          # Backend ClusterIP Service
│   ├── frontend-deployment.yaml      # Frontend Deployment
│   ├── frontend-service.yaml         # Frontend NodePort Service
│   ├── rbac.yaml                     # ServiceAccount & RBAC rules
│   └── configmap.yaml                # Environment config
├── .github/workflows/                # CI/CD automation
│   ├── k8s-backend-ci.yml            # Backend: test, build, push
│   ├── k8s-frontend-ci.yml           # Frontend: build, push
│   └── k8s-deploy.yml                # Manual deploy workflow
├── Dockerfile                        # (Legacy, use language-specific ones)
└── README.md
```

---

## How It Works

### Backend Flow
1. **Server Load:** On startup, loads `~/.kube/config` (your Minikube credentials)
2. **K8s API Client:** Initializes `@kubernetes/client-node` API clients
3. **Endpoints:** Exposes `/api/cluster`, `/api/pods`, `/api/nodes`, `/api/health`
4. **CORS:** Enabled for frontend communication

### Frontend Flow
1. **Mount:** Component fetches data on initial load
2. **Parallel Requests:** Fetches cluster, pods, nodes in parallel
3. **Auto-Refresh:** Sets 10-second interval for live updates
4. **UI Render:** Displays pods with color-coded status badges
5. **Error Handling:** Shows friendly messages + retry button if API unavailable

### Deployment Flow
1. **K8s Manifests:** Deployments, Services, and RBAC configured
2. **Port-Forward:** Local access via `kubectl port-forward`
3. **CI/CD:** GitHub Actions tests, builds, pushes images on every commit
4. **Image Updates:** Deploy workflow patches `k8s/` manifests with new image tags

---

## Development

### Run Backend Locally

```bash
cd backend

# Install dependencies
npm ci

# Start server (connects to Minikube cluster)
npm start

# Run tests (with coverage)
npm test
```

### Run Frontend Locally

```bash
cd frontend

# Install dependencies
npm ci

# Start dev server (Vite)
npm run dev

# Build for production
npm run build
```

### Testing

Backend uses Jest + Supertest:

```bash
cd backend

# Run all tests with coverage
npm test

# Tests cover API endpoints and error handling
```

---

## Learning Highlights

### K8s API Programming
- Loading kubeconfig and authenticating to your cluster
- Making async API calls to fetch cluster state
- Error handling when cluster is unavailable

### React Frontend Development
- useState and useEffect hooks for data fetching
- Parallel API requests with Promise.all
- Auto-refresh intervals and cleanup
- Error boundaries and user-friendly error messages

### Containerization
- Multi-stage Dockerfiles for optimized images
- Frontend: Vite build → Nginx container
- Backend: Node Alpine image for smaller size

### K8s Deployment
- Deployments with replicas and rolling updates
- Services (ClusterIP for internal, exposed endpoints)
- ServiceAccount and RBAC for API access
- ConfigMaps for environment configuration

### CI/CD Automation
- GitHub Actions workflows
- Automated testing in CI
- Docker image builds and pushes
- Declarative K8s manifest updates

---

## Troubleshooting

### "Failed to fetch data from backend"
- Verify backend pod is running: `kubectl get pods`
- Check backend logs: `kubectl logs -f deployment/k8s-dashboard-backend`
- Ensure port-forward is active: `kubectl port-forward service/backend-service 3000:3000`

### "Cannot connect to Minikube cluster"
- Start Minikube: `minikube start`
- Check context: `kubectl config current-context`
- Verify kubeconfig: `kubectl config view`

### Frontend shows "Loading..." forever
- Check if backend is accessible: `curl http://localhost:3000/api/health`
- Verify both port-forwards are running (frontend 8080, backend 3000)

### Tests failing in CI
- Tests use Node ESM: `node --experimental-vm-modules jest`
- Verify jest.config.js has proper extensionsToTreatAsEsm
- Local tests: `npm test` from `backend/` directory

---

## Next Steps

### Extend the Dashboard
- Add deployment event history (rollout tracking)
- Display resource requests/limits per pod
- Add namespace selector to filter pods
- Create alerts for pod failures

### Production Hardening
- Add authentication (OAuth2 / JWT)
- Implement role-based access (only view certain namespaces)
- Add rate limiting to API endpoints
- Secure image registry with private Docker Hub account

### Advanced Automation
- ArgoCD for GitOps-style deployments
- Helm charts for template-based deployments
- Multi-environment support (dev/staging/prod)

---

## Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Backend** | Node.js, Express, @kubernetes/client-node | REST API, K8s API queries |
| **Frontend** | React, Vite | Real-time UI, fast dev builds |
| **Containerization** | Docker, multi-stage builds | Optimized production images |
| **Orchestration** | Kubernetes, Minikube | Deployment & service discovery |
| **CI/CD** | GitHub Actions | Automated tests, builds, deploys |
| **Testing** | Jest, Supertest | Unit & API testing, coverage |

---

## Key Takeaways

✅ **You've learned:**
- How to programmatically query Kubernetes clusters
- Real-time frontend development patterns
- Complete containerization workflow
- K8s deployment with manifests
- Automated CI/CD pipeline setup
- Testing in production pipelines

✅ **You've built:**
- A production-ready dashboard tool
- A complete DevOps learning project
- A portfolio piece that impresses recruiters

This project demonstrates that DevOps isn't just infrastructure—it's building tools that make infrastructure visible and manageable. 🚀
