# CurrencyRates.Orchestrator

Точка входа для запуска стека CurrencyRates через Docker Compose.

## Требования

Репозитории лежат рядом:

```
CurrencyRates/
  CurrencyRates.Orchestrator/     ← вы здесь
  CurrencyRates.FinanceService/   ← нужен для build finance
```

Установлены Docker Desktop / Docker Engine + Compose v2.

## Сервисы (сейчас)

| Сервис | Порт | Описание |
|--------|------|----------|
| postgres | 5432 | PostgreSQL 16 |
| finance | 5002 | FinanceService API |

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
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml ps -a
```

Логи:
```bash
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml logs finance
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml logs --tail=100 finance
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml logs -f finance
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml logs
```

Проверка контейнера:
```bash
docker inspect currencyrates-finance | grep -A 10 "State"
docker logs currencyrates-finance --tail 50
```

### Dev endpoints

- Swagger: http://localhost:5002/swagger
- Dev token: `POST http://localhost:5002/api/finance/dev/token`
- Rates: `GET http://localhost:5002/api/finance/rates` + Bearer
- Health: http://localhost:5002/HealthCheck/health

## Production

```bash
cp .env.example .env.prod
# Задайте сильные POSTGRES_PASSWORD и JWT_SECRET_KEY (минимум 32 символа)
# FINANCE_ASPNETCORE_ENVIRONMENT=Production
# FINANCE_SEED_ENABLED=false

docker compose --env-file .env.prod -f docker-compose.yml -f docker-compose.prod.yml up -d --build
```

Или:
```bash
./scripts/deploy/deploy_prod.sh
```

В Production:

- seed выключен (`FINANCE_SEED_ENABLED=false`)
- `/api/finance/dev/token` → 404
- секреты только из `.env.prod` (файл в `.gitignore`)

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
