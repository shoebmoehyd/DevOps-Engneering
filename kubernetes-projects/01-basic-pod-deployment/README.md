# 🎈 Project 1: Basic Pod Deployment

**Level:** Beginner | **Status:** ✅ Complete

## 📚 What You'll Learn

Welcome to your first Kubernetes project! Think of pods as the "running containers" of Kubernetes. 

In this project, you'll:
- Deploy your first pod
- Use labels to organize pods
- Run multiple containers in one pod (sidecar pattern)
- Set resource limits to prevent crashes

By the end, you'll know how to deploy and debug applications in Kubernetes!

---

## 🎯 What is a Pod?

A **Pod** is like a small box that holds one or more containers. These containers:
- Share the same network (can talk to each other via `localhost`)
- Share storage
- Live and die together

**Think of it this way:**
- 🏠 Pod = House
- 📦 Container = Room in the house
- Most houses have 1 room (single container), some have 2+ rooms (multi-container)

---

## 💡 Why Learn This?

**Debugging:** When your app crashes, you'll use `kubectl logs` to see what went wrong

**Resource Limits:** Stop one app from eating all memory and crashing everything else

**Sidecar Pattern:** Add a helper container (for logging, monitoring) without changing your main app

**Organization:** Use labels to find pods easily in a sea of hundreds

---

## 📋 What We'll Build

```
01-basic-pod-deployment/
├── README.md                    # You are here!
├── nginx-pod.yaml              # Simple web server
└── manifests/
    ├── simple-pod.yaml         # Pod with labels
    ├── multi-container-pod.yaml # Main app + helper
    └── pod-with-resources.yaml  # Production-ready pod
```

---

## 🚀 Setup (Do This Once)

Make sure your environment is ready:

```bash
# Check Minikube is running
minikube status

# If not running, start it
minikube start --driver=docker

# Verify you can talk to the cluster
kubectl get nodes
```

✅ If you see a node with `STATUS: Ready`, you're good to go!

---

## 📝 Let's Deploy Pods!

> 💡 **Stuck on any exercise?** Check the YAML files in this project - they're your answer key!

---

### 🎯 Exercise 1: Your First Pod

**Let's launch a web server!**

Run these commands:

```bash
kubectl apply -f nginx-pod.yaml
kubectl get pods
```

**Watch it come alive!** 🚀 You'll see the status change from `ContainerCreating` → `Running`

**Now visit your web server:**
```bash
kubectl port-forward nginx-pod 8080:80
```

🌐 **Open your browser:** http://localhost:8080

See the nginx welcome page? **You just deployed your first Kubernetes app!** 🎉

**Clean up:**
```bash
kubectl delete pod nginx-pod
```

💡 **Notice:** The pod disappears forever when deleted. Project 2 fixes this!

---

### 🏷️ Exercise 2: Organize with Labels

**Think of labels as hashtags for your pods!**

```bash
kubectl apply -f manifests/simple-pod.yaml
kubectl get pods --show-labels
```

**See those labels?** `app=myapp`, `env=development`, `team=backend`

**Now filter like a pro:**
```bash
kubectl get pods -l app=myapp       # Show me app pods!
kubectl get pods -l env=development # Show me dev environment!
```

🤔 **Imagine:** You have 200 pods. How do you find YOUR app? **Labels are the answer!**

---

### 🤝 Exercise 3: Multi-Container Magic

**What if your app needs a helper?** Deploy them together!

```bash
kubectl apply -f manifests/multi-container-pod.yaml
kubectl get pods
```

**Look closely:** See `2/2`? That's **2 containers sharing the same pod!**

**Talk to each container:**
```bash
kubectl logs multi-container-pod -c main-app
kubectl logs multi-container-pod -c sidecar-logger
```

💡 **Real scenario:** Main app logs → Sidecar ships logs to monitoring system. **Zero code changes!**

---

### 💪 Exercise 4: Production-Ready Setup

**Don't let one pod crash your entire cluster!** Set resource limits.

```bash
kubectl apply -f manifests/pod-with-resources.yaml
kubectl describe pod resource-pod | Select-String -Pattern "Limits" -Context 0,5
```

**What you'll see:**
- **Requests:** 250m CPU, 128Mi RAM = "I need at least this much"
- **Limits:** 500m CPU, 256Mi RAM = "Don't let me use more than this"

❓ **What if it tries to use 300Mi RAM?** → **Pod gets killed and restarted!** Safety first! 🛡️

---

## 🔧 Essential Commands (Keep These Handy!)

```bash
# Deploy
kubectl apply -f <file>.yaml

# Check status
kubectl get pods

# Debug
kubectl describe pod <name>    # Why isn't it working?
kubectl logs <name>             # What did it say?
kubectl exec -it <name> -- sh   # Get inside the container

# Clean up
kubectl delete pod <name>
```

That's 90% of what you'll use daily!

---

## 🐛 Something Broken? Quick Fixes

**Pod stuck in "Pending"?**
```bash
kubectl describe pod <name>
# Look for: Not enough CPU/memory
```

**Pod keeps crashing (CrashLoopBackOff)?**
```bash
kubectl logs <name> --previous
# Check the error message
```

**Can't pull image (ImagePullBackOff)?**
```bash
kubectl describe pod <name>
# Usually a typo in image name or network issue
```

---

## 🎯 Challenge Yourself!

Before moving to Project 2, try these:

1. **Deploy a Redis pod** - Use `redis:7-alpine` image instead of nginx
2. **Break it on purpose** - Use a wrong image name, then fix it using `kubectl describe`
3. **Custom labels** - Create your own pod with labels: `team=yourname` and `priority=high`
4. **Clean slate** - Delete all pods and start fresh

---

## 💡 Key Takeaways

✅ Pods wrap containers and make them run in Kubernetes  
✅ Labels organize pods (crucial when you have hundreds!)  
✅ Sidecars add helper containers without changing main app  
✅ Resource limits = stable clusters (no memory hogs!)  
✅ `kubectl describe` and `kubectl logs` = your debugging best friends  

---

## 🚀 What's Next?

**Problem with pods:** If you delete one, it's gone forever. No auto-restart, no scaling.

**Solution:** Project 2 teaches **Deployments** - they manage pods for you:
- Automatic pod restart if it crashes
- Easy scaling (1 pod → 10 pods with one command)
- Rolling updates (deploy new version without downtime)

**Ready?** Head to [Project 2: Deployments & ReplicaSets](../02-deployments-replicasets/)

---

## 📚 Want to Learn More?

- [Official Kubernetes Pods Docs](https://kubernetes.io/docs/concepts/workloads/pods/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

---

**Great job! You now understand the foundation of Kubernetes! 🎉**

