# 💪 Project 8: Health Checks & Autoscaling

**Level:** Advanced | **Status:** ✅ Complete

## 📚 What You'll Learn

Welcome to the final project! Time to make apps **production-ready**! 🚀

In this project, you'll:
- Add **health checks** (liveness & readiness probes)
- Set **resource limits** (CPU/memory)
- Enable **Horizontal Pod Autoscaler (HPA)**
- Handle traffic spikes automatically
- Build a complete Helm chart with all production features

**Make your apps bulletproof!** 💪

---

## 🎯 The Problem

**Without health checks & autoscaling:**
- 😵 Apps crash but Kubernetes doesn't know → users see errors
- 😵 App starts slowly → traffic sent too early → errors
- 😵 Traffic spike → pods overwhelmed → slow/crash
- 😵 No resource limits → one pod uses all cluster resources

**With health checks & autoscaling:**
- ✅ App crashes → Kubernetes restarts it automatically
- ✅ App not ready → no traffic until ready
- ✅ Traffic spike → more pods spin up automatically
- ✅ Resource limits → fair sharing, no resource hogging

**Like having a smart manager for your apps!**

---

## 🎯 Key Concepts

### 1. Liveness Probe
**"Is the app alive?"**
- Checks if app is running properly
- If fails → Kubernetes **restarts** the pod
- Example: HTTP GET returns 200 OK

### 2. Readiness Probe
**"Is the app ready for traffic?"**
- Checks if app can handle requests
- If fails → pod removed from service (no traffic sent)
- Example: Database connection established

### 3. Resource Requests & Limits
**"How much CPU/memory does the app need?"**
- **Request**: Guaranteed minimum resources
- **Limit**: Maximum allowed resources
- Example: request=100m CPU, limit=500m CPU

### 4. Horizontal Pod Autoscaler (HPA)
**"Auto-scale based on load!"**
- Monitors CPU/memory usage
- High load → adds more pods
- Low load → removes pods
- Example: 1-10 pods based on 50% CPU

---

## 📁 What You'll Build

```
08-health-checks-autoscaling/
├── README.md
├── manifests/
│   ├── app-with-probes.yaml
│   ├── app-with-resources.yaml
│   └── hpa.yaml
└── helm-chart/
    ├── Chart.yaml
    ├── values.yaml
    └── templates/
        ├── deployment.yaml
        ├── service.yaml
        ├── ingress.yaml
        └── hpa.yaml
```

**A production-ready Helm chart!**

---

## 🚀 Setup: Enable Metrics Server

**HPA needs metrics to work!**

```bash
# Enable metrics-server in Minikube
minikube addons enable metrics-server

# Verify
kubectl get apiservice v1beta1.metrics.k8s.io -o json | jq '.status.conditions'
```

**Wait 1-2 minutes, then check:**
```bash
kubectl top nodes
kubectl top pods
```

**Metrics working!** 🎉

---

## 📝 Exercise 1: Add Health Checks

**Challenge:** Add liveness and readiness probes to keep apps healthy!

**Scenario:** Your app sometimes crashes or takes time to start. Users see errors because traffic is sent before the app is ready.

**Your mission:** Create `manifests/app-with-probes.yaml`

**Requirements:**
- Deployment with nginx
- **Liveness probe**: HTTP GET `/` every 10s
- **Readiness probe**: HTTP GET `/` every 5s
- Initial delay: 5s for readiness, 10s for liveness

**Key concepts:**
```yaml
livenessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 10
  periodSeconds: 10
  
readinessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 5
  periodSeconds: 5
```

**Full YAML:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-with-probes
spec:
  replicas: 3
  selector:
    matchLabels:
      app: healthy-app
  template:
    metadata:
      labels:
        app: healthy-app
    spec:
      containers:
      - name: app
        image: nginx:alpine
        ports:
        - containerPort: 80
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 10
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
          failureThreshold: 3
---
apiVersion: v1
kind: Service
metadata:
  name: healthy-app
spec:
  selector:
    app: healthy-app
  ports:
  - port: 80
```

**Deploy and test:**
```bash
kubectl apply -f manifests/app-with-probes.yaml
kubectl get pods -w

# Watch the probes in action
kubectl describe pod <pod-name> | grep -A 10 "Conditions:"
```

**Try breaking it:**
```bash
# Delete index.html to fail liveness probe
kubectl exec -it <pod-name> -- rm /usr/share/nginx/html/index.html

# Watch Kubernetes restart it automatically!
kubectl get pods -w
```

**Auto-healing works!** ✅

---

## 📝 Exercise 2: Set Resource Limits

**Challenge:** Prevent pods from hogging all cluster resources!

**Scenario:** One misbehaving pod uses 100% CPU, starving other apps. You need fair resource sharing.

**Your mission:** Create `manifests/app-with-resources.yaml`

**Requirements:**
- Deployment with 2 replicas
- **Requests**: 100m CPU, 128Mi memory (guaranteed)
- **Limits**: 500m CPU, 256Mi memory (maximum)

**Key concepts:**
```yaml
resources:
  requests:
    cpu: "100m"      # 0.1 CPU core
    memory: "128Mi"
  limits:
    cpu: "500m"      # 0.5 CPU core
    memory: "256Mi"
```

**Full YAML:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-with-resources
spec:
  replicas: 2
  selector:
    matchLabels:
      app: resource-app
  template:
    metadata:
      labels:
        app: resource-app
    spec:
      containers:
      - name: app
        image: nginx:alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
          limits:
            cpu: "500m"
            memory: "256Mi"
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: resource-app
spec:
  selector:
    app: resource-app
  ports:
  - port: 80
```

**Deploy and check:**
```bash
kubectl apply -f manifests/app-with-resources.yaml
kubectl top pods
kubectl describe pod <pod-name> | grep -A 5 "Limits:"
```

