FROM node:17 AS node

COPY package.json yarn.lock ./
RUN yarn install
