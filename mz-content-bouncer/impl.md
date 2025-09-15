# mz-content-bouncer Implementation Plan

## Purpose
REST API for access checks against user subscriptions and receipts. Enforces access control for content and services based on current subscription state.

## Technology Stack
- Python (FastAPI) or Java (Spring Boot)
- PostgreSQL (receipts)
- RabbitMQ (event listening)

## Key Features
- REST API for access checks
- Listens for receipt events (creation, confirmation, cancellation) from RabbitMQ
- Updates access rights in real time
- Validates JWTs for authentication

## Endpoints
- /access/check: Check if user has access to content
- /receipts: Query current receipts

## Dependencies
- PostgreSQL (receipts)
- RabbitMQ (receipt events)
- mz-authorizationserver (JWT validation)

## Docker/Kubernetes Notes
- Use official Python or Java image
- Expose port 8000 (Python) or 8080 (Java)
- Configure DB and RabbitMQ via environment variables

## Testing & Validation
- Unit tests for access logic
- Integration tests for event handling
- Manual validation of access control

## Integration Points
- Consumed by mz-frontend and other services for access checks
- Listens to events from mz-subscription-service via RabbitMQ
- Stores and queries receipts in PostgreSQL

