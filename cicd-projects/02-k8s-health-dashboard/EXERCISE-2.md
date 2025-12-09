# 📝 Exercise 2: Create React Frontend

**🎯 Goal:** Build a simple React dashboard that displays Kubernetes cluster data from your backend API.

**⏱️ Time:** 15-20 minutes

---

## 📂 What We're Building

```
frontend/
├── package.json       ← Dependencies
├── index.html         ← Main HTML file
├── src/
│   ├── App.jsx        ← Main React component
│   ├── main.jsx       ← Entry point
│   └── App.css        ← Styles
└── vite.config.js     ← Build configuration
```

---

## 🎨 What It Will Look Like

A clean dashboard showing:
- 📊 **Cluster Summary** - Total pods, nodes, deployments
- 📦 **Pod List** - Name, status, namespace (with color coding)
- 💻 **Node Information** - Status and version
- 🔄 **Auto-refresh** - Updates every 10 seconds

---

## 🚀 Step 1: Initialize React Project with Vite

**What is Vite?** A fast build tool for modern web apps (much faster than Create React App!)

**Run these commands:**

```bash
cd "C:/Users/shoeb/My Learnings/DevOps-Engneering/cicd-projects/02-k8s-health-dashboard"

# Create React app with Vite
npm create vite@latest frontend -- --template react

# Navigate to frontend folder
cd frontend

# Install dependencies
npm install
```

**Expected output:**
```
✔ Project created!
✔ Dependencies installed!
```

**Wait for this to complete before continuing!**

---

## 🚀 Step 2: Test the Dashboard! ✅

**Files created! ✅**
- `App.jsx` - Complete dashboard with cluster data
- `App.css` - Beautiful purple gradient theme

**Now let's run it!**

### **First: Make sure your backend is running**

Open a **NEW terminal** and start the backend:

```bash
cd "C:/Users/shoeb/My Learnings/DevOps-Engneering/cicd-projects/02-k8s-health-dashboard/backend"

npm start
```

**You should see:** `🚀 K8s Health Dashboard Backend Started!`

**Keep this terminal open!**

---

### **Second: Start the frontend**

In your **current terminal** (in the frontend folder):

```bash
# Make sure you're in the frontend folder
cd "C:/Users/shoeb/My Learnings/DevOps-Engneering/cicd-projects/02-k8s-health-dashboard/frontend"

# Start the dev server
npm run dev
```

**Expected output:**
```
VITE v5.x.x  ready in xxx ms

➜  Local:   http://localhost:5173/
➜  press h + enter to show help
```

---

### **Third: Open in Browser**

**Open your browser and go to:** `http://localhost:5173/`

**You should see:**
- 🎨 Beautiful purple gradient background
- 📊 Cluster summary cards (Nodes, Pods, Deployments)
- 📦 Table of all pods with status colors
- 🖥️ Table of nodes
- 🔄 Auto-refresh every 10 seconds

---

## ✅ Success Checklist

- ✅ Backend running on port 3000
- ✅ Frontend running on port 5173
- ✅ Dashboard displays cluster data
- ✅ Pod status shows with colors (green = running, orange = pending)
- ✅ Refresh button works

---

## 🎓 What You Learned

- ✅ React fundamentals (components, hooks, state)
- ✅ Vite build tool (fast development server)
- ✅ Fetching data from APIs (fetch, async/await)
- ✅ Modern JavaScript (ES6+, destructuring, arrow functions)
- ✅ Responsive CSS design
- ✅ Frontend ↔ Backend communication

---

## 🐛 Troubleshooting

**If you see "Failed to fetch data":**
- Make sure backend is running on port 3000
- Check backend terminal for errors
- Make sure Minikube is running: `minikube status`

**If dashboard doesn't load:**
- Check frontend terminal for errors
- Try refreshing the browser
- Make sure you're on `http://localhost:5173/`

---

## 🎉 Exercise 2 Complete!

**When your dashboard is showing cluster data, come back and tell me "Exercise 2 done"!**

**Next:** Exercise 3 - We'll package both frontend and backend together! 🚀
