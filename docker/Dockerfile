################################################
# BUILD image
################################################
FROM node:14.21-bullseye as build
WORKDIR /src

RUN apt-get update && \
  apt-get install -y --no-install-recommends wget curl ca-certificates git python build-essential xvfb apt-transport-https && \
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
  rm -rf /var/lib/apt/lists/*

# RUN wget -O /tmp/node-v10.24.1-linux-x64.tar.gz https://nodejs.org/download/release/v10.24.1/node-v10.24.1-linux-x64.tar.gz && \
#   tar -xzf /tmp/node-v10.24.1-linux-x64.tar.gz --directory=/usr/local --strip-components=1 && \
#   npm install -g yarn

COPY package*.json ./
RUN HUSKY="0" yarn install --ignore-engines --legacy-peer-deps

COPY ./ ./
RUN yarn build-all

################################################
# Create strip version of
################################################
FROM build as base
WORKDIR /src

# Remove dev dependencies
RUN HUSKY="0" npm prune --production

# Remove unnecessary stuff not needed in final image
RUN cp docker/pm2-all.json . && \
  rm -rf \
  api/*.js cli/*.js ui/*.js ui/__mocks__ worker/*.js \
  logos \
  docker docker-compose.* *.sh nginx.* postcss* *.babel \
  && touch .env

################################################
# FINAL image
################################################
FROM node:14.21-bullseye as final
WORKDIR /app

RUN apt-get update && \
  apt-get install -y --no-install-recommends ca-certificates build-essential apt-transport-https nginx && \
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
  rm -rf /var/lib/apt/lists/* \
  && npm install -g pm2

COPY --from=base /src /app

EXPOSE 3000
CMD ["pm2-runtime", "start", "pm2-all.json"]