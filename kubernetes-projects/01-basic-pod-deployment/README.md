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

### 🎯 Exercise 1: Your First Pod

Deploy a simple nginx web server:

```bash
kubectl apply -f nginx-pod.yaml
kubectl get pods
```

**What's happening?**
- Kubernetes downloads the nginx image
- Creates a pod to run it
- You should see `STATUS: Running`

**Access your web server:**
```bash
kubectl port-forward nginx-pod 8080:80
# Open browser: http://localhost:8080
```

You should see the nginx welcome page! 🎉

**Clean up:**
```bash
kubectl delete pod nginx-pod
```

---

### 🏷️ Exercise 2: Pods with Labels

Labels are like sticky notes on your pods - they help you organize and find them.

```bash
kubectl apply -f manifests/simple-pod.yaml
kubectl get pods --show-labels
```

**Try filtering:**
```bash
kubectl get pods -l app=myapp       # Find by app name
kubectl get pods -l env=development # Find by environment
```

💡 **Why this matters:** In production, you'll have 100s of pods. Labels let you find them instantly!

---

### 🤝 Exercise 3: Multi-Container Pod (Sidecar Pattern)

Sometimes you want a helper container alongside your main app:

```bash
kubectl apply -f manifests/multi-container-pod.yaml
kubectl get pods
```

Notice it says `2/2` - that's 2 containers in 1 pod!

**Check both containers:**
```bash
kubectl logs multi-container-pod -c main-app
kubectl logs multi-container-pod -c sidecar-logger
```

**Real-world example:** Your main app writes logs, the sidecar ships them to Elasticsearch.

---

### 💪 Exercise 4: Production-Ready Pod

Set resource limits so one pod can't crash your whole cluster:

```bash
kubectl apply -f manifests/pod-with-resources.yaml
kubectl describe pod resource-pod | grep -A 5 "Limits"
```

You'll see:
- **Requests:** 250m CPU, 128Mi memory (guaranteed minimum)
- **Limits:** 500m CPU, 256Mi memory (maximum allowed)

**What happens if it exceeds limits?** Pod gets killed (OOMKilled) and restarted.

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