**Resource management enabled!** ✅

---

## 📝 Exercise 3: Enable Autoscaling

**Challenge:** Auto-scale based on CPU usage!

**Scenario:** Traffic spikes during peak hours. You need 1 pod normally, but 10 pods during spikes.

**Your mission:** Create `manifests/hpa.yaml`

**Requirements:**
- Min replicas: 2
- Max replicas: 10
- Target CPU: 50%
- Scale up when CPU > 50%

**YAML:**
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: app-with-resources
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
```

**Deploy and test:**
```bash
kubectl apply -f manifests/hpa.yaml
kubectl get hpa -w

# Generate load to trigger scaling
kubectl run load-generator --image=busybox --restart=Never -- /bin/sh -c "while true; do wget -q -O- http://resource-app; done"

# Watch pods scale up!
kubectl get pods -w
kubectl get hpa -w
```

**After a few minutes, delete load generator:**
```bash
kubectl delete pod load-generator

# Watch pods scale down
kubectl get hpa -w
```

**Auto-scaling works!** 🎉

---

## 📝 Exercise 4: Build Production Helm Chart

**Challenge:** Package everything into a production-ready Helm chart!

**Your mission:** Create a complete Helm chart with:
- Health checks
- Resource limits
- Autoscaling
- Ingress
- Configurable via values.yaml

**Structure:**
```
helm-chart/
├── Chart.yaml
├── values.yaml
└── templates/
    ├── deployment.yaml  # With probes & resources
    ├── service.yaml
    ├── ingress.yaml
    └── hpa.yaml
```

**`Chart.yaml`:**
```yaml
apiVersion: v2
name: production-app
description: Production-ready app with health checks and autoscaling
version: 1.0.0
appVersion: "1.0"
```

**`values.yaml`:**
```yaml
replicaCount: 2

image:
  repository: nginx
  tag: alpine
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: true
  className: nginx
  host: prodapp.local

resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 256Mi

autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 50

probes:
  liveness:
    enabled: true
    path: /
    initialDelaySeconds: 10
    periodSeconds: 10
  readiness:
    enabled: true
    path: /
    initialDelaySeconds: 5
    periodSeconds: 5
```

**`templates/deployment.yaml`:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Chart.Name }}
  labels:
    app: {{ .Chart.Name }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      app: {{ .Chart.Name }}
  template:
    metadata:
      labels:
        app: {{ .Chart.Name }}
    spec:
      containers:
      - name: {{ .Chart.Name }}
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        ports:
        - containerPort: {{ .Values.service.port }}
        resources:
          {{- toYaml .Values.resources | nindent 10 }}
        {{- if .Values.probes.liveness.enabled }}
        livenessProbe:
          httpGet:
            path: {{ .Values.probes.liveness.path }}
            port: {{ .Values.service.port }}
          initialDelaySeconds: {{ .Values.probes.liveness.initialDelaySeconds }}
          periodSeconds: {{ .Values.probes.liveness.periodSeconds }}
        {{- end }}
        {{- if .Values.probes.readiness.enabled }}
        readinessProbe:
          httpGet:
            path: {{ .Values.probes.readiness.path }}
            port: {{ .Values.service.port }}
          initialDelaySeconds: {{ .Values.probes.readiness.initialDelaySeconds }}
          periodSeconds: {{ .Values.probes.readiness.periodSeconds }}
        {{- end }}
```

**`templates/hpa.yaml`:**
```yaml
{{- if .Values.autoscaling.enabled }}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ .Chart.Name }}-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ .Chart.Name }}
  minReplicas: {{ .Values.autoscaling.minReplicas }}
  maxReplicas: {{ .Values.autoscaling.maxReplicas }}
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
{{- end }}
```

**Create service and ingress templates too!** (Use Project 7 as reference)

**Deploy:**
```bash
cd C:\Users\shoeb\My Learnings\DevOps-Engneering\kubernetes-projects\08-health-checks-autoscaling

helm install prodapp ./helm-chart
kubectl get all
kubectl get hpa
```

**Test it:**
```bash
# Check health
kubectl get pods
kubectl describe pod <pod-name>

# Generate load
kubectl run load-generator --image=busybox --restart=Never -- /bin/sh -c "while true; do wget -q -O- http://production-app; done"

# Watch autoscaling
kubectl get hpa -w
kubectl get pods -w
```

**Production-ready app deployed!** 🎉

---

## 💡 Key Takeaways

✅ **Liveness probes** = Auto-restart crashed apps  
✅ **Readiness probes** = No traffic until ready  
✅ **Resource requests** = Guaranteed resources  
✅ **Resource limits** = Prevent resource hogging  
✅ **HPA** = Auto-scale based on metrics  
✅ **Helm** = Package everything for easy deployment  
✅ **Production-ready** = All best practices combined!  

---

## 🎓 Kubernetes Journey Complete!

**You mastered:**
1. ✅ Basic Pods
2. ✅ Deployments & ReplicaSets
3. ✅ Services & Networking
4. ✅ ConfigMaps & Secrets
5. ✅ Persistent Storage
6. ✅ Multi-tier Applications
7. ✅ Ingress & Load Balancing (Helm)
8. ✅ Health Checks & Autoscaling (Helm)

**You're now a Kubernetes engineer!** 🚀

---

## 🚀 Next Steps

**Continue learning:**
- **StatefulSets** - For databases (MySQL, PostgreSQL)
- **DaemonSets** - Run on every node
- **Jobs & CronJobs** - Batch processing
- **Network Policies** - Security
- **RBAC** - Role-based access control
- **Service Mesh** - Istio, Linkerd
- **GitOps** - ArgoCD, Flux

**You built a solid foundation!** 💪
