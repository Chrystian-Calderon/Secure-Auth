# Copilot instructions

## Project overview

This is a TypeScript/Node.js ESM authentication service being prepared around NestJS. The intended flow is an authentication API backed by PostgreSQL/Prisma, with Redis for cache and protection concerns. The service is organized around users, authentication, sessions, tokens, email/password verification, authorization, and audit logging. `src/main.ts` remains the current entry point; the feature modules are currently directory placeholders only.

Cross-cutting NestJS concerns belong under `src/common/`; configuration under `src/config/`; database and Redis integrations under `src/database/`; and business capabilities under `src/modules/`. Keep the execution flow rooted at `src/main.ts` and wire new modules through the Nest application boundary when it is introduced. PostgreSQL access should be centralized through Prisma rather than mixed into feature modules, and Redis should be treated as infrastructure for sessions, token revocation/rotation, and rate limiting.

## Commands

Use pnpm 11.24.0, as pinned by `package.json` and `pnpm-lock.yaml`.

```sh
pnpm install
pnpm dev
```

`pnpm dev` runs `tsx watch src/main.ts`.

NestJS-oriented commands are prepared in `package.json` for when the application bootstrap and module files are added:

```sh
pnpm build
pnpm start
pnpm start:prod
```

Type-check the project directly with:

```sh
pnpm exec tsc --noEmit
```

Jest and Supertest are installed for unit and HTTP integration testing:

```sh
pnpm test
pnpm test -- path/to/file.spec.ts
pnpm test -- -t "test name"
pnpm test:e2e
```

Prisma commands are prepared for the database schema:

```sh
pnpm prisma:generate
pnpm prisma:migrate
```

No lint script is configured yet.

## TypeScript and module conventions

- The package uses `"type": "module"` and `module: "nodenext"`; use ESM syntax and ensure relative imports follow Node's ESM/TypeScript resolution rules.
- TypeScript is strict, with `noUncheckedIndexedAccess` and `exactOptionalPropertyTypes` enabled. Preserve those guarantees instead of weakening compiler options or adding broad type assertions.
- The configured target is `esnext`; use the existing compiler configuration rather than introducing a separate transpilation or bundling path without updating the package scripts and documentation.
- NestJS decorator metadata is enabled in `tsconfig.json`; preserve that configuration for decorated controllers, providers, guards, and modules.
- `verbatimModuleSyntax`, `isolatedModules`, `noUncheckedSideEffectImports`, and forced module detection are enabled, so keep imports explicit and avoid patterns that rely on compiler rewriting or implicit side effects.
- Node typings are installed as a development dependency, but `tsconfig.json` currently sets `types` to an empty list. If Node APIs are introduced, update the compiler configuration deliberately rather than relying on ambient types appearing accidentally.

## Dependency and workspace conventions

- Use pnpm and keep `pnpm-lock.yaml` synchronized with dependency changes.
- `pnpm-workspace.yaml` permits esbuild's install/build step; preserve this configuration when changing packages that depend on esbuild.
- Keep runtime dependencies separate from development-only tooling in `package.json`.
- Keep authentication concerns separated by module: credential/user lifecycle, sessions, access and refresh tokens, verification flows, audit events, and authorization policies should not be collapsed into one service.

## Docker

`Dockerfile` builds the TypeScript API image with pnpm, while `docker-compose.yml` defines the API, PostgreSQL, and Redis services with health checks and named data volumes. Compose values can be overridden through shell environment variables such as `API_PORT`, `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `REDIS_PORT`; do not commit real credentials.
