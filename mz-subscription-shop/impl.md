# mz-subscription-shop Implementation Plan

## Purpose
Svelte-based frontend for subscription purchase and registration. Handles SSO login, subscription selection, payment flow, and post-payment confirmation.

## Technology Stack
- Svelte (server-side rendered)
- Node.js (for SSR and static serving)
- OAuth2 SSO (via mz-authorizationserver)

## Key Features
- Registration and login via SSO
- Subscription selection and purchase flow
- Payment provider integration ("Zahlkumpel")
- Post-payment confirmation and redirection
- Fetches data from mz-subscription-service

## Endpoints
- /shop: Subscription selection
- /register: Registration page
- /login: SSO login (redirects to mz-authorizationserver)
- /payment/confirm: Payment confirmation

## Dependencies
- mz-authorizationserver (SSO)
- mz-subscription-service (subscription data)
- Payment provider (external)
- mz-gateway (reverse proxy)

## Docker/Kubernetes Notes
- Use official Node.js image
- Expose port 3000
- Configure API, auth, and payment endpoints via environment variables

## Testing & Validation
- Unit and integration tests for Svelte components
- Manual validation of SSO, payment, and subscription flows
- End-to-end tests for purchase flow

## Integration Points
- Consumes APIs from mz-subscription-service
- Authenticates via mz-authorizationserver
- Integrates with payment provider
- Routed through mz-gateway

