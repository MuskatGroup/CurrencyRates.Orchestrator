#!/bin/bash

set -e

echo "Building CurrencyRates stack for prod environment..."

docker compose --env-file .env.prod -f docker-compose.yml -f docker-compose.prod.yml build

echo "Build completed for prod environment."
