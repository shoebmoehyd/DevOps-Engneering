# 💾 Project 5: Persistent Storage

**Level:** Intermediate | **Status:** ✅ Complete

## 📚 What You'll Learn

Welcome to Project 5! Remember how pods lose all data when they restart? **Time to fix that!**

In this project, you'll learn:
- Why pods are ephemeral (data disappears!)
- PersistentVolumes (PV) - Storage in the cluster
- PersistentVolumeClaims (PVC) - Request for storage
- StorageClasses - Dynamic provisioning
- StatefulSets vs Deployments
- Running a database with persistent data

By the end, you'll run stateful apps that survive restarts! 🎯

---

## 🎯 What is Persistent Storage?

**The problem:**
```bash
# Create a pod and write data
kubectl exec -it my-pod -- sh -c "echo 'important data' > /data/file.txt"

# Pod crashes or restarts
kubectl delete pod my-pod

# Data is GONE! 😱
```

**Why?** Containers are ephemeral - everything inside disappears when they restart!

**The solution:**
- **PersistentVolume (PV)** = Actual storage (disk) in the cluster
- **PersistentVolumeClaim (PVC)** = "I need 10GB of storage please!"
- **StorageClass** = Auto-provision storage dynamically

**Think of it this way:**
- 🏢 PV = Storage warehouse (physical disk)
- 📝 PVC = Storage request form ("I need 10GB")
- 📦 Pod = Tenant using the storage
- 🏗️ StorageClass = Automated storage builder

---

## 💡 Why Learn This?

**Databases:** MySQL, PostgreSQL need persistent data

**User Uploads:** Files/images must survive pod restarts

**Logs:** Application logs need to persist

**StatefulSets:** Apps that need stable storage (databases, Kafka, etc.)

---

## 📋 Storage Concepts

| Concept | What It Is | Who Creates It |
|---------|-----------|----------------|
| **PersistentVolume (PV)** | Actual storage resource | Admin or StorageClass |
| **PersistentVolumeClaim (PVC)** | Request for storage | Developer |
| **StorageClass** | Storage provisioner | Admin (auto-creates PVs) |
| **Volume** | Pod-level storage | Pod definition |

---

## 📁 What You'll Build

```
05-persistent-storage/
├── README.md
└── manifests/
    ├── pvc-dynamic.yaml
    ├── pod-with-pvc.yaml
    ├── mysql-pvc.yaml
    ├── mysql-secret.yaml
    ├── mysql-deployment.yaml
    └── mysql-service.yaml
```

---

## 🚀 Setup

```bash
cd C:\Users\shoeb\My Learnings\DevOps-Engneering\kubernetes-projects\05-persistent-storage
mkdir manifests
```

---

## 📝 Exercise 1: The Great Data Disappearing Act

**Let's prove pods are data black holes!** 🕳️

**Create a pod and write "important" data:**
```bash
kubectl run temp-pod --image=nginx --rm -it -- sh
```

**Inside the pod, create your masterpiece:**
```sh
mkdir /data
echo "My super important data!" > /data/myfile.txt
cat /data/myfile.txt
exit
```

**Pod deleted! Now try again:**
```bash
kubectl run temp-pod --image=nginx --rm -it -- sh
```

**Inside, look for your file:**
```sh
cat /data/myfile.txt  # File NOT found! 😱
```

**POOF!** Data vanished into thin air! 💨

💔 **This is why databases crash and users lose uploads!** We NEED persistent storage!

---

## 📝 Exercise 2: Request Your Own Storage Locker

**Time to claim some permanent space!** 📦

**Your mission:** Create `manifests/pvc-dynamic.yaml`

**Request 1GB of storage from Kubernetes:**

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

**Claim your storage:**
```bash
kubectl apply -f manifests/pvc-dynamic.yaml
kubectl get pvc my-pvc
```

**Watch the magic:**
```bash
kubectl get pv
```

**See STATUS: `Bound`?** 🎉 **Kubernetes just gave you 1GB!

🧪 **Behind the scenes:** Minikube's StorageClass auto-created a PersistentVolume for you! No manual setup needed!

---

## 📝 Exercise 3: Test True Persistence

**Mount your storage and put it to the test!**

**Your mission:** Create `manifests/pod-with-pvc.yaml`

**Pod that uses your PVC:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-with-storage
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: storage
      mountPath: /usr/share/nginx/html
  volumes:
  - name: storage
    persistentVolumeClaim:
      claimName: my-pvc
