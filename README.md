# CurrencyRates.Orchestrator

Точка входа для запуска стека CurrencyRates через Docker Compose.

## Требования

Репозитории лежат рядом:

```
CurrencyRates/
  CurrencyRates.Orchestrator/        ← вы здесь
  CurrencyRates.MigrationService/    ← нужен для build migration
  CurrencyRates.RatesWorkerService/  ← нужен для build worker
  CurrencyRates.UserService/         ← нужен для build user
  CurrencyRates.FinanceService/      ← нужен для build finance
  CurrencyRates.GatewayService/      ← нужен для build gateway
```

Установлены Docker Desktop / Docker Engine + Compose v2.

## Сервисы (сейчас)

| Сервис | Порт | Описание |
|--------|------|----------|
| postgres | 5432 | PostgreSQL 16 |
| migration | — | EF migrations (one-shot, exit 0) |
| worker | — | CBR → upsert `currency` |
| user | 5001 | UserService API (register/login/logout) |
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

**Важно:** при первом запуске Migration после старых Finance-миграций сбросьте volume: `docker compose ... down -v`.

Логи:
```bash
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml logs migration
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml logs worker
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml logs user
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml logs gateway
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml logs finance
```

### Dev endpoints (через Gateway)

- Health: http://localhost:5000/health
- Register: `POST http://localhost:5000/api/users/register`
- Login: `POST http://localhost:5000/api/users/login` → `{ token }`
- Add favorite: `POST http://localhost:5000/api/finance/favorites/USD` + Bearer
- Rates: `GET http://localhost:5000/api/finance/rates` + Bearer
- Logout: `POST http://localhost:5000/api/users/logout` + Bearer
- Dev token (fallback, только Development): `POST http://localhost:5000/api/finance/dev/token`
- User Swagger: http://localhost:5001/swagger
- Finance Swagger: http://localhost:5002/swagger

### Smoke e2e (основной путь)

После `up -d --build` и синхронизации Worker:

```bash
# 1. Register
curl -s -X POST http://localhost:5000/api/users/register \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"alice\",\"password\":\"secret1\"}"

# 2. Login → token
TOKEN=$(curl -s -X POST http://localhost:5000/api/users/login \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"alice\",\"password\":\"secret1\"}" | jq -r .token)

# 3. Favorites
curl -s -o /dev/null -w "%{http_code}\n" -X POST http://localhost:5000/api/finance/favorites/USD \
  -H "Authorization: Bearer $TOKEN"

# 4. Rates
curl -s http://localhost:5000/api/finance/rates -H "Authorization: Bearer $TOKEN"
```

Demo seed (Development): user `demo` / password `Demo123!` с favorites USD/EUR.
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

## План оставшихся работ по ТЗ

См. [docs/remaining-tz-plan.md](docs/remaining-tz-plan.md) — статус и задачи по каждому сервису.

## Репозитории

| Сервис | GitHub |
|--------|--------|
| Orchestrator | [CurrencyRates.Orchestrator](https://github.com/MuskatGroup/CurrencyRates.Orchestrator) |
| Finance | [CurrencyRates.FinanceService](https://github.com/MuskatGroup/CurrencyRates.FinanceService) |
| User | [CurrencyRates.UserService](https://github.com/MuskatGroup/CurrencyRates.UserService) |
| Gateway | [CurrencyRates.GatewayService](https://github.com/MuskatGroup/CurrencyRates.GatewayService) |
| Worker | [CurrencyRates.RatesWorkerService](https://github.com/MuskatGroup/CurrencyRates.RatesWorkerService) |
| Migration | [CurrencyRates.MigrationService](https://github.com/MuskatGroup/CurrencyRates.MigrationService) |
