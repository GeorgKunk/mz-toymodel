# Contract Tests

This directory contains contract tests for all REST and event interfaces.

- Use [Schemathesis](https://schemathesis.readthedocs.io/) for OpenAPI-based REST APIs.
- Use [Pact](https://docs.pact.io/) for consumer-driven contract tests if needed.
- Use custom tests for event/message contracts (e.g., JSON Schema validation).

## Example: Schemathesis for OpenAPI

Install Schemathesis:
```
pip install schemathesis
```

Run a contract test:
```
schemathesis run ../rest/openapi/example.yaml --base-url=http://localhost:8000
```

Add a test for each REST API and event interface.

