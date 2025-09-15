#!/bin/bash
set -euo pipefail

# One-click deployment script for Marktzeitung on Minikube
# Builds all Docker images, loads them into Minikube, and deploys all manifests

# Save original Docker host
ORIGINAL_DOCKER_HOST="${DOCKER_HOST:-}"

# Switch to Minikube's Docker daemon if not already set
if ! docker info 2>/dev/null | grep -q 'minikube'; then
  echo "[INFO] Switching to Minikube's Docker daemon..."
  eval "$(minikube docker-env)"
fi

# 1. Start Minikube if not running
MEMORY="${MINIKUBE_MEMORY:-7g}"
echo "[1/5] Starting Minikube with $MEMORY RAM..."
if ! minikube status | grep -q 'host: Running'; then
  if ! minikube start --cpus=4 --memory=$MEMORY; then
    echo "\n[ERROR] Minikube failed to start. Please ensure Docker Desktop has at least $MEMORY RAM allocated."
    echo "You can change the memory used by this script with: export MINIKUBE_MEMORY=6g (or another value)"
    exit 1
  fi
else
  echo "Minikube already running."
fi

# 2. Build Docker images for all services
echo "[2/5] Building Docker images..."
SERVICES=(
  mz-frontend
  mz-content-waiter
  mz-content-bouncer
  mz-user-page
  mz-subscription-service
  mz-subscription-shop
  mz-gateway
  mz-authorizationserver
  mz-cms-editor
)
for SVC in "${SERVICES[@]}"; do
  if [ -f "$SVC/Dockerfile" ]; then
    echo "  Building $SVC..."
    docker build -t $SVC:latest $SVC || { echo "[ERROR] Failed to build $SVC"; exit 1; }
  fi
done

# 3. Verify images are present in Minikube
function image_exists_in_minikube() {
  # Use --format to extract repository and tag, then match exactly
  minikube ssh "docker images --format '{{.Repository}} {{.Tag}}' | grep -E '^$1 latest$'" > /dev/null
}

echo "[3/5] Verifying images in Minikube..."
for SVC in "${SERVICES[@]}"; do
  if image_exists_in_minikube $SVC; then
    echo "    $SVC:latest present in Minikube."
  else
    echo "[ERROR] $SVC:latest NOT found in Minikube after build!"
    minikube ssh "docker images | grep $SVC || true"
    exit 1
  fi
done

# 4. Deploy infrastructure (Postgres, RabbitMQ)
echo "[4/5] Deploying infrastructure..."
kubectl apply -f infra/postgres/postgres.yaml
kubectl apply -f infra/rabbitmq/rabbitmq.yaml

# 5. Deploy all services
echo "[5/5] Deploying Marktzeitung services..."
kubectl apply -f k8s/

# Restore original Docker daemon
echo "[INFO] Restoring original Docker daemon context..."
if [ -n "$ORIGINAL_DOCKER_HOST" ]; then
  export DOCKER_HOST="$ORIGINAL_DOCKER_HOST"
else
  unset DOCKER_HOST
fi

echo "\nDeployment complete! Use 'minikube service list' to access your services."
