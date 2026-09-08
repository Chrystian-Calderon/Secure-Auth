# Secure Auth

Servicio de autenticación independiente, desarrollado con Node.js, TypeScript y NestJS. Está preparado para usar PostgreSQL mediante Prisma y Redis para sesiones, revocación de tokens y protección contra abusos.

> **Estado actual:** la estructura y las dependencias del servicio están preparadas, pero la API aún está en fase inicial. El punto de entrada actual solo escribe `Secure auth` en consola.

## Tecnologías

- Node.js 24 y TypeScript
- NestJS 11
- PostgreSQL 17 y Prisma
- Redis 8
- JWT, Passport y Argon2
- pnpm 11

## Requisitos

- Node.js 24 o posterior
- pnpm 11.24.0
- Docker y Docker Compose (opcional, para ejecutar la infraestructura)

## Instalación

```bash
pnpm install
```

## Comandos disponibles

```bash
# Desarrollo con recarga automática
pnpm dev

# Compilar el proyecto
pnpm build

# Ejecutar la compilación generada
pnpm start:prod

# Ejecutar pruebas
pnpm test

# Comprobar tipos
pnpm exec tsc --noEmit
```

## Base de datos

Cuando se añada el esquema de Prisma, se podrán utilizar estos comandos:

```bash
pnpm prisma:generate
pnpm prisma:migrate
```

## Docker

El `Dockerfile` usa varias etapas: compila el servicio por separado y deja en la imagen final únicamente las dependencias necesarias en producción. El proceso se ejecuta con el usuario sin privilegios `node`.

Para iniciar API, PostgreSQL y Redis:

```bash
docker compose up --build
```

La API queda publicada en `http://localhost:3000` de forma predeterminada. Puedes cambiar los valores mediante variables de entorno:

| Variable | Valor predeterminado |
| --- | --- |
| `API_PORT` | `3000` |
| `POSTGRES_PORT` | `5432` |
| `POSTGRES_DB` | `secure_auth` |
| `POSTGRES_USER` | `auth_user` |
| `POSTGRES_PASSWORD` | `auth_password` |
| `REDIS_PORT` | `6379` |

No uses las credenciales predeterminadas fuera de un entorno local.

## Limitación conocida

La versión actual de `typescript` (`7.0.2`) no expone la API de compilador que necesita Nest CLI, por lo que `pnpm build` y la construcción completa de Docker fallan actualmente. Hasta que NestJS sea compatible, usa TypeScript 6 para compilar el proyecto.
