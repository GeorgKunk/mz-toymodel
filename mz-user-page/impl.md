# mz-user-page Implementation Plan

## Purpose
Svelte-based frontend for displaying user profile and subscription data. Authenticated via SSO and fetches data from backend services.

## Technology Stack
- Svelte (server-side rendered)
- Node.js (for SSR and static serving)
- OAuth2 SSO (via mz-authorizationserver)

## Key Features
- User profile display (email, address, etc.)
- List of active and past subscriptions
- SSO login and session management
- Fetches data from mz-subscription-service

## Endpoints
- /profile: User profile page
- /subscriptions: List of user subscriptions
- /login: SSO login (redirects to mz-authorizationserver)

## Dependencies
- mz-authorizationserver (SSO)
- mz-subscription-service (user/subscription data)
- mz-gateway (reverse proxy)

## Docker/Kubernetes Notes
- Use official Node.js image
- Expose port 3000
- Configure API and auth endpoints via environment variables

## Testing & Validation
- Unit and integration tests for Svelte components
- Manual validation of SSO and data fetching
- End-to-end tests for user profile flow

## Integration Points
- Consumes APIs from mz-subscription-service
- Authenticates via mz-authorizationserver
- Routed through mz-gateway

