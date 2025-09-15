# PostgreSQL Service Implementation Plan

## Purpose
Central relational database for all user, subscription, and receipt data. Acts as the single source of truth for the system.

## Technology Stack
- PostgreSQL (official Docker image)
- Persistent storage via Kubernetes PVC

## Key Features
- Stores users, subscriptions, receipts
- Used by: mz-authorizationserver, mz-subscription-service, mz-content-bouncer, mz-user-page, mz-subscription-shop

## Endpoints/Access
- Exposes standard PostgreSQL port (5432)
- Access controlled via Kubernetes networking and credentials

## Dependencies
- None (foundational service)

## Docker/Kubernetes Notes
- Use official postgres image
- Set up persistent volume for data
- Configure secrets for DB credentials

## Testing & Validation
- Validate DB startup and readiness
- Test schema migrations from dependent services
- Confirm data persistence across pod restarts

## Integration Points
- All backend services connect via environment variables (host, port, user, password, db name)

