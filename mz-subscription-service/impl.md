# mz-subscription-service Implementation Plan

## Purpose
Backend service for managing subscriptions, receipts, and subscription lifecycle. Handles payment confirmation, state transitions, and sends confirmation emails.

## Technology Stack
- Python (FastAPI)
- PostgreSQL (subscriptions, receipts)
- RabbitMQ (event streaming)
- statemachine (Python library for state transitions)

## Key Features
- REST API for subscription management
- Handles payment provider callbacks
- Manages subscription state transitions
- Creates and updates receipts
- Publishes events to RabbitMQ
- Sends confirmation emails

## Endpoints
- /subscriptions: Manage subscriptions
- /receipts: Manage receipts
- /payment/callback: Handle payment provider notifications

## Dependencies
- PostgreSQL (data storage)
- RabbitMQ (event streaming)
- Email service (SMTP or API)
- Payment provider (external)

## Docker/Kubernetes Notes
- Use official Python image
- Expose port 8000
- Configure DB, RabbitMQ, and email via environment variables

## Testing & Validation
- Unit tests for state transitions
- Integration tests for payment and email flows
- Event publishing/consuming tests

## Integration Points
- Publishes events to RabbitMQ (for mz-content-bouncer)
- Stores data in PostgreSQL
- Consumed by mz-user-page and mz-subscription-shop

