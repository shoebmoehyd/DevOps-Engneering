# 🐳 Project 1: Docker Registry Explorer

**Level:** Beginner | **Status:** 🚧 In Progress

## 📚 What You'll Learn

Welcome to your first CI/CD project - but with a twist! 🚀

Instead of building another "hello world" app, you're creating a **real DevOps tool**: a web UI to explore Docker Hub repositories, view tags, check image sizes, and get quick pull commands.

In this project, you'll:
- Build a Python Flask web application
- Integrate with Docker Hub REST API
- Create an optimized Dockerfile
- Set up GitHub Actions workflow
- Automate Docker image builds
- Push images to Docker Hub automatically

**Your first complete CI pipeline + a useful tool!** 🎉

---

## 🎯 The Goal

**Scenario:** You want a quick way to view your Docker images without going to Docker Hub website every time. Plus, you want to learn CI/CD by building something actually useful!

**What you'll build:**
- Web app that lists Docker Hub repos and tags
- Shows image sizes, pull counts, last updated
- One-click copy of pull commands
- All automatically built and deployed via CI/CD!

**Before CI/CD:**
```bash
# Manual steps (tedious!)
git commit -m "new feature"
git push
docker build -t docker-registry-explorer:v1 .
docker tag docker-registry-explorer:v1 username/docker-registry-explorer:v1
docker push username/docker-registry-explorer:v1
docker tag docker-registry-explorer:v1 username/docker-registry-explorer:latest
docker push username/docker-registry-explorer:latest
```

**After CI/CD:**
```bash
# Automated! (awesome!)
git commit -m "new feature"
git push
# GitHub Actions does everything automatically! ✨
```

---

## 📁 What You'll Build

```
01-docker-github-actions/
├── app/
│   ├── requirements.txt       # Python dependencies
│   ├── app.py                 # Flask application
│   ├── templates/
│   │   └── index.html         # Frontend UI
│   ├── Dockerfile             # Multi-stage Docker build
│   └── .dockerignore          # Ignore unnecessary files
└── .github/
    └── workflows/
        └── docker-build.yml   # GitHub Actions CI pipeline
```

---

## 📝 Exercise 1: Create the Docker Registry Explorer App

**🎯 Challenge:** Build a Python Flask app that talks to Docker Hub API!

**📖 Story:** You're tired of going to Docker Hub website every time you want to check your images. Build a CLI/web tool that shows all your repos, tags, and lets you copy pull commands instantly!

**Your mission:** Create the Flask application in the `app/` folder

---

### **Step 1: Create `requirements.txt`**

**What you need:**
Python dependencies for Flask and HTTP requests.

**Try it yourself first!** What packages do we need?
- Web framework (Flask)
- HTTP client (requests)
- Optional: python-dotenv for environment variables

<details>
<summary>💡 Click here for the solution</summary>

```txt
Flask==3.0.0
requests==2.31.0
python-dotenv==1.0.0
```
</details>

---

### **Step 2: Create `app.py`**

**What you need:**
- Flask web server
- Routes:
  - `/` - Homepage (HTML form to enter username)
  - `/repos/<username>` - List all repos for a user
  - `/tags/<username>/<repo>` - List all tags for a repo
- Docker Hub API integration
- Error handling

**Docker Hub API endpoints:**
- List repos: `https://hub.docker.com/v2/repositories/{username}/`
- List tags: `https://hub.docker.com/v2/repositories/{username}/{repo}/tags/`

**Try building it yourself!** Start simple - just fetch and display JSON first.

<details>
<summary>💡 Click here for starter code</summary>

