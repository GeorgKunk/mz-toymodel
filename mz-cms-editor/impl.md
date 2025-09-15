# mz-cms-editor Implementation Plan

## Purpose
Headless CMS for managing articles and overview content. Provides an admin interface for editors and exposes content APIs for mz-content-waiter.

## Technology Stack
- Strapi (Node.js, open-source headless CMS)
- SQLite or PostgreSQL (for content storage)

## Key Features
- Admin UI for content creation and editing
- Content types for articles and overview
- REST and GraphQL APIs for content delivery
- Authentication for editors

## Endpoints
- /admin: Editor UI
- /content: Public content API (consumed by mz-content-waiter)

## Dependencies
- PostgreSQL (preferred for production)
- mz-content-waiter (as consumer)

## Docker/Kubernetes Notes
- Use official Strapi Docker image
- Expose port 1337
- Configure DB connection via environment variables

## Testing & Validation
- Manual testing of admin UI
- API tests for content endpoints
- Integration tests with mz-content-waiter

## Integration Points
- Provides content to mz-content-waiter
- Stores data in PostgreSQL

