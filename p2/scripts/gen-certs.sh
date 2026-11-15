#!/bin/bash
set -e

DOMAIN="app.iot.local"
CERT_DIR="$(dirname "$0")/../certs"

mkdir -p "$CERT_DIR"

# Generar certificado autofirmado solo si no existe
if [ ! -f "$CERT_DIR/tls.crt" ]; then
  echo "==> Generando certificado autofirmado para $DOMAIN..."
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$CERT_DIR/tls.key" -out "$CERT_DIR/tls.crt" \
    -subj "/CN=$DOMAIN" \
    -addext "subjectAltName=DNS:$DOMAIN"
else
  echo "==> El certificado ya existe, se reutiliza."
fi

# Crear (o actualizar) el Secret en Kubernetes
echo "==> Creando Secret iot-tls..."
kubectl create secret tls iot-tls \
  --cert="$CERT_DIR/tls.crt" --key="$CERT_DIR/tls.key" \
  --dry-run=client -o yaml | kubectl apply -f -
