#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y curl ca-certificates

# Wait for the server to generate its token.
until [ -s /vagrant/.k3s-token ]; do
  sleep 2
done

TOKEN=$(cat /vagrant/.k3s-token)

# Join the existing K3s cluster as an agent.
# El worker se conecta al servidor a través de la IP privada
# y del puerto 6443, que utiliza la API de Kubernetes.
# K3S_TOKEN="$TOKEN": token que hemos obtenido del servidor.
# sh -s - agent: indica que K3s debe instalarse en modo agente, no en modo servidor.
curl -sfL https://get.k3s.io | \
  K3S_URL="https://192.168.56.110:6443" \
  K3S_TOKEN="$TOKEN" \
  sh -s - agent \
    --node-ip 192.168.56.111

echo "K3s worker installation completed."



# # A worker needs the server URL and the join token, which lives on the 
# # server. Read it there and keep it out of shell history and chat logs, 
# # because anyone holding it can join a node to your cluster.

# sudo cat /var/lib/rancher/k3s/server/node-token

# # Patch the worker with apt upgrade first. We skipped that on k3s02, 
# # which is why it still reports 24.04.4. Then run the same installer 
# # with K3S_URL and K3S_TOKEN set. Keep the channel identical so both 
# # nodes run the same release, and paste your real token in place of the 
# # placeholder. Our worker kept UFW inactive. If you enable it there too, 
# # give it the same pod, service, 8472/udp and 10250/tcp rules as the server.
# curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=stable K3S_URL=https://192.168.1.174:6443 K3S_TOKEN='paste-node-token-here' sh -

# # The agent installs as k3s-agent.service. It took 1 minute 25 seconds on 
# # our first run and 15 seconds on the second, again mostly the binary 
# # download. Back on the server, scale the test deployment so the scheduler 
# # has a reason to use the new node, then check where the pods landed.
# kubectl scale deployment web --replicas=4
# kubectl get nodes -o wide
# kubectl get pods -l app=web -o wide