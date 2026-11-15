CLUSTER = iot

.PHONY: up down tools cluster wait-traefik certs apply wait test status

up: tools cluster wait-traefik certs apply wait
	@echo "==> Entorno listo."

wait-traefik:
	@echo "==> Esperando a Traefik..."
	@until kubectl -n kube-system get deployment traefik >/dev/null 2>&1; do sleep 2; done
	@kubectl -n kube-system rollout status deployment/traefik --timeout=180s

tools:
	./scripts/install-tools.sh

cluster:
	@k3d cluster list | grep -q "^$(CLUSTER) " || \
	  k3d cluster create $(CLUSTER) --agents 2 \
	    -p "80:80@loadbalancer" -p "443:443@loadbalancer"
	@kubectl wait --for=condition=Ready nodes --all --timeout=120s

certs:
	./scripts/gen-certs.sh

apply:
	kubectl apply -f manifests/

wait:
	kubectl rollout status deployment/web-test --timeout=120s

test:
	curl -k --resolve app.iot.local:443:127.0.0.1 https://app.iot.local
	kubectl apply -f tests/pvc-test.yaml
	kubectl wait --for=condition=Ready pod/pod-pvc --timeout=90s
	kubectl exec pod-pvc -- cat /data/test.txt

status:
	kubectl get nodes
	kubectl get pods,pvc,ingress -A

down:
	k3d cluster delete $(CLUSTER)
