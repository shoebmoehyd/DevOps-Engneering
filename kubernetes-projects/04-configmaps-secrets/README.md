# 🔐 Project 4: ConfigMaps & Secrets

**Level:** Beginner | **Status:** ✅ Complete

## 📚 What You'll Learn

Welcome to Project 4! Remember hardcoding values in your YAML files? **That's about to change!**

In this project, you'll learn:
- Why hardcoding config is a nightmare 😱
- ConfigMaps for non-sensitive data (URLs, ports, settings)
- Secrets for sensitive data (passwords, API keys, tokens)
- Inject config as environment variables
- Mount config as files in containers
- Update config without rebuilding images!

By the end, you'll manage configuration like a pro! 🎯

---

## 🎯 What are ConfigMaps & Secrets?

**The problem:**
```yaml
containers:
- name: app
  env:
  - name: DATABASE_URL
    value: "postgres://db:5432"  # 😱 Hardcoded!
  - name: API_KEY
    value: "super-secret-key-123"  # 🚨 Security risk!
```

**What's wrong?**
- Different values for dev/staging/prod → Need 3 YAML files! 😩
- Password in code → Security nightmare! 🔓
- Change config → Rebuild image → Slow! 🐌

**The solution:**
- **ConfigMap** = Store non-sensitive config (URLs, ports, feature flags)
- **Secret** = Store sensitive data (passwords, tokens) - Base64 encoded!

**Think of it this way:**
- 📦 ConfigMap = Settings file (everyone can see)
- 🔒 Secret = Vault (protected access)
- 🎯 Your app = Just reads from these sources

---

## 💡 Why Learn This?

**Separation of Concerns:** Config lives separate from code

**Security:** Secrets are encoded and access-controlled

**Flexibility:** Change config without rebuilding images

**Multi-Environment:** Same image works in dev/staging/prod with different configs

---

## 📋 ConfigMap vs Secret

| Feature | ConfigMap | Secret |
|---------|-----------|--------|
| **Use For** | URLs, ports, settings | Passwords, API keys, tokens |
| **Encoding** | Plain text | Base64 encoded |
| **Security** | Not protected | Access controlled |
| **Example** | `DATABASE_URL`, `LOG_LEVEL` | `DB_PASSWORD`, `API_TOKEN` |

---

## 📋 What You'll Build

```
04-configmaps-secrets/
├── README.md
└── manifests/
    └── deployment-with-config.yaml
```

💡 **Note:** We'll use `kubectl` commands to create ConfigMaps/Secrets (faster & more practical!)

---

## 🚀 Setup

```bash
cd C:\Users\shoeb\My Learnings\DevOps-Engneering\kubernetes-projects\04-configmaps-secrets
mkdir manifests
```

---

## 📝 Exercise 1: Create a ConfigMap

**Let's store app configuration using kubectl commands!**

**Your mission:** Create a ConfigMap with app settings

**Use kubectl to create it:**
```bash
kubectl create configmap app-config \
  --from-literal=APP_NAME="MyAwesomeApp" \
  --from-literal=LOG_LEVEL="debug" \
  --from-literal=MAX_CONNECTIONS="100"
```

**Verify it:**
```bash
kubectl get configmap app-config
kubectl describe configmap app-config
```

**See your data?** 🎉

**View as YAML:**
```bash
kubectl get configmap app-config -o yaml
```

💡 **Notice:** kubectl created the YAML for you! No manual YAML writing needed!

---

## 📝 Exercise 2: Create a Secret

**Time to store sensitive data! kubectl handles Base64 encoding for you!** 🔒

**Your mission:** Create a Secret with passwords and API keys

**Use kubectl (it auto-encodes!):**
```bash
kubectl create secret generic app-secret \
  --from-literal=DB_PASSWORD="supersecret123" \
  --from-literal=API_KEY="my-api-key-456"
```

🎯 **Magic!** kubectl automatically Base64-encodes your secrets!

**Verify it:**
```bash
kubectl get secret app-secret
kubectl describe secret app-secret
```

**Notice:** Values are hidden in `describe`! 🔒

**View the encoded values:**
```bash
kubectl get secret app-secret -o yaml
```

See those Base64 strings? That's your data encoded!

**Decode to verify (PowerShell):**
```powershell
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("c3VwZXJzZWNyZXQxMjM="))
```

---

## 📝 Exercise 3: Use Config as Environment Variables

**Now inject your ConfigMap and Secret into a pod!**

**Your mission:** Create `manifests/deployment-with-config.yaml`

