# CurrencyRates.Orchestrator

Точка входа для запуска стека CurrencyRates через Docker Compose.

## Требования

Репозитории лежат рядом:

```
CurrencyRates/
  CurrencyRates.Orchestrator/     ← вы здесь
  CurrencyRates.FinanceService/   ← нужен для build finance
  CurrencyRates.GatewayService/   ← нужен для build gateway
```

Установлены Docker Desktop / Docker Engine + Compose v2.

## Сервисы (сейчас)

| Сервис | Порт | Описание |
|--------|------|----------|
| postgres | 5432 | PostgreSQL 16 |
| finance | 5002 | FinanceService API (прямая отладка) |
| gateway | 5000 | YARP API Gateway — **основная точка входа** |

## Подготовка env

```bash
cp .env.example .env.dev
# для prod:
cp .env.example .env.prod
# задайте сильные POSTGRES_PASSWORD и JWT_SECRET_KEY
```

## Development

Собрать:
```bash
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml build --progress=plain
```

Включить:
```bash
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml up -d
```

Пересобрать и перезапустить:
```bash
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml up -d --build
```

Или через скрипт:
```bash
./scripts/deploy/deploy_dev.sh
```

Статус:
```bash
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml ps
```

Логи:
```bash
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml logs gateway
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml logs finance
```

### Dev endpoints (через Gateway)

- Health: http://localhost:5000/health
- Dev token: `POST http://localhost:5000/api/finance/dev/token`
- Rates: `GET http://localhost:5000/api/finance/rates` + Bearer
- Finance Swagger напрямую: http://localhost:5002/swagger

`/api/users/**` пока даёт **502** (UserService ещё не в стеке).

## Production

```bash
cp .env.example .env.prod
# FINANCE_ASPNETCORE_ENVIRONMENT=Production
# GATEWAY_ASPNETCORE_ENVIRONMENT=Production
# FINANCE_SEED_ENABLED=false
# сильные POSTGRES_PASSWORD и JWT_SECRET_KEY

docker compose --env-file .env.prod -f docker-compose.yml -f docker-compose.prod.yml up -d --build
```

Или:
```bash
./scripts/deploy/deploy_prod.sh
```

## Остановка

```bash
# Dev
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml down

# Prod
docker compose --env-file .env.prod -f docker-compose.yml -f docker-compose.prod.yml down
```

Данные Postgres сохраняются в volume `postgres_data`. Сброс: добавьте `-v`.

## Конфигурация

См. [docs/configuration.md](docs/configuration.md).

## Репозитории

| Сервис | GitHub |
|--------|--------|
| Orchestrator | [CurrencyRates.Orchestrator](https://github.com/MuskatGroup/CurrencyRates.Orchestrator) |
| Finance | [CurrencyRates.FinanceService](https://github.com/MuskatGroup/CurrencyRates.FinanceService) |
| User | [CurrencyRates.UserService](https://github.com/MuskatGroup/CurrencyRates.UserService) |
| Gateway | [CurrencyRates.GatewayService](https://github.com/MuskatGroup/CurrencyRates.GatewayService) |
| Worker | [CurrencyRates.RatesWorkerService](https://github.com/MuskatGroup/CurrencyRates.RatesWorkerService) |
| Migration | [CurrencyRates.MigrationService](https://github.com/MuskatGroup/CurrencyRates.MigrationService) |
