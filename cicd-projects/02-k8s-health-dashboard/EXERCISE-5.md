# 📝 Exercise 5: CI/CD with GitHub Actions

**🎯 Goal:** Automate testing, building, and deployment of your K8s Health Dashboard using GitHub Actions.

**⏱️ Time:** 30-35 minutes

---

## 🎯 What We're Building

A **complete CI/CD pipeline** that automatically:
- ✅ Runs tests when you push code
- ✅ Builds Docker images
- ✅ Pushes images to Docker Hub
- ✅ Deploys to your Kubernetes cluster
- ✅ Notifies you of success/failure

---

## 📂 What We'll Create

```
02-k8s-health-dashboard/
├── .github/
│   └── workflows/
│       ├── backend-ci.yml      ← Backend CI/CD pipeline
│       ├── frontend-ci.yml     ← Frontend CI/CD pipeline
│       └── deploy.yml          ← Deployment pipeline
└── backend/
    └── tests/
        └── api.test.js         ← Backend tests
```

---

## 📋 Prerequisites

**You'll need:**
1. ✅ GitHub account
2. ✅ Docker Hub account (free - sign up at hub.docker.com)
3. ✅ Your code pushed to GitHub
4. ✅ Working dashboard from Exercise 4

---

## 🚀 Step 1: Create GitHub Repository

**If you haven't already:**

```bash
cd "C:/Users/shoeb/My Learnings/DevOps-Engneering/cicd-projects/02-k8s-health-dashboard"

# Initialize git (if not done)
git init
git add .
git commit -m "Initial commit - K8s Health Dashboard"

# Create repo on GitHub first, then:
git remote add origin https://github.com/YOUR_USERNAME/k8s-health-dashboard.git
git branch -M main
git push -u origin main
```

---

## 🚀 Step 2: Setup Docker Hub

**Create a Docker Hub account and repository:**

1. Go to https://hub.docker.com
2. Sign up (free account)
3. Create **Access Token**:
   - Click your profile → Account Settings → Security
   - Click "New Access Token"
   - Name: `github-actions`
   - Copy the token (save it!)

---

## 🚀 Step 3: Add GitHub Secrets

**Add secrets to your GitHub repository:**

1. Go to your GitHub repo
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**

**Add these secrets:**

| Secret Name | Value |
|------------|-------|
| `DOCKERHUB_USERNAME` | Your Docker Hub username |
| `DOCKERHUB_TOKEN` | Your Docker Hub access token |

---

## 🚀 Step 4: Create Backend Tests

**Let's add simple tests for the backend API:**

I'll create a test file for you!

---

## 🚀 Step 5: Create GitHub Actions Workflows

**I'll create 3 workflow files:**

1. **Backend CI** - Test and build backend
2. **Frontend CI** - Build and test frontend
3. **Deploy** - Deploy to Kubernetes (manual trigger)

---

## 🚀 Step 6: Push and Watch the Magic! ✨

**After I create the files, push to GitHub:**

```bash
git add .
git commit -m "Add CI/CD pipeline with GitHub Actions"
git push
```

**Then:**
1. Go to your GitHub repo
2. Click **Actions** tab
3. Watch your workflows run! 🎉

---

## 🎓 Understanding the CI/CD Pipeline

### **Backend CI Workflow:**
```
Push to GitHub
    ↓
Run Tests
    ↓
Build Docker Image
    ↓
Push to Docker Hub
    ↓
✅ Success!
```

### **Frontend CI Workflow:**
```
Push to GitHub
    ↓
Build React App
    ↓
Build Docker Image
    ↓
Push to Docker Hub
    ↓
✅ Success!
```

### **Deploy Workflow:**
```
Manual Trigger
    ↓
Pull Latest Images
    ↓
Apply K8s Manifests
    ↓
Restart Deployments
    ↓
✅ Deployed!
```

---

## ✅ Success Checklist

- ✅ GitHub repository created
- ✅ Docker Hub account setup
- ✅ GitHub secrets configured
- ✅ Tests created
- ✅ Workflow files created
- ✅ Code pushed to GitHub
- ✅ Workflows running successfully
- ✅ Docker images published to Docker Hub

---

## 🔍 How to Use Your CI/CD Pipeline

### **Automatic (on every push):**
```bash
# Make a change to backend or frontend
git add .
git commit -m "Update feature"
git push
# GitHub Actions automatically runs tests and builds images!
```

### **Manual Deployment:**
1. Go to GitHub → Actions → Deploy workflow
2. Click "Run workflow"
3. Select branch
4. Click "Run workflow"
5. Your app deploys to Kubernetes! 🚀

---

## 🐛 Troubleshooting

**Workflow fails on Docker Hub push:**
- Check your DOCKERHUB_USERNAME and DOCKERHUB_TOKEN secrets
- Make sure token has read/write permissions

**Tests fail:**
```bash
# Run tests locally first
cd backend
npm test
```

**Deploy workflow can't connect to Kubernetes:**
- This workflow is designed for cloud Kubernetes (not Minikube)
- For Minikube, deploy manually: `kubectl apply -f k8s/`

**Images not pulling in Kubernetes:**
```bash
# Update deployment to use Docker Hub images
# Change imagePullPolicy to Always
```

---

## 🎓 What You Learned

- ✅ **GitHub Actions** - Automated workflows
- ✅ **CI/CD Concepts** - Continuous Integration & Deployment
- ✅ **Testing** - Automated test execution
- ✅ **Docker Registry** - Publishing images to Docker Hub
- ✅ **Secrets Management** - Secure credential handling
- ✅ **YAML Workflows** - GitHub Actions syntax
- ✅ **DevOps Practices** - Professional deployment pipelines

---

## 🚀 Advanced Topics (Optional)

**Want to level up? Try:**

1. **Add more tests:**
   - Frontend unit tests with Vitest
   - Integration tests
   - End-to-end tests with Playwright

2. **Add code quality checks:**
   - ESLint for code style
   - Security scanning with Trivy
   - Code coverage reports

3. **Implement staging environment:**
   - Deploy to staging branch first
   - Run smoke tests
   - Manual approval before production

4. **Add notifications:**
   - Slack notifications on deploy
   - Email alerts on failures
   - Status badges in README

---

## 🎉 Exercise 5 Complete!

**When your CI/CD pipeline is running and successfully building images, come back and tell me "Exercise 5 done"!**

**Next:** Exercise 6 - Monitoring & Observability with Prometheus & Grafana! 📊

---

## 💡 Pro Tips

**Best Practices:**
- ✅ Always run tests before building images
- ✅ Use semantic versioning for image tags
- ✅ Keep secrets in GitHub Secrets, never in code
- ✅ Use caching to speed up builds
- ✅ Add status badges to your README
- ✅ Monitor your workflows regularly

**Real-world scenarios:**
- Companies use this exact workflow pattern
- CI/CD reduces deployment time from hours to minutes
- Automated testing catches bugs before production
- Version control + automation = reliable deployments

---

Ready to set this up? Let me know and I'll create all the necessary files! 🚀
