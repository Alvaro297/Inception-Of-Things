#!/bin/bash
# hace que el script se detenga si falla un comando
set -e

# no es interactivo, los comandos no deben pedir imput al usuario
export DEBIAN_FRONTEND=noninteractive

# instala curl y los certificados necesarios
apt-get update
apt-get install -y curl ca-certificates

# espera a que el servidor genere el token 
# y exsista en la carpeta compartida vagrant
until [ -s /vagrant/.k3s-token ]; do
  sleep 2
done

# lee el token que ha generado el servidor
# guarda el resultado del comando en la variable
TOKEN=$(cat /vagrant/.k3s-token)

# instala K3s en modo agente
# curl: descarga y ejecuta el instalador oficial de K3s
# K3S_URL: la url y el puerto por los que conecta al servidor
# 6443: puerto de HTTPS que usa la API Server de kubernetes
# K3S_TOKEN: token de autenticación del servidor TOKEN=$(cat /vagrant/.k3s-token)
# sh -s - agent: lo ejecutamos en modo agente
# --node-ip: establece la IP que utilizará el nodo
curl -sfL https://get.k3s.io | \
  K3S_URL="https://192.168.56.110:6443" \
  K3S_TOKEN="$TOKEN" \
  sh -s - agent \
    --node-ip 192.168.56.111

echo "K3s worker installation completed."
