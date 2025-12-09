#!/bin/bash
# Fix kubeconfig paths for Docker container

# Create a Docker-friendly kubeconfig
cp ~/.kube/config ~/.kube/config.backup
sed -i 's|C:\\Users\\shoeb\\.minikube|/root/.minikube|g' ~/.kube/config
sed -i 's|\\|/|g' ~/.kube/config

echo "✅ Kubeconfig paths fixed for Docker!"
echo "📁 Backup saved to ~/.kube/config.backup"
