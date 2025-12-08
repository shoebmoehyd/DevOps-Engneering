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