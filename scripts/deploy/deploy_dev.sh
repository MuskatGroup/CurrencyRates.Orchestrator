#!/bin/bash

set -e

if [ ! -f .env.dev ]; then
  echo "Missing .env.dev — copy from .env.example first:"
  echo "  cp .env.example .env.dev"
  exit 1
fi

echo "Deploying CurrencyRates stack to dev environment..."

./scripts/build/build_dev.sh

docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml up -d

echo "Deployment completed for dev environment."
