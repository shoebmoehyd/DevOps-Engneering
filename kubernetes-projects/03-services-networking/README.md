# 🌐 Project 3: Services & Networking

**Level:** Beginner | **Status:** ✅ Complete

## 📚 What You'll Learn

Welcome to Project 3! Remember how deployments manage pods? But how do users **access** them?

In this project, you'll learn:
- Why pods need Services (IPs keep changing!)
- ClusterIP - Talk between pods internally
- NodePort - Access from outside the cluster
- LoadBalancer - Production external access
- How labels route traffic to the right pods

By the end, you'll expose apps to the world! 🌍

---

## 🎯 What is a Service?

**The problem:**
- Pods get random IPs (10.244.1.5, 10.244.2.8, etc.)
- Pods die and restart with NEW IPs
- How do users find your app? 🤔

**The solution: Services!**
- Service = Stable IP that never changes
- Routes traffic to healthy pods automatically
- Like a load balancer for your pods

**Think of it this way:**
- 🏠 Pods = Houses that move around
- 📬 Service = Permanent mailbox address
- Users send requests to mailbox → Service delivers to correct house

---

## 💡 Why Learn This?

**ClusterIP:** Microservices talking to each other (frontend → backend → database)

**NodePort:** Quick testing and development access

**LoadBalancer:** Production apps (real users accessing your app)

**Load Balancing:** Traffic distributed across multiple pods automatically

---

## 📋 Service Types

| Type | Use Case | Access From | Example |
|------|----------|-------------|---------|
| **ClusterIP** | Internal only | Inside cluster | Backend API, Database |
| **NodePort** | Development | Outside cluster via Node IP:Port | Testing your app |
| **LoadBalancer** | Production | Outside via cloud provider | Real user traffic |

---

## 📁 What You'll Build

```
03-services-networking/
├── README.md
└── manifests/
    ├── app-deployment.yaml
    ├── clusterip-service.yaml
    ├── nodeport-service.yaml
    └── test-pod.yaml
```

---

## 🚀 Setup

```bash
cd C:\Users\shoeb\My Learnings\DevOps-Engneering\kubernetes-projects\03-services-networking
mkdir manifests
```

---

> 💡 **Stuck on any exercise?** Check the solution files in the `manifests/` folder after you try!

---

## 📝 Exercise 1: Create Your Application

**You can't expose what doesn't exist!** Let's create an app first.

**Your mission:** Create `manifests/app-deployment.yaml`

**Build a deployment with:**
- 3 nginx replicas (remember Project 2?)
- Image: `nginx:alpine`
- Label: `app: nginx` (or `app: web` - your choice!)
- Container port: 80 (Services need this!)

**Hints:**
- Start from your Project 2 deployment
- Don't forget `ports:` section with `containerPort: 80`
- Labels = How Services find your pods!

**Deploy it:**
```bash
kubectl apply -f manifests/app-deployment.yaml
kubectl get pods -l app=nginx
kubectl get pods -o wide
```

**Look at those IPs!** `10.244.x.x` - they're random and will change if pods restart. 😨

🤔 **Question:** How would frontend pods find these backend pods? **Services to the rescue!**

---

## 📝 Exercise 2: ClusterIP Service (Internal Access)

**Time to create a permanent address for your pods!**

**Your mission:** Create `manifests/clusterip-service.yaml`

**What it needs:**
- `kind: Service`
- `type: ClusterIP` (internal only)
- `selector: app: nginx` (must match YOUR pod labels!)
- `port: 80` (Service listens here)
- `targetPort: 80` (forwards to container port)

**YAML hint:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  type: ClusterIP
  selector:
    app: nginx    # Match your deployment labels!
  ports:
  - port: 80
    targetPort: 80
```

**Deploy it:**
```bash
kubectl apply -f manifests/clusterip-service.yaml
kubectl get service web-service
```

**Magic moment!** ✨ See that `CLUSTER-IP`? (e.g., `10.96.123.45`) 

**That IP will NEVER change** - even if all pods restart! 🎯

---

## 🧪 Exercise 3: Test Internal Access

**Does the Service actually work? Let's prove it!**

**Your mission:** Create `manifests/test-pod.yaml` - a pod to test FROM

**Simple pod with:**
- Image: `busybox` (has `wget` tool)
- Command: `["sleep", "3600"]` (stays alive for 1 hour)

**YAML hint:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sleep", "3600"]
```

