# Contracts Directory

This directory contains all interface contracts and contract tests for the Marktzeitung monorepo.

## Structure
- `rest/openapi/` — OpenAPI (Swagger) specifications for all REST APIs
- `events/asyncapi/` — AsyncAPI or JSON Schema definitions for all event/message interfaces
- `tests/` — Contract tests for verifying consumer/provider compatibility

## Usage
- For every REST API or event interface, define a schema in the appropriate subdirectory.
- For every interface, implement a contract test in `tests/` that verifies the provider matches the contract and the consumer can interact as expected.
- Run all contract tests in CI before merging changes to any interface.

