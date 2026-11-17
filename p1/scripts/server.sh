#!/bin/bash
# hace que el script se detenga si falla un comando
set -e

# no es interactivo, los comandos no deben pedir imput al usuario
export DEBIAN_FRONTEND=noninteractive

# instala curl y los certificados necesarios
apt-get update
apt-get install -y curl ca-certificates

# instala K3s en modo servidor
# curl: descarga y ejecuta el instalador oficial de K3s
# INSTALL_K3S_EXEC: indica los parámetros que vamos a pasar
# server: indica que esta máquina será el servidor del clúster
# --node-ip: establece la IP que utilizará el nodo
# --advertise-address: indica la dirección que el servidor anuncia
# sh -: el script de k3s se ejecuta con sh
curl -sfL https://get.k3s.io | \
  INSTALL_K3S_EXEC="server \ 
    --node-ip 192.168.56.110 \
    --advertise-address 192.168.56.110" \
  sh -

# compartir el token con el worker
# install copia archivos y establece permisos install [opciones] ORIGEN DESTINO
# node-token: es el token que autentica al worker cuando se une al clúster
# copiamos el token a la carpeta compartida de vagrant
install -m 644 \
  /var/lib/rancher/k3s/server/node-token \
  /vagrant/.k3s-token

# configurar kubectl para administrar los kubernetes
# cp: copia el archivo de configuración
# .kube/config: directorio de configuración para kubectl con usuario vagrant
mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube
chmod 600 /home/vagrant/.kube/config

echo "K3s server installation completed."
