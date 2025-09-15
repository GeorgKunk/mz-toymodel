# mz-gateway Implementation Plan

## Purpose
Acts as the reverse proxy and API gateway for all frontends and backend services. Orchestrates OAuth2 authentication flow and routes requests to the appropriate service.

## Technology Stack
- Java 17
- Spring Cloud Gateway
- Spring Boot

## Key Features
- Reverse proxy for all frontends and APIs
- Enforces OAuth2 authentication (integrates with mz-authorizationserver)
- Routes requests to services based on path
- Handles token validation and forwarding
- Central point for CORS, rate limiting, and logging

## Endpoints
- / (root): Forwards to mz-frontend
- /api/*: Forwards to backend APIs (content, subscription, etc.)
- /auth/*: Forwards to mz-authorizationserver

## Dependencies
- mz-authorizationserver (for OAuth2)
- All other services (for routing)

## Docker/Kubernetes Notes
- Use multi-stage Docker build (Maven + JDK)
- Expose port 8080
- Configure routing and OAuth2 endpoints via environment variables or config

## Testing & Validation
- Unit tests for route config
- Integration tests for OAuth2 flow
- Manual validation of routing and authentication

## Integration Points
- All frontends and APIs route through the gateway
- Enforces authentication and forwards tokens

