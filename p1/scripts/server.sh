
#!/bin/bash
set -e # hace que el script se detenga si falla un comando.

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y curl ca-certificates # instala curl y los certificados necesarios.

# Install K3s in server mode. 
# curl: descarga y ejecuta el instalador oficial de K3s.
# server: indica que esta máquina será el servidor del clúster.
# --node-ip: establece la IP que utilizará el nodo.
# --advertise-address: indica la dirección que anunciará el servidor.
curl -sfL https://get.k3s.io | \
  INSTALL_K3S_EXEC="server \ 
    --node-ip 192.168.56.110 \
    --advertise-address 192.168.56.110" \
  sh -

# Share the cluster token with the worker.
# node-token: es el token que autentica al worker cuando se une al clúster.
install -m 644 \
  /var/lib/rancher/k3s/server/node-token \
  /vagrant/.k3s-token

# Configure kubectl for the vagrant user.
# .kube/config: es el archivo de configuración que utilizará kubectl.
mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube
chmod 600 /home/vagrant/.kube/config

echo "K3s server installation completed."














# #!/bin/bash

# sudo apt update && sudo apt -y upgrade

# # Instala k3s kubernetes en Ubuntu 24.04, el stable usa la versión estable actual en vez de la última 
# curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=stable sudo bash -
# # curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=stable sh -

# # comprobar la versión
# k3s --version

# # comprobar que está corriendo correctamente
# systemctl status k3s.service
# # systemctl status k3s --no-pager | head -12

# # comprobar el nodo y la versión que tiene
# sudo kubectl get nodes -o wide
# sudo crictl version

# # K3s writes the admin kubeconfig in /etc/rancher/k3s/k3s.yaml with 600 root mode
# # crear carpeta para la configuración de kubeconfig
# mkdir -p ../.kube/config
# # Copy generated configuration file into ~/.kube/config file
# sudo cp /etc/rancher/k3s/k3s.yaml ../.kube/config
# sudo chown $(id -u):$(id -g) ../.kube/config
# # sudo chown $USER:$USER  ../.kube/config
# echo "export KUBECONFIG=../.kube/config" >> ~/.bashrc
# # echo 'export KUBECONFIG=../.kube/config'| tee -a ~/.bashrc
# source ~/.bashrc
# # export KUBECONFIG=~/.kube/config

# # Test cluster connection using kubectl command.
# kubectl get nodes
# # NAME                 STATUS   ROLES                  AGE    VERSION
# # ubuntu-2404-server   Ready    control-plane,master   8m6s   v1.29.3+k3s1
# # check bundled components
# kubectl get pods -A
# kubectl get pods -A -o jsonpath='{range .items[*]}{range .spec.containers[*]}{.image}{"\n"}{end}{end}' | sort -u

# # The first node will act as control plane and worker node.

# # Step 4: Add extra nodes into your k3s kubernetes
# # Print out the value of K3S_TOKEN is stored on your server node.
# sudo cat /var/lib/rancher/k3s/server/node-token

# # Get your server IP address.
# ip ad

# # To add additional worker node in your k3s cluster, execute the installer script and pass the K3S_URL and K3S_TOKEN environment variables.
# curl -sfL https://get.k3s.io | sudo K3S_URL=https://<ServerIP>:6443 K3S_TOKEN=<K3S_TOKEN> sh -

# # Here is an example that shows how you will join an agent.
# # ServerIP="192.168.1.201"
# # TOKEN="K10181fd9008092a622884dac5e7da8cd51c5e1e21518c575c357e4cb435e1e9511::server:8fa1e7abe9ba4e2f90a81c49cb22e713"
# # curl -sfL https://get.k3s.io | sudo K3S_URL=https://$ServerIP:6443 K3S_TOKEN=$TOKEN sh -

# # Step 5: Install applications on k3s
# # We can deploy nginx web application in our cluster to test it works.
# # Create a deployment file called deploy-nginx.yaml
# # vim deploy-nginx.yaml

# # Get service and Node Port to access at.
# # kubectl get service