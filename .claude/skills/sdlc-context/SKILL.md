---
name: sdlc-context
description: Use this skill when the user mentions or asks about SDLC Context, including sdlc-context-api, sdlc-context-intake, or sdlc-context-models. This applies to all requests: describing the project, implementing features, debugging issues, adding models, or any other work related to these components. Always invoke this skill first when sdlc-context is mentioned.
---

# SDLC Context Project Agent

You are working on the **sdlc-context** project, part of the DevEx/Devflow platform.

## MANDATORY: Read Agent Instructions First

**Before doing ANY work, you MUST read the Agent instructions file:** ~/dd/dd-source/domains/devex/devflow/libs/sdlc-context-models/Agent.md

This file contains critical guidance for:
- Architecture documentation requirements
- Logging guidelines (structured logging with `log.FromContext(ctx)`)
- Testing guidelines (`t.Context()`, `AssertEqualf` for struct comparison)
- Commenting guidelines
- Code design philosophy (simple, extendable)
- Code cleanup rules (delete dead code)

## Project Structure

**dd-source:**
- **sdlc-context-api** — REST API: `domains/devex/devflow/apps/apis/sdlc-context-api/`
- **sdlc-context-intake** — Event intake: `domains/devex/devflow/apps/sdlc-context-intake/`
- **sdlc-context-models** — Shared models: `domains/devex/devflow/libs/sdlc-context-models/`

**k8s-resources:**
- `k8s/postgres_alembic_cdk/postgres_alembic/migrations/db_clusters/orgstore-sdlc-context/prod` - DB migrations for prod
- `k8s/postgres_alembic_cdk/postgres_alembic/migrations/db_clusters/orgstore-sdlc-context/staging`- DB migrations for staging

## Architecture Documentation

- `domains/devex/devflow/libs/sdlc-context-models/ARCHITECTURE.md` — Index
- `domains/devex/devflow/libs/sdlc-context-models/docs/architecture/OVERVIEW.md` — Platform overview
- `domains/devex/devflow/libs/sdlc-context-models/docs/architecture/DATA_FLOW.md` — Data flow
- `domains/devex/devflow/libs/sdlc-context-models/docs/architecture/DATABASE_SCHEMA.md` — Database design
- `domains/devex/devflow/libs/sdlc-context-models/docs/architecture/MODEL_INTERFACE.md` — Model interface pattern
- `domains/devex/devflow/libs/sdlc-context-models/docs/architecture/MODEL_REGISTRY.md` — Registry and lookup
- `domains/devex/devflow/libs/sdlc-context-models/docs/architecture/ADDING_NEW_MODELS.md` — Adding new models guide
- `domains/devex/devflow/libs/sdlc-context-models/docs/architecture/REST_API.md` — API endpoints

## Instructions

1. **First**: Read `Agent.md` to understand all coding standards
2. **Then**: Execute the user's request following those guidelines
3. **Finally**: Update architecture docs if you changed documented concepts

# User Request

Now execute the following request:

{{{ input }}}
