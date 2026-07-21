#!/bin/bash

set -e

echo "Building CurrencyRates stack for dev environment..."

docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml build

echo "Build completed for dev environment."
