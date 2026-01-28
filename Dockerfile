
# -------- dev deps --------
FROM node:19-alpine3.15 AS dev-deps
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile


# -------- build --------
FROM node:19-alpine3.15 AS builder
WORKDIR /app
COPY --from=dev-deps /app/node_modules ./node_modules
COPY . .
# RUN yarn test
RUN yarn build


# -------- prod deps --------
FROM node:19-alpine3.15 AS prod-deps
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --prod --frozen-lockfile


# -------- production --------
FROM node:19-alpine3.15 AS prod
ARG APP_VERSION
ENV APP_VERSION=$APP_VERSION

WORKDIR /app
EXPOSE 3000

COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

CMD ["node", "dist/main.js"]









