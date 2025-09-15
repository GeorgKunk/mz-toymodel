# Marktzeitung Monorepo Implementation Plan

This document outlines the implementation plan for the Marktzeitung monorepo, which models the services and web frontends of a German newspaper, inspired by Handelsblatt. The system is designed to run locally using Minikube, with each service mounted as a separate component.

## Implementation Order and Dependency Awareness

When implementing a service, always consider and integrate with all services that appear earlier in the implementation order below. This ensures that interfaces, APIs, and events are aligned and compatible. The recommended order, based on service dependencies, is:

1. infra/postgres (PostgreSQL)
2. infra/rabbitmq (RabbitMQ)
3. mz-authorizationserver
4. mz-gateway
5. mz-content-waiter
6. mz-cms-editor
7. mz-subscription-service
8. mz-content-bouncer
9. mz-frontend
10. mz-user-page
11. mz-subscription-shop

When building a service, you must:
- Reference the API/event schemas of all earlier services it depends on.
- Use contract tests to verify integration points.
- Update shared schemas or contracts as needed, and coordinate changes with dependent services.

## Interface Alignment and Contract Testing

To ensure matching interfaces between services:
- Define all REST APIs using OpenAPI (Swagger) specifications, and all event/message formats using AsyncAPI or JSON Schema.
- Store all schemas in a central directory (e.g., /contracts or /schemas) in the monorepo (serves as a simple schema registry).
- Use contract testing tools (e.g., Pact for REST, Schemathesis for OpenAPI, or custom tests for events) to verify that consumers and providers agree on the interface.
- Require contract tests to pass in CI before merging changes that affect service interfaces.
- For breaking changes, coordinate updates across all affected services and update the shared schema.

This approach ensures that all service integrations are robust, versioned, and validated automatically.

## Contract Testing Requirements

For every REST API or event interface between services:
- Define the interface schema in `/contracts/rest/openapi/` (for REST) or `/contracts/events/asyncapi/` (for events).
- Implement a contract test in `/contracts/tests/` that verifies the provider matches the contract and the consumer can interact as expected.
- Use Schemathesis for OpenAPI-based REST APIs, Pact for consumer-driven REST contracts, and custom tests for event/message contracts.
- All contract tests must pass in CI before merging changes to any interface.

Refer to `/contracts/README.md` and `/contracts/tests/README.md` for setup and examples.

## Overview of Services

1. **mz-frontend**
   - Svelte application
   - Landing page (overview of articles)
   - Article detail pages
   - Authenticated via OAuth2 SSO

2. **mz-content-waiter**
   - API layer providing article and content data as JSON
   - Consumed by mz-frontend
   - RESTful endpoints

