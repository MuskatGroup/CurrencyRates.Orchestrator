#!/bin/bash

set -e

if [ ! -f .env.prod ]; then
  echo "Missing .env.prod — copy from .env.example first:"
  echo "  cp .env.example .env.prod"
  exit 1
fi

echo "Deploying CurrencyRates stack to prod environment..."

./scripts/build/build_prod.sh

docker compose --env-file .env.prod -f docker-compose.yml -f docker-compose.prod.yml up -d

echo "Deployment completed for prod environment."
