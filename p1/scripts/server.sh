#!/bin/bash

# Instala k3s kubernetes en Ubuntu 24.04
curl -sfL https://get.k3s.io | sudo bash -

# comprobar la versión
k3s --version

# comprobar que está corriendo correctamente
systemctl status k3s.service

# crear carpeta ara a configuración de kubeconfig
mkdir -p ../config/.kube

# Copy generated configuration file into ~/.kube/config file
sudo cp /etc/rancher/k3s/k3s.yaml ../config/.kube
sudo chown $USER:$USER  ../config/.kube
echo 'export KUBECONFIG=../config/.kube'|tee -a ~/.bashrc
source ~/.bashrc

# Test cluster connection using kubectl command.
kubectl get nodes
# NAME                 STATUS   ROLES                  AGE    VERSION
# ubuntu-2404-server   Ready    control-plane,master   8m6s   v1.29.3+k3s1

# The first node will act as control plane and worker node.

# Step 4: Add extra nodes into your k3s kubernetes
# Print out the value of K3S_TOKEN is stored on your server node.
sudo cat /var/lib/rancher/k3s/server/node-token

# Get your server IP address.
ip ad

# To add additional worker node in your k3s cluster, execute the installer script and pass the K3S_URL and K3S_TOKEN environment variables.
curl -sfL https://get.k3s.io | sudo K3S_URL=https://<ServerIP>:6443 K3S_TOKEN=<K3S_TOKEN> sh -

# Here is an example that shows how you will join an agent.
# ServerIP="192.168.1.201"
# TOKEN="K10181fd9008092a622884dac5e7da8cd51c5e1e21518c575c357e4cb435e1e9511::server:8fa1e7abe9ba4e2f90a81c49cb22e713"
# curl -sfL https://get.k3s.io | sudo K3S_URL=https://$ServerIP:6443 K3S_TOKEN=$TOKEN sh -

# Step 5: Install applications on k3s
# We can deploy nginx web application in our cluster to test it works.
# Create a deployment file called deploy-nginx.yaml
# vim deploy-nginx.yaml

# Get service and Node Port to access at.
# kubectl get service