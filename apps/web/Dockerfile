# syntax=docker/dockerfile:1

# Development target: Vite dev server with hot reload (source is mounted by
# compose.override.yaml). A production static-serving target will be added
# with the deployment phase.
FROM node:22.22.1-alpine3.22 AS dev
WORKDIR /app
RUN chown node:node /app
USER node
COPY --chown=node:node package.json package-lock.json ./
RUN npm ci
COPY --chown=node:node . .
EXPOSE 3000
# vite.config.ts already binds 0.0.0.0:3000.
CMD ["npm", "run", "dev"]
