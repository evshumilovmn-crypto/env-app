# =========================================
# Stage 1: Build the Angular Application
# =========================================

ARG NODE_VERSION=24.7.0-alpine
ARG NGINX_VERSION=alpine3.22

# Use a lightweight Node.js image for building (customizable via ARG)
FROM node:${NODE_VERSION} AS builder

# Set the working directory inside the container
WORKDIR /var/lib/dev/env-app

# Copy package-related files first to leverage Docker's caching mechanism
COPY docker-entrypoint.sh package.json package-lock.json ./

RUN chmod +x docker-entrypoint.sh
RUN ./docker-entrypoint.sh

# Install project dependencies using npm ci (ensures a clean, reproducible install)
RUN --mount=type=cache,target=/root/.npm npm ci

# Copy the rest of the application source code into the container
COPY . .

# Build the Angular application
RUN npm run build

# =========================================
# Stage 2: Prepare Nginx to Serve Static Files
# =========================================

FROM nginxinc/nginx-unprivileged:${NGINX_VERSION} AS runner

# Use a built-in non-root user for security best practices
USER nginx

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the static build output from the build stage to Nginx's default HTML serving directory
#COPY --chown=nginx:nginx --from=builder /var/lib/dev/env-app/dist/browser  /usr/share/nginx/html


# Expose port 8080 to allow HTTP traffic
# Note: The default NGINX container now listens on port 8080 instead of 80
EXPOSE 8080

# Start Nginx directly with custom config
ENTRYPOINT ["nginx", "-c", "/etc/nginx/nginx.conf"]
CMD ["-g", "daemon off;"]



#ARG NODE_VERSION=22.17.0
#
#################################################################################
## Use node image for base image for all stages.
#FROM node:${NODE_VERSION}-alpine AS build
#
## Set working directory for all build stages.
#WORKDIR /usr/src/app/env-app
#
#EXPOSE 3000
#
#COPY --chown=1000:1000 ./public ./public
#
#COPY --chown=1000:1000 \
#    ./docker-entrypoint.sh \
#    ./package.json \
#    ./package-lock.json \
#    ./
#
#RUN chmod +x docker-entrypoint.sh
#RUN ./docker-entrypoint.sh
#
#RUN npm install
#
#COPY . .
#
#RUN npm run build
#
## Run the application.
#CMD npm start
