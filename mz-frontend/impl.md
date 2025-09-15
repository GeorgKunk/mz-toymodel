# mz-frontend Implementation Plan

## Purpose
Main Svelte-based frontend for the newspaper. Provides landing page, article detail pages, and integrates with SSO and content APIs.

## Technology Stack
- Svelte (server-side rendered)
- Node.js (for SSR and static serving)
- OAuth2 SSO (via mz-authorizationserver)

## Key Features
- Landing page with article overview
- Article detail pages
- OAuth2 SSO login and session management
- Fetches content from mz-content-waiter
- Access checks via mz-content-bouncer

## Endpoints
- /: Landing page
- /article/{id}: Article detail
- /login: SSO login (redirects to mz-authorizationserver)

## Dependencies
- mz-content-waiter (content data)
- mz-authorizationserver (SSO)
- mz-content-bouncer (access checks)
- mz-gateway (reverse proxy)

## Docker/Kubernetes Notes
- Use official Node.js image
- Expose port 3000
- Configure API and auth endpoints via environment variables

## Testing & Validation
- Unit and integration tests for Svelte components
- Manual validation of SSO and content fetching
- End-to-end tests for user flow

## Integration Points
- Consumes APIs from mz-content-waiter and mz-content-bouncer
- Authenticates via mz-authorizationserver
- Routed through mz-gateway

