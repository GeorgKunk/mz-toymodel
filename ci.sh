#!/bin/bash
set -euo pipefail

# Colors for output
green='\033[0;32m'
red='\033[0;31m'
nc='\033[0m'

function info() { echo -e "${green}[INFO]${nc} $1"; }
function error() { echo -e "${red}[ERROR]${nc} $1"; }

info "1. Running contract tests..."
cd "$(dirname "$0")/contracts/tests"
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
for test in *.py; do
    info "Running $test"
    python "$test"
done
cd ../../..

info "2. Running service tests..."
# Python services
test_dirs=(mz-content-bouncer mz-content-waiter mz-subscription-service)
for d in "${test_dirs[@]}"; do
    if [ -f "$d/requirements.txt" ]; then pip install -r "$d/requirements.txt"; fi
    if [ -d "$d/tests" ]; then
        info "Running pytest in $d"
        pytest "$d/tests" || error "Tests failed in $d" && exit 1
    fi
done
# Java services
for d in mz-authorizationserver mz-gateway; do
    if [ -f "$d/pom.xml" ]; then
        info "Running mvn test in $d"
        (cd "$d" && mvn test)
    fi
done
# Node.js frontends
for d in mz-frontend mz-user-page mz-subscription-shop; do
    if [ -f "$d/package.json" ]; then
        info "Running npm test in $d"
        (cd "$d" && npm install && npm test)
    fi
done

info "3. Building Docker images in Minikube..."
eval $(minikube docker-env)
services=(mz-authorizationserver mz-gateway mz-content-waiter mz-cms-editor mz-subscription-service mz-content-bouncer mz-frontend mz-user-page mz-subscription-shop)
for s in "${services[@]}"; do
    if [ -f "$s/Dockerfile" ]; then
        info "Building $s"
        docker build -t "$s:latest" "$s"
    fi
done

info "4. Deploying to Minikube..."
for f in k8s/*.yaml; do
    info "Applying $f"
    kubectl apply -f "$f"
done

info "5. Waiting for all pods to be ready..."
retries=30
while [ $retries -gt 0 ]; do
    not_ready=$(kubectl get pods -n default --no-headers | grep -v "Running" | grep -v "Completed" | wc -l)
    if [ "$not_ready" -eq 0 ]; then
        info "All pods are running."
        break
    fi
    info "Waiting for pods to be ready... ($retries retries left)"
    sleep 10
    retries=$((retries-1))
done
if [ $retries -eq 0 ]; then
    error "Some pods did not become ready in time."
    kubectl get pods -n default
    exit 1
fi

info "6. Verifying service health endpoints..."
# Example: check /health for each service (assumes NodePort or ingress is set up)
# You may need to adapt this for your cluster networking
for svc in mz-content-bouncer mz-content-waiter mz-subscription-service; do
    url="http://$(minikube ip):$(kubectl get svc $svc -n default -o jsonpath='{.spec.ports[0].nodePort}')/health"
    info "Checking $svc at $url"
    if ! curl -sf "$url" | grep 'ok'; then
        error "$svc health check failed."
        exit 1
    fi
done

info "CI pipeline completed successfully!"

