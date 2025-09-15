# Marktzeitung Monorepo

This monorepo contains a local-first, Minikube-deployable toy model of the Marktzeitung newspaper's digital infrastructure, including all core services and frontends.

## Prerequisites

- [Docker](https://www.docker.com/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Minikube](https://minikube.sigs.k8s.io/docs/)
- [Node.js](https://nodejs.org/) (for Svelte/Strapi frontends)
- [Python 3.10+](https://www.python.org/) (for FastAPI services)
- [Java 17+](https://adoptium.net/) (for Spring Boot services)

## Directory Structure

- `mz-frontend/` - Svelte SSR frontend
- `cms-api/` - FastAPI backend for content
- `cms-editor/` - Strapi CMS
- `authorizationserver/` - Spring Boot OAuth2 server
- `mz-gateway/` - Spring Cloud Gateway
- `access-service/` - FastAPI access check API
- `profile-service/` - Svelte SSR user profile frontend
- `subscription-shop/` - Svelte SSR subscription shop
- `subscription-service/` - FastAPI subscription backend
- `infra/postgres/` - PostgreSQL manifests
- `infra/rabbitmq/` - RabbitMQ manifests
- `k8s/` - Kubernetes manifests for all services

## Quickstart

### 1. Start Minikube

```
minikube start --cpus=4 --memory=8g
```

### 2. Build Docker Images

For each service, run (example for `mz-frontend`):

```
cd mz-frontend
docker build -t mz-frontend:latest .
cd ..
# Repeat for all services
```

### 3. Load Images into Minikube

```
minikube image load mz-frontend:latest
# Repeat for all services
```

### 4. Deploy Infrastructure

```
kubectl apply -f infra/postgres/postgres.yaml
kubectl apply -f infra/rabbitmq/rabbitmq.yaml
```

### 5. Deploy Services

```
kubectl apply -f k8s/
```

### 6. Access Services

- Use `minikube service list` to get URLs for frontends and APIs.
- Default credentials and endpoints are documented in each service's README.

## Development

- Each service is self-contained and can be run locally with Docker Compose or directly (see individual READMEs).
- For frontend look & feel, refer to provided Marktzeitung HTML examples (to be added).

## Notes

- All FastAPI services use a shared PostgreSQL DB (see `infra/postgres`).
- Inter-service events (e.g., subscription receipts) use RabbitMQ (see `infra/rabbitmq`).
- All frontends are Svelte SSR and as slim as possible.
- All Java services are Spring Boot 3+.

---

For questions, see `copilot.md` for the full implementation plan.