**Build a deployment that:**
- Uses `nginx:alpine` image
- Injects ALL ConfigMap values as env vars
- Injects specific Secret values as env vars

**YAML structure:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-with-config
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: app
        image: nginx:alpine
        envFrom:
        - configMapRef:
            name: app-config    # Inject ALL ConfigMap keys!
        env:
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: DB_PASSWORD
        - name: API_KEY
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: API_KEY
```

**Deploy it:**
```bash
kubectl apply -f manifests/deployment-with-config.yaml
kubectl get pods
```

**Verify env vars are injected:**
```bash
kubectl exec -it <pod-name> -- env | grep -E 'APP_NAME|LOG_LEVEL|DB_PASSWORD'
```

**See them all?** 🎉 Your app now reads external config!

💡 **Note:** `envFrom` injects ALL keys from ConfigMap. `env` injects specific Secret keys!

---

## 📝 Exercise 4: Mount Config as Files

**Some apps read config from FILES, not environment variables!**

**Your mission:** Create `manifests/deployment-files.yaml`

**Deployment that mounts ConfigMap as files:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-with-files
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp-files
  template:
    metadata:
      labels:
        app: myapp-files
    spec:
      containers:
      - name: app
        image: busybox
        command: ["sleep", "3600"]
        volumeMounts:
        - name: config-volume
          mountPath: /etc/config
      volumes:
      - name: config-volume
        configMap:
          name: app-config
```

**Deploy it:**
```bash
kubectl apply -f manifests/deployment-files.yaml
kubectl get pods
```

**Check the mounted files:**
```bash
kubectl exec -it <pod-name> -- ls /etc/config
kubectl exec -it <pod-name> -- cat /etc/config/APP_NAME
kubectl exec -it <pod-name> -- cat /etc/config/LOG_LEVEL
```

**See the files?** 🎉 Each ConfigMap key became a file!

💡 **Real-world example:** Apps like nginx, prometheus read config from `/etc/config/app.conf`

---

## 🔄 Exercise 5: Update Config Without Restart

**The magic of ConfigMaps - change config on the fly!**

**Update your ConfigMap:**
```bash
kubectl edit configmap app-config
```

**Change `LOG_LEVEL` from `debug` to `info`**

**Check mounted files (wait ~60 seconds for sync):**
```bash
kubectl exec -it <pod-name> -- cat /etc/config/LOG_LEVEL
```

**It changed!** 🎩✨ No pod restart, no image rebuild!

⚠️ **Note:** Env vars DON'T auto-update. Only mounted files do!

---

## 🐛 Troubleshooting

**ConfigMap not found?**
```bash
kubectl get configmap
kubectl describe configmap app-config
```

**Secret values not showing?**
```bash
kubectl get secret app-secret -o yaml
# Decode to verify:
echo "c3VwZXJzZWNyZXQxMjM=" | base64 --decode
```

**Pod not getting config?**
```bash
kubectl describe pod <pod-name>
# Check Events for errors
```

---

## 🎯 Challenge Yourself!

**Now that you know kubectl commands, try the YAML way!**

1. **Create ConfigMap YAML** - Write `app-configmap.yaml` manually (check with `kubectl get configmap app-config -o yaml`)
2. **Create Secret YAML** - Write `app-secret.yaml` with Base64 encoded values
3. **From file** - Create ConfigMap from a file: `kubectl create configmap nginx-config --from-file=nginx.conf`
4. **Immutable ConfigMap** - Add `immutable: true` to prevent accidental changes
5. **EnvFrom entire Secret** - Use `envFrom` with `secretRef` to inject all Secret keys at once
6. **Selective mount** - Mount only specific keys from ConfigMap using `items:` in volume

---

## 💡 Key Takeaways

✅ ConfigMaps = Non-sensitive configuration  
✅ Secrets = Sensitive data (Base64 encoded)  
✅ Inject as env vars OR mount as files  
✅ Same image works across environments  
✅ Update config without rebuilding images  
✅ Mounted files auto-update (~60 sec delay)  
✅ Env vars require pod restart to update  
✅ Never commit secrets to Git! Use external secret managers in production  

---

## 🚀 What's Next?

**Problem:** Apps need to store data. But pods are ephemeral (die = data lost!)

**Solution:** Project 5 teaches **Persistent Storage** - Volumes that survive pod restarts!

---

## 📚 Resources

- [ConfigMaps Official Docs](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Secrets Official Docs](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Configure Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/)

---

**Now you manage config like a pro! 🔧**
