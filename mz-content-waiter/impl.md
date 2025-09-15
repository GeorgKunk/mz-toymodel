# mz-content-waiter Implementation Plan

## Purpose
Provides article and content data as a REST API for consumption by mz-frontend and other services. Acts as the main content delivery API.

## Technology Stack
- Node.js (Express) or Python (FastAPI)
- Connects to CMS backend (mz-cms-editor)

## Key Features
- RESTful endpoints for articles and content
- Fetches and aggregates data from CMS
- Serves JSON to frontends
- Enforces access control via JWT (OAuth2)

## Endpoints
- /articles: List all articles
- /articles/{id}: Get article detail
- /overview: Get overview content

## Dependencies
- mz-cms-editor (for content data)
- mz-authorizationserver (for JWT validation)

## Docker/Kubernetes Notes
- Use official Node.js or Python image
- Expose port 8000 (or 3000 for Node.js)
- Configure CMS and auth endpoints via environment variables

## Testing & Validation
- Unit tests for API endpoints
- Integration tests with CMS
- Manual validation of content delivery

## Integration Points
- Consumed by mz-frontend
- Integrates with mz-cms-editor for content
- Validates JWTs from mz-authorizationserver