```

**Deploy it:**
```bash
kubectl apply -f manifests/pod-with-pvc.yaml
kubectl get pods
```

**Write data to persistent storage:**
```bash
kubectl exec -it web-with-storage -- sh
```

**Inside the pod:**
```sh
echo '<h1>Persistent Data!</h1>' > /usr/share/nginx/html/index.html
cat /usr/share/nginx/html/index.html
exit
```

**Now for the moment of truth! Delete the pod:**
```bash
kubectl delete pod web-with-storage
```

**Recreate it:**
```bash
kubectl apply -f manifests/pod-with-pvc.yaml
kubectl exec -it web-with-storage -- sh
```

**Check if data survived:**
```sh
cat /usr/share/nginx/html/index.html
```

**IT'S STILL THERE!** 🎉🎊 **Data survived the pod death!**

💡 **This is the power of PVCs** - your data lives beyond the pod lifecycle!

---

## 📝 Exercise 4: Production Database with Persistence

**Now for the real deal - a database that survives crashes!** 🔥

**You already have MySQL files ready!** (Copied from sql-deployment)

**What you're deploying:**
- 🔒 `mysql-secret.yaml` - Credentials (Project 4 skills!)
- 💾 `mysql-pvc.yaml` - 2Gi persistent storage
- 🐳 `mysql-deployment.yaml` - MySQL 8.1 container
- 🌐 `mysql-service.yaml` - NodePort access

**Deploy the full stack:**
```bash
cd manifests
kubectl apply -f mysql-secret.yaml
kubectl apply -f mysql-pvc.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-service.yaml
```

**Watch it come alive:**
```bash
kubectl get pvc mysql-pvc
kubectl get pods -l app=mysql -w
```

**Once Running, create some data:**
```bash
kubectl exec -it <mysql-pod-name> -- mysql -ushoeb -p'Shoeb@03' testdb -e "CREATE TABLE users (id INT, name VARCHAR(50));"
kubectl exec -it <mysql-pod-name> -- mysql -ushoeb -p'Shoeb@03' testdb -e "INSERT INTO users VALUES (1, 'Alice'), (2, 'Bob');"
kubectl exec -it <mysql-pod-name> -- mysql -ushoeb -p'Shoeb@03' testdb -e "SELECT * FROM users;"
```

**See Alice and Bob?** 👩👨

**Now simulate a crash! Delete the pod:**
```bash
kubectl delete pod <mysql-pod-name>
kubectl get pods -w
```

**New pod spawns! Check if Alice and Bob survived:**
```bash
kubectl exec -it <new-pod-name> -- mysql -ushoeb -p'Shoeb@03' testdb -e "SELECT * FROM users;"
```

**THEY'RE ALIVE!** 🎉🎊 **Database survived the crash!**

💡 **Real-world scenario:** In production, pods crash/restart all the time. PVCs ensure your database data NEVER disappears!

🛡️ **Pro tip:** The PVC mounted to `/var/lib/mysql` stores all database files - tables, indexes, everything!

---

## 📝 Exercise 5: Check Storage Details

**Explore PVs and PVCs:**

```bash
# View PVCs
kubectl get pvc

# View PVs (auto-created by StorageClass)
kubectl get pv

# Detailed info
kubectl describe pvc my-pvc
kubectl describe pv <pv-name>
```

**Check storage class:**
```bash
kubectl get storageclass
kubectl describe storageclass standard
```

💡 **Minikube uses `hostPath` provisioner** - stores data on the node's filesystem!

---

## 🐛 Troubleshooting

**PVC stuck in `Pending`?**
```bash
kubectl describe pvc my-pvc
# Check Events for errors
```

**Pod stuck in `Pending`?**
```bash
kubectl describe pod <pod-name>
# Look for: "FailedMount" or "FailedAttachVolume"
```

**Data not persisting?**
- Check volumeMount path is correct
- Verify PVC is `Bound`
- Ensure pod is using the right PVC name

---

## 🎯 Challenge Yourself!

1. **Manual PV** - Create a PV manually (without StorageClass), then bind a PVC to it
2. **ReadWriteMany** - Create a PVC with `ReadWriteMany` and mount it in 2 pods simultaneously
3. **Storage resize** - Expand PVC from 1Gi to 2Gi (if StorageClass supports it)
4. **StatefulSet** - Convert MySQL deployment to StatefulSet (proper way for databases!)
5. **Volume snapshot** - Create a snapshot of your PVC (backup!)

---

## 💡 Key Takeaways

✅ Pods are ephemeral - data disappears on restart  
✅ PVC = Storage request, PV = Actual storage  
✅ StorageClass = Auto-provision storage dynamically  
✅ PVCs survive pod deletion/restart  
✅ Use PVCs for databases, file uploads, logs  
✅ Minikube uses hostPath (local storage)  
✅ Production uses cloud storage (EBS, Azure Disk, etc.)  
✅ StatefulSets are better for databases (stable pod names + storage)  

---

## 🚀 What's Next?

**Problem:** You've built individual components. How do you combine them?

**Solution:** Project 6 teaches **Multi-tier Applications** - Frontend + Backend + Database working together!

---

## 📚 Resources

- [Persistent Volumes Official Docs](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- [Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/)
- [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)

---

**Now your data survives restarts! 💾**