```python
from flask import Flask, render_template, request, jsonify
import requests
import os

app = Flask(__name__)

DOCKER_HUB_API = "https://hub.docker.com/v2"

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/repos/<username>')
def get_repos(username):
    """Fetch all repos for a Docker Hub user"""
    try:
        url = f"{DOCKER_HUB_API}/repositories/{username}/"
        response = requests.get(url)
        response.raise_for_status()
        
        repos = response.json()['results']
        
        # Simplify the data
        simplified = [{
            'name': repo['name'],
            'description': repo['description'],
            'star_count': repo['star_count'],
            'pull_count': repo['pull_count'],
            'last_updated': repo['last_updated']
        } for repo in repos]
        
        return jsonify(simplified)
    
    except requests.exceptions.RequestException as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/tags/<username>/<repo>')
def get_tags(username, repo):
    """Fetch all tags for a specific repo"""
    try:
        url = f"{DOCKER_HUB_API}/repositories/{username}/{repo}/tags/"
        response = requests.get(url)
        response.raise_for_status()
        
        tags = response.json()['results']
        
        # Simplify the data
        simplified = [{
            'name': tag['name'],
            'full_size': tag['full_size'],
            'last_updated': tag['last_updated']
        } for tag in tags]
        
        return jsonify(simplified)
    
    except requests.exceptions.RequestException as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
```
</details>

---

### **Step 3: Create `templates/index.html`**

**What you need:**
Simple HTML frontend with:
- Input field for Docker Hub username
- Button to fetch repos
- Display area for results
- JavaScript to call your API

**Try building it!** Keep it simple - just display the JSON data nicely.