3. **cms-editor**
   - Simple open-source CMS for editing articles and managing overview content
   - Should integrate with mz-content-waiter for content storage
   - Candidate: [Strapi](https://strapi.io/) (Node.js, open-source, headless CMS)

4. **mz-authorizationserver**
   - Spring Authorization Server
   - Manages user authentication and OAuth2 Authorization Code flow
   - Provides SSO login page for all sub-pages
   - Manages "Abonnenten" (subscribers)

5. **mz-gateway**
   - Spring Cloud Gateway
   - Reverse proxy for all frontends
   - Orchestrates OAuth2 flow
   - Routes requests to appropriate services

6. **mz-content-bouncer**
   - REST API for access checks against user subscriptions
   - Used by mz-frontend and other services to enforce access control

7. **mz-user-page**
   - Frontend for displaying user subscriptions and profile data (email, address)
   - Authenticated via SSO

8. **mz-subscription-shop**
   - Frontend for purchasing subscriptions
   - Registration/login via SSO
   - Subscription selection
   - Payment provider integration ("Zahlkumpel" - PayPal-like)
   - Post-payment confirmation and redirection to original page

9. **mz-subscription-service**
   - Backend for managing subscriptions
   - Waits for payment confirmation from payment provider
   - Sends confirmation email to user
   - Uses Python `statemachine` library to model subscription state transitions

## Implementation Steps

### 1. Monorepo Structure
- Organize each service in its own directory under the monorepo root.
- Use Docker for containerization of each service.
- Provide Kubernetes manifests for Minikube deployment.

### 2. Service Implementation
- **mz-frontend**: Scaffold Svelte app, implement routing, integrate with mz-content-waiter and SSO.
- **mz-content-waiter**: Implement REST API (Node.js/Express or Python/FastAPI), connect to CMS/editor backend.
- **cms-editor**: Deploy Strapi or similar CMS, configure content types for articles.
- **mz-authorizationserver**: Set up Spring Authorization Server, configure OAuth2, user management.
- **mz-gateway**: Set up Spring Cloud Gateway, configure routes, integrate with mz-authorizationserver.
- **mz-content-bouncer**: Implement REST API (Java/Spring Boot or Python), integrate with mz-subscription-service.
- **mz-user-page**: Scaffold frontend (Svelte, server-side rendered), fetch and display user data from mz-subscription-service. Keep frontend slim and render server-side.
- **mz-subscription-shop**: Scaffold frontend (Svelte, server-side rendered), implement registration/login, subscription selection, payment flow, and redirection logic. Keep frontend slim and render server-side.
- **mz-subscription-service**: Implement backend (Python/FastAPI), use `statemachine` for subscription lifecycle, integrate with payment provider and email service.

### 3. Authentication & Authorization
- Centralize authentication via mz-authorizationserver (Spring Authorization Server, OAuth2 SSO).
- All frontends and APIs validate JWT tokens issued by the mz-authorizationserver.
- mz-gateway (Spring Cloud Gateway) enforces authentication and routes requests.

### 4. Inter-Service Communication
- Use REST APIs (FastAPI for all non-Spring services) for communication between services.
- Use internal service discovery within Kubernetes.

### 5. Local Development & Deployment
- Provide Dockerfiles for all services.
- Provide Kubernetes manifests for Minikube.
- Document local setup, including Minikube installation, service deployment, and ingress configuration.

### 6. Testing & Validation
- Implement unit and integration tests for each service.
- Provide end-to-end test scenarios for the full user flow (registration, login, subscription purchase, access control).

### 7. Documentation
- Maintain up-to-date documentation for:
  - Service APIs
  - Deployment instructions
  - Developer onboarding
  - Test scenarios

### 8. Frontend Design Instructions
- All frontends must be implemented with Svelte and rendered server-side.
- Keep frontends as slim as possible, delegating logic to backend services.
- For look and feel, refer to example HTML sources of the real Handelsblatt (to be provided later).
- Strive for maximum visual and UX similarity to the real Handelsblatt.

### 9. Database and Messaging Architecture
- Use a single PostgreSQL database for users, subscriptions, and receipts.
- **Receipts**: Represent confirmations for made subscriptions. Used as the basis for access checks.
  - When a user orders a subscription, a receipt is created with a TTL (time-to-live) expiration date.
  - If the subscription is confirmed, the receipt TTL is updated to the actual subscription expiration date (or set to never expire for unlimited subscriptions).
  - The mz-subscription-service can send a receipt cancellation to the mz-content-bouncer if needed.
- **mz-content-bouncer**: Checks access based on the current state of receipts in the database.
- **Inter-process communication**: Use RabbitMQ streams for asynchronous events such as receipt creation, confirmation, and cancellation between services (e.g., mz-subscription-service to mz-content-bouncer).

### 10. Backend Integration Instructions
- All backend services (except Java/Spring) should use FastAPI.
- PostgreSQL should be used as the single source of truth for users, subscriptions, and receipts.
- Use RabbitMQ streams for inter-service communication regarding subscription and receipt events (creation, confirmation, cancellation).
- Ensure mz-content-bouncer listens for receipt cancellation events and updates access rights accordingly.

### Local Domain Access for Services (macOS)

To access each service via a friendly local domain, follow these steps:

1. Get your Minikube IP:
   ```sh
   minikube ip
   ```
2. Edit your `/etc/hosts` file and add (replace the IP with your Minikube IP):
   ```
   192.168.49.2 frontend.local.marktzeitung.test content-waiter.local.marktzeitung.test cms-editor.local.marktzeitung.test authorizationserver.local.marktzeitung.test gateway.local.marktzeitung.test content-bouncer.local.marktzeitung.test user-page.local.marktzeitung.test subscription-shop.local.marktzeitung.test subscription-service.local.marktzeitung.test
   ```
3. Save and close the file. You can now access each service in your browser using its local domain (e.g., http://frontend.local.marktzeitung.test).

If you change your Minikube IP, update `/etc/hosts` accordingly.

## Next Steps
1. Scaffold directory structure for all services (FastAPI for REST APIs, Svelte for frontends, Spring for Java services).
2. Set up basic Docker and Kubernetes configuration for each service.
3. Implement minimal viable versions of each service.
4. Integrate authentication and service communication.
5. Expand features iteratively, following the plan above.

---

This plan serves as a blueprint for implementing the Marktzeitung monorepo. Each service should be developed and tested independently, then integrated and deployed via Minikube for local development and testing.