**Deploy it:**
```bash
kubectl apply -f manifests/test-pod.yaml
kubectl get pods
```

**Wait for `Running` status, then test:**
```bash
kubectl exec -it test-pod -- wget -qO- http://web-service
```

**BOOM!** 💥 See nginx HTML? **Your Service works!**

💡 **Notice the magic:** You used `http://web-service` - just the SERVICE NAME!
- No IP addresses
- No ports to remember
- Kubernetes DNS handles it automatically! 🧿

---

## 🚪 Exercise 4: NodePort Service (External Access)

**ClusterIP is great internally, but what about YOUR browser?** 🌐

**Your mission:** Create `manifests/nodeport-service.yaml`

**NodePort opens a door to the outside world:**
- `type: NodePort`
- `selector: app: nginx` (same labels!)
- `port: 80` (Service port)
- `targetPort: 80` (container port)
- `nodePort: 30007` (external port 30000-32767)

**YAML hint:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nodeport-service    # Different name!
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30007
```

**Deploy it:**
```bash
kubectl apply -f manifests/nodeport-service.yaml
kubectl get service nodeport-service
```

**Access from YOUR browser:**
```bash
minikube service nodeport-service --url
```

**Copy that URL and open it!** 🚀

**See nginx welcome page?** 🎉 **You just exposed your app to the outside world!**

💡 **Real world:** In production, you'd use LoadBalancer type (cloud provider handles it)

---

## ⚖️ Exercise 5: Watch Load Balancing Magic

**Services don't just route - they BALANCE traffic across ALL pods!**

**First, see your pod IPs:**
```bash
kubectl get pods -o wide
```

**You have 3 pods with different IPs, right?** 👀

**Now let's make multiple requests:**
```bash
kubectl exec -it test-pod -- sh
```

**Inside the test pod, fire away:**
```sh
for i in 1 2 3 4 5; do wget -qO- http://web-service | grep "nginx"; done
```

**Watch!** Each request shows nginx HTML! 🎉

**What just happened behind the scenes:**
- Request 1 → Pod A (10.244.1.5)
- Request 2 → Pod B (10.244.1.6)
- Request 3 → Pod C (10.244.1.7)
- Request 4 → Pod A again
- Request 5 → Pod B again

**The Service automatically distributed your traffic!** No configuration needed! ⚡

💡 **In production:** This means if one pod is slow, others handle more traffic. **Auto load balancing!**

---

## 🐛 Troubleshooting

**Service not working?**
```bash
kubectl describe service web-service
kubectl get endpoints web-service  # Should show pod IPs
```

**No endpoints?** → Labels don't match! Check:
```bash
kubectl get pods --show-labels
```

**Still stuck?** → Delete and recreate:
```bash
kubectl delete service web-service
kubectl apply -f manifests/clusterip-service.yaml
```

---

## 🎯 Challenge Yourself!

1. **Change labels** - Update deployment label to `app: api`, see Service break, then fix it
2. **Multiple ports** - Expose both port 80 and 443 in the same Service
3. **Named ports** - Use named ports in deployment, reference them in Service

---

## 💡 Key Takeaways

✅ Services provide stable IPs for changing pods  
✅ ClusterIP = Internal (pod-to-pod communication)  
✅ NodePort = External (development/testing)  
✅ LoadBalancer = Production (cloud provider integration)  
✅ Labels & Selectors connect Services to Pods  
✅ Services automatically load balance traffic  
✅ Use Service NAME as DNS (no hardcoded IPs!)  

---

## 🚀 What's Next?

**Problem:** Hardcoding values in YAML is bad (ports, passwords, URLs)

**Solution:** Project 4 teaches **ConfigMaps & Secrets** - externalize configuration safely!

---

## 📚 Resources

- [Services Official Docs](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Service Types](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)

---

**Now you can expose your apps to the world! 🌍**