<details>
<summary>💡 Click here for starter HTML</summary>

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Docker Registry Explorer</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 50px auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 { color: #2496ED; }
        input {
            padding: 10px;
            width: 300px;
            font-size: 16px;
            border: 2px solid #ddd;
            border-radius: 5px;
        }
        button {
            padding: 10px 20px;
            background: #2496ED;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover { background: #1a7abd; }
        .repo-card {
            background: #f9f9f9;
            padding: 15px;
            margin: 10px 0;
            border-left: 4px solid #2496ED;
            border-radius: 5px;
        }
        .repo-name { font-weight: bold; color: #2496ED; }
        .pull-command {
            background: #272822;
            color: #f8f8f2;
            padding: 10px;
            border-radius: 5px;
            font-family: monospace;
            margin-top: 10px;
            cursor: pointer;
        }
        .error { color: red; padding: 10px; background: #ffe6e6; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🐳 Docker Registry Explorer</h1>
        <p>Enter a Docker Hub username to explore their repositories:</p>
        
        <input type="text" id="username" placeholder="Enter Docker Hub username" value="library">
        <button onclick="fetchRepos()">Fetch Repositories</button>
        
        <div id="results"></div>
    </div>

    <script>
        async function fetchRepos() {
            const username = document.getElementById('username').value;
            const resultsDiv = document.getElementById('results');
            
            if (!username) {
                resultsDiv.innerHTML = '<div class="error">Please enter a username!</div>';
                return;
            }
            
            resultsDiv.innerHTML = '<p>Loading...</p>';
            
            try {
                const response = await fetch(`/api/repos/${username}`);
                const repos = await response.json();
                
                if (response.ok) {
                    displayRepos(repos, username);
                } else {
                    resultsDiv.innerHTML = `<div class="error">Error: ${repos.error}</div>`;
                }
            } catch (error) {
                resultsDiv.innerHTML = `<div class="error">Error: ${error.message}</div>`;
            }
        }
        
        function displayRepos(repos, username) {
            const resultsDiv = document.getElementById('results');
            
            if (repos.length === 0) {
                resultsDiv.innerHTML = '<p>No repositories found!</p>';
                return;
            }
            
            let html = '<h2>📦 Repositories:</h2>';
            repos.forEach(repo => {
                html += `
                    <div class="repo-card">
                        <div class="repo-name">${repo.name}</div>
                        <p>${repo.description || 'No description'}</p>
                        <p>⭐ ${repo.star_count} stars | 📥 ${repo.pull_count} pulls</p>
                        <p>Last updated: ${new Date(repo.last_updated).toLocaleDateString()}</p>
                        <div class="pull-command" onclick="copyToClipboard('docker pull ${username}/${repo.name}')">
                            docker pull ${username}/${repo.name}
                        </div>
                    </div>
                `;
            });
            resultsDiv.innerHTML = html;
        }
        
        function copyToClipboard(text) {
            navigator.clipboard.writeText(text);
            alert('Copied to clipboard!');
        }
    </script>
</body>
</html>
```
</details>

---

### **Step 4: Test Locally**

**Before Docker, make sure it works!**

```bash
cd app

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Create templates folder
mkdir templates
# (Add your index.html to templates/ folder)

# Run the app
python app.py
```

**Open your browser:** `http://localhost:5000`

**Test with:**
- Username: `library` (official Docker images)
- Username: `your-docker-hub-username`

**Expected result:**
- See list of repositories
- Click pull command to copy it
- No errors! ✅

**✅ Working?** Awesome! You just built a real DevOps tool! Now let's Dockerize it! 🐳

---

## 📝 Exercise 2: Create an Optimized Dockerfile

**🎯 Challenge:** Build a Docker image for Python app the RIGHT way!

**📖 Story:** Your lead engineer reviews your code: "Good start! But Python Docker images can be huge. Use multi-stage builds and Alpine to keep it under 100MB!"

**Your mission:** Create `Dockerfile` in the `app/` folder

**Requirements:**
- ✅ Multi-stage build (smaller image!)
- ✅ Python 3.11 Alpine (lightweight)
- ✅ Only copy necessary files
- ✅ Run as non-root user (security!)
- ✅ Expose port 5000

**🤔 Think about it:**
- Why Alpine instead of regular Python image?
- Why copy requirements.txt first before copying all code?
- Why create a non-root user?

**Try writing it yourself!** Here's the structure:
1. **Stage 1 (builder):** Install dependencies with pip
2. **Stage 2 (production):** Copy installed packages only

<details>
<summary>💡 Click here for multi-stage Dockerfile</summary>

```dockerfile
# Stage 1: Build dependencies
FROM python:3.11-alpine AS builder

WORKDIR /app

# Install dependencies in a virtual environment
COPY requirements.txt .
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# Stage 2: Production image
FROM python:3.11-alpine

WORKDIR /app

# Copy virtual environment from builder
COPY --from=builder /opt/venv /opt/venv

# Copy application code
COPY app.py .
COPY templates/ templates/

# Create non-root user
RUN adduser -D appuser && chown -R appuser:appuser /app
USER appuser

# Activate virtual environment
ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 5000

CMD ["python", "app.py"]
```

**Why this is better:**
- ✅ Stage 1 has pip cache and build tools (we don't ship those!)
- ✅ Stage 2 only has runtime files (smaller!)
- ✅ Virtual environment = clean dependency isolation
- ✅ `USER appuser` = runs as non-root (secure!)
- ✅ Alpine = tiny Linux (~80MB total!)
</details>

---

### **Also create `.dockerignore`**

**Why?** Don't copy junk into your Docker image!

<details>
<summary>💡 Click here for .dockerignore</summary>

```
__pycache__
*.pyc
*.pyo
*.pyd
.Python
venv
.env
.git
.gitignore
README.md
Dockerfile
.dockerignore
*.log
```
</details>

---

### **Test Your Docker Image**

```bash
cd app

# Build
docker build -t docker-registry-explorer:test .

# Check image size (should be ~80-100MB)
docker images | grep docker-registry-explorer

# Run
docker run -p 5000:5000 docker-registry-explorer:test

# Test in browser
# Go to: http://localhost:5000
```

**Expected result:**
- See the Docker Registry Explorer UI
- Enter "library" as username
- See official Docker images listed
- Pull commands work!

**✅ Working?** You just created a production-ready Python Docker image! 🎉

---

## 📝 Exercise 3: Create GitHub Actions Workflow

**🎯 Challenge:** Automate ALL THE THINGS! 🚀

**📖 Story:** Your manager says: "Manually building Docker images? In 2025? We need CI/CD!" Time to automate!

**The Goal:**
```
You push code → GitHub Actions automatically:
1. Checks out your code
2. Logs into Docker Hub
3. Builds the image
4. Tags it properly
5. Pushes to Docker Hub

All in 30 seconds! ⚡
```

**Your mission:** Create `.github/workflows/docker-build.yml`

**Think about:**
- 🤔 When should this run? (Every push? Only main branch?)
- 🤔 What tags should we use? (latest? version? commit SHA?)
- 🤔 How do we hide Docker Hub credentials?

**Try creating the workflow yourself!**

Here's the structure you need:
1. **Trigger:** When to run
2. **Checkout:** Get the code
3. **Login:** Authenticate to Docker Hub
4. **Build & Push:** Create and upload image

<details>
<summary>💡 Click here for the workflow</summary>

```yaml
name: Docker Build and Push

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
      
    - name: Login to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKERHUB_USERNAME }}
        password: ${{ secrets.DOCKERHUB_TOKEN }}
        
    - name: Build and push
      uses: docker/build-push-action@v4
      with:
        context: ./app
        push: true
        tags: |
          ${{ secrets.DOCKERHUB_USERNAME }}/docker-registry-explorer:latest
          ${{ secrets.DOCKERHUB_USERNAME }}/docker-registry-explorer:${{ github.sha }}
```

**What's happening here:**
- `on: push: branches: [main]` = Run on every push to main
- `actions/checkout@v3` = GitHub Action to clone your repo
- `docker/login-action@v2` = Logs into Docker Hub
- `docker/build-push-action@v4` = Builds AND pushes (awesome!)
- `tags: |` = Two tags: `latest` + commit SHA (for tracking!)
- `${{ secrets.DOCKERHUB_USERNAME }}` = Secure secrets (we'll add these next!)

</details>

---

**⚠️ Don't commit yet!** We need to add secrets first!

---

## 📝 Exercise 4: Setup GitHub Secrets

**🎯 Challenge:** Never expose credentials in code!

**📖 Story:** You hardcoded your Docker Hub password in the workflow. Your security team FREAKS OUT! 😱 "Use secrets!" they say. Let's do it right!

**Why secrets?**
- ❌ **DON'T:** Put passwords in code (visible to everyone!)
- ✅ **DO:** Use GitHub Secrets (encrypted, secure!)

---

### **Step 1: Create Docker Hub Access Token**

**Why not use your password?** Tokens are safer! You can revoke them without changing your password.

**Do this:**
1. Go to [Docker Hub](https://hub.docker.com)
2. Click your profile → **Account Settings**
3. **Security** → **New Access Token**
4. Name it: "GitHub Actions"
5. Permissions: Read, Write, Delete
6. **Generate** and **COPY IT NOW** (you'll only see it once!)

---

### **Step 2: Add Secrets to GitHub**

**Do this:**
1. Go to your GitHub repo
2. **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**

**Add these TWO secrets:**

**Secret 1:**
- Name: `DOCKERHUB_USERNAME`
- Value: Your Docker Hub username (e.g., `shoebmoehyd`)

**Secret 2:**
- Name: `DOCKERHUB_TOKEN`
- Value: The token you just copied

**🎉 Secrets added!** Now your credentials are safe!

---

**💡 Pro tip:** Your app will fetch public Docker Hub data, which doesn't need authentication. But for private repos or higher rate limits, you could add Docker Hub credentials as environment variables in your app too!

---

**🔒 Security tip:** Never commit secrets to Git! Always use GitHub Secrets, AWS Secrets Manager, or environment variables.

---

## 📝 Exercise 5: Test Your Pipeline!

**🎯 Challenge:** Push code and watch the magic! ✨

**📖 Story:** This is it! The moment where manual work becomes automation. You push code, grab coffee ☕, and come back to a ready Docker image!

---

### **Step 1: Commit Your Code**

```bash
# Make sure you're in the right directory
cd "C:\Users\shoeb\My Learnings\DevOps-Engneering\cicd-projects\01-docker-github-actions"

# Check what you created
git status

# Add everything
git add .

# Commit
git commit -m "🚀 Add CI/CD pipeline with Docker and GitHub Actions"

# Push (this triggers the workflow!)
git push origin main
```

**⚡ The automation starts NOW!**

---

### **Step 2: Watch GitHub Actions in Action!**

**Do this:**
1. Go to your GitHub repo
2. Click the **Actions** tab
3. See your workflow running! 🏃‍♂️
4. Click on the workflow to see live logs

**What you'll see:**
```
✓ Checkout code
✓ Login to Docker Hub
✓ Build and push
  - Building image...
  - Pushing to Docker Hub...
  - Done! ✨
```

**This takes ~30 seconds!**

---

### **Step 3: Verify on Docker Hub**

**Do this:**
1. Go to [Docker Hub](https://hub.docker.com)
2. Find your `simple-node-app` repository
3. Check the **Tags** section

**Expected:**
- ✅ `latest` tag
- ✅ `<commit-sha>` tag (e.g., `a1b2c3d4`)

**🎉 Your image is published!**

---

### **Step 4: Pull and Run Your Image**

**The ultimate test - run YOUR image from Docker Hub!**

```bash
# Pull the image (replace with YOUR username!)
docker pull <your-dockerhub-username>/simple-node-app:latest

# Run it
docker run -p 3000:3000 <your-dockerhub-username>/simple-node-app:latest

# Test it
curl http://localhost:3000
```

**Expected output:**
```json
{"message":"Hello from CI/CD!","version":"1.0.0"}
```

---

### **Step 5: Test the Automation Again!**

**Make a change to prove it works!**

**Edit `app/server.js`:**
```javascript
message: 'Hello from CI/CD! Automated build v2!',
```

**Push the change:**
```bash
git add app/server.js
git commit -m "Update message"
git push origin main
```

**Watch:**
- GitHub Actions runs automatically! ⚡
- New image gets built!
- New tag created!

**Pull the new version:**
```bash
docker pull <your-username>/docker-registry-explorer:latest
docker run -p 5000:5000 <your-username>/docker-registry-explorer:latest
```

**See your changes live!** 🎉

---

### **Step 6: Bonus Challenges!** 🏆

Want to take it further? Try adding:

1. **Tag search** - Add endpoint to search tags by name
2. **Image size comparison** - Compare sizes between tags
3. **Vulnerability count** - Show CVE count per image (requires Docker Hub auth)
4. **Multi-registry support** - Add support for other registries (GHCR, ECR)
5. **Recent activity** - Show recently updated images
6. **Private repo support** - Add authentication for private repos

---

**🎊 SUCCESS!** You built:
- ✅ **A real DevOps tool** (not just hello world!)
- ✅ **Python Flask application** (new language!)
- ✅ **Docker Hub API integration** (real API programming!)
- ✅ **Complete CI pipeline** that auto-builds and pushes
- ✅ **Optimized Docker images** (multi-stage, Alpine)
- ✅ **Automated deployment** on every push

**And most importantly:** You can now explore your Docker images easily! Use this tool in future projects! 🚀

---

## 🎯 What's Next?

**Project 2: K8s Health Dashboard**
- Build a real-time Kubernetes cluster viewer
- Learn React + Node.js
- Integrate with Kubernetes API
- Deploy to K8s via CI/CD

**Ready to level up?** 💪

---

## 💡 Key Takeaways

✅ **GitHub Actions** = Automated CI/CD  
✅ **Multi-stage builds** = Smaller images  
✅ **Image tagging** = Version tracking (SHA + latest)  
✅ **Secrets** = Secure credential management  
✅ **Automation** = Push code → Image built automatically  
✅ **Docker Hub** = Image registry for sharing  

---

## 🎓 What You Built

**A production-ready CI pipeline that:**
1. ✅ Triggers automatically on code push
2. ✅ Builds optimized Docker images
3. ✅ Tags images properly (SHA + latest)
4. ✅ Pushes to Docker Hub automatically
5. ✅ Manages secrets securely

**This is the foundation of ALL modern CI/CD!** 🚀

---

## 🚀 What's Next?

**Problem:** Great, you have an image in Docker Hub... but how do you deploy it?

**Solution:** Project 2 teaches **Kubernetes Deployment** - Automate deployments to your K8s cluster!

---

**You built your first CI pipeline! 🎉**
