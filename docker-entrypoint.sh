#!/bin/sh

set -ea

echo "Env file creating..."

cat > /usr/src/app/.env <<EOF
NG_APP_API_URL=$NG_APP_API_URL
NG_APP_VERSION=$NG_APP_VERSION
NG_APP_HOSTNAME=$NG_APP_HOSTNAME
EOF

echo "should create .env file..."

#cat .env

echo "Starting NextJS"
