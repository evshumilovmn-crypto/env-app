ARG NODE_VERSION=22.17.0
#STAGE 1
# Use node image for base image for all stages.
FROM node:${NODE_VERSION}-alpine AS build

ENV NG_APP_API_URL=http://docker-variable/api

# Set working directory for all build stages.
WORKDIR /usr/src/app
EXPOSE 3000

COPY --chown=1000:1000 \
    ./docker-entrypoint.sh \
    ./package.json \
    ./package-lock.json \
    ./

RUN chmod +x docker-entrypoint.sh
RUN ./docker-entrypoint.sh

RUN npm install
COPY . .
RUN npm run build

#STAGE 2
FROM nginx:1.17.1-alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /usr/src/app/dist/env-app/browser /usr/share/nginx/html
