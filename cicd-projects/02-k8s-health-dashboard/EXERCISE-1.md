# 📝 Exercise 1: Setup Node.js Backend

**🎯 Goal:** Create a simple Node.js server that connects to your Kubernetes cluster and fetches pod information.

**⏱️ Time:** 10-15 minutes

---

## 📂 What We're Building

```
backend/
├── package.json          ← Node.js dependencies
├── server.js             ← Main server file (connects to K8s)
└── kubeconfig-helper.js  ← Helper to read kubeconfig
```

---

## 🚀 Step 1: Verify Node.js is Installed

Run this command:

```bash
node --version
```

**Expected output:** `v18.x.x` or `v20.x.x` or similar

**If you don't have Node.js:**
- Download from: https://nodejs.org/ (LTS version)
- Install it
- Restart your terminal
- Run `node --version` again

✅ **Got a version number?** Great! Continue to Step 2.

---

## 🚀 Step 2: Create package.json

**What is this?** Lists all the Node.js libraries we need.

**Run these commands:**

```bash
cd "C:\Users\shoeb\My Learnings\DevOps-Engneering\cicd-projects\02-k8s-health-dashboard\backend"

# This creates package.json
npm init -y
```

**Expected output:**
```
Wrote to package.json
```

✅ **Created!** Now let's install the Kubernetes library.

---

## 🚀 Step 3: Install Kubernetes Client Library

**What is this?** Official JavaScript library to talk to Kubernetes API.

**Run this command:**

```bash
npm install @kubernetes/client-node express cors
```

**What we're installing:**
- `@kubernetes/client-node` - Talk to Kubernetes
- `express` - Web server framework
- `cors` - Allow frontend to connect

**Expected output:**
```
added 50+ packages
```

✅ **Installed!** Now let's write the server code.

---

## 🚀 Step 4: Test Your Backend Server

**Files created! ✅**
- `server.js` - Main server with K8s API integration
- `package.json` - Updated with start script

**Now let's test it!**

### **First: Make sure Minikube is running**

```bash
# Check if Minikube is running
minikube status

# If not running, start it:
minikube start
```

**Expected output:**
```
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

### **Second: Start the backend server**

```bash
cd "C:/Users/shoeb/My Learnings/DevOps-Engneering/cicd-projects/02-k8s-health-dashboard/backend"

# Start the server
npm start
```

**Expected output:**
```
🚀 K8s Health Dashboard Backend Started!
📡 Server running on http://localhost:3000
✅ Kubeconfig loaded successfully!
📍 Current context: minikube

📍 Available endpoints:
   GET /api/health       - Health check
   GET /api/cluster      - Cluster summary
   GET /api/pods         - All pods
   GET /api/nodes        - All nodes
   GET /api/deployments  - All deployments
```

### **Third: Test the API (Open a NEW terminal)**

**Keep the server running, open a NEW Git Bash terminal, and test:**

```bash
# Test health endpoint
curl http://localhost:3000/api/health

# Test cluster summary
curl http://localhost:3000/api/cluster

# Test pods
curl http://localhost:3000/api/pods
```

**Expected:** You should see JSON data with your Kubernetes cluster information!

---

## ✅ Success Checklist

- ✅ Node.js installed
- ✅ Dependencies installed
- ✅ Minikube running
- ✅ Server starts without errors
- ✅ API endpoints return data

---

## 🎓 What You Learned

- ✅ Node.js project structure
- ✅ Express.js web server
- ✅ Kubernetes JavaScript client
- ✅ RESTful API design
- ✅ Connecting to K8s API

---

## 🐛 Troubleshooting

**If server won't start:**
- Make sure Minikube is running: `minikube status`
- Check Node.js is working: `node --version`

**If API returns errors:**
- Verify kubectl works: `kubectl get pods`
- Check kubeconfig exists: `ls ~/.kube/config`

**If "EADDRINUSE" error:**
- Port 3000 is in use, stop other servers or change PORT in server.js

---

## 🎉 Exercise 1 Complete!

**When your server is running and APIs return data, come back and tell me "Exercise 1 done"!**

**Next:** Exercise 2 - Create React Frontend! 🚀
