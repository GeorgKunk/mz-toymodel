# mz-authorizationserver Implementation Plan

## Purpose
Central authentication and authorization service for the entire system. Issues JWT tokens and manages OAuth2 SSO for all frontends and APIs. Manages user accounts and subscriber status.

## Technology Stack
- Java 17
- Spring Authorization Server
- Spring Boot
- PostgreSQL (user and subscriber data)

## Key Features
- OAuth2 Authorization Code flow
- SSO login page for all sub-pages
- JWT token issuance and validation
- User registration and management
- Subscriber management ("Abonnenten")

## Endpoints
- /oauth2/authorize: OAuth2 authorization endpoint
- /oauth2/token: Token endpoint
- /login: SSO login page
- /register: User registration
- /users, /subscribers: User and subscriber management APIs

## Dependencies
- PostgreSQL (user/subscriber data)

## Docker/Kubernetes Notes
- Use multi-stage Docker build (Maven + JDK)
- Configure DB connection via environment variables/secrets
- Expose port 8080

## Testing & Validation
- Unit tests for user and token logic
- Integration tests for OAuth2 flow
- Manual SSO login and token validation

## Integration Points
- All frontends and APIs use this for authentication
- mz-gateway enforces OAuth2 and validates tokens
- User/subscriber data shared with subscription and profile services

