# RabbitMQ Service Implementation Plan

## Purpose
Asynchronous messaging backbone for inter-service events (e.g., subscription/receipt events).

## Technology Stack
- RabbitMQ (official Docker image)
- Streams plugin enabled

## Key Features
- Publishes and consumes events for subscription and receipt lifecycle
- Used by: mz-subscription-service, mz-content-bouncer

## Endpoints/Access
- Exposes AMQP port (5672) and management UI (15672)
- Access controlled via Kubernetes networking and credentials

## Dependencies
- None (foundational service)

## Docker/Kubernetes Notes
- Use official rabbitmq image with streams enabled
- Set up persistent volume for data
- Configure secrets for credentials

## Testing & Validation
- Validate broker startup and readiness
- Test event publishing/consuming from dependent services
- Confirm message persistence across pod restarts

## Integration Points
- All event-driven services connect via environment variables (host, port, user, password)

