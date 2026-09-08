FROM node:24-alpine AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable

WORKDIR /app

FROM base AS dependencies

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./

RUN pnpm install --frozen-lockfile

FROM base AS production-dependencies

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./

# Keep build and test tooling out of the runtime image.
RUN pnpm install --prod --frozen-lockfile

FROM dependencies AS build

COPY tsconfig.json ./
COPY src ./src

RUN pnpm build

FROM node:24-alpine AS production

ENV NODE_ENV=production

WORKDIR /app

COPY --chown=node:node --from=production-dependencies /app/node_modules ./node_modules
COPY --chown=node:node --from=build /app/dist ./dist

EXPOSE 3000

USER node

CMD ["node", "dist/main.js"]
