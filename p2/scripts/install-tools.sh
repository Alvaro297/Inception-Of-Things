#!/bin/bash
set -e

echo "==> Actualizando paquetes e instalando básicos..."
sudo apt-get update
sudo apt-get install -y curl git make ca-certificates openssl

# Detectar arquitectura (amd64 o arm64)
ARCH=$(dpkg --print-architecture)

# ---------- Docker ----------
if command -v docker >/dev/null 2>&1; then
  echo "==> Docker ya está instalado, se omite."
else
  echo "==> Instalando Docker..."
  curl -fsSL https://get.docker.com | sudo sh
fi

# Añadir el usuario al grupo docker (para usarlo sin sudo)
if ! id -nG "$USER" | grep -qw docker; then
  sudo usermod -aG docker "$USER"
  echo "==> Usuario añadido al grupo docker."
  echo "    IMPORTANTE: cierra sesión y vuelve a entrar para que surta efecto."
fi

# ---------- kubectl ----------
if command -v kubectl >/dev/null 2>&1; then
  echo "==> kubectl ya está instalado, se omite."
else
  echo "==> Instalando kubectl..."
  KUBE_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
  curl -LO "https://dl.k8s.io/release/${KUBE_VERSION}/bin/linux/${ARCH}/kubectl"
  sudo install -m 0755 kubectl /usr/local/bin/kubectl
  rm kubectl
fi

# ---------- k3d ----------
if command -v k3d >/dev/null 2>&1; then
  echo "==> k3d ya está instalado, se omite."
else
  echo "==> Instalando k3d..."
  curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi

echo ""
echo "==> Versiones instaladas:"
docker --version
kubectl version --client
k3d version
echo ""
echo "==> Todo listo."
