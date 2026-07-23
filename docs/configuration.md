# Конфигурация CurrencyRates Orchestrator

Переменные задаются в `.env.dev` / `.env.prod` (шаблон: `.env.example`).

## PostgreSQL

| Переменная | Описание |
|------------|----------|
| `POSTGRES_USER` | Пользователь БД |
| `POSTGRES_PASSWORD` | Пароль |
| `POSTGRES_DB` | Имя базы |

## Migration Service

| Переменная | Описание |
|------------|----------|
| `MIGRATION_CONNECTION_STRING` | Строка подключения для one-shot Runner (`Host=postgres;...`) |

## JWT

| Переменная | Описание |
|------------|----------|
| `JWT_ISSUER` | Issuer токена |
| `JWT_AUDIENCE` | Audience токена |
| `JWT_SECRET_KEY` | Секрет подписи (минимум 32 символа). В prod: `openssl rand -base64 48` |

## Rates Worker Service

| Переменная | Описание |
|------------|----------|
| `WORKER_DOTNET_ENVIRONMENT` | `Development` / `Production` |
| `WORKER_CONNECTION_STRING` | Строка подключения к Postgres |
| `WORKER_CBR_URL` | URL XML ЦБ РФ |
| `WORKER_CBR_INTERVAL` | Интервал синхронизации (`01:00:00`) |

## User Service

| Переменная | Описание |
|------------|----------|
| `USER_ASPNETCORE_URLS` | URL внутри контейнера (`http://+:8080`) |
| `USER_ASPNETCORE_ENVIRONMENT` | `Development` / `Production` |
| `USER_HOST_PORT` | Порт на хосте (по умолчанию `5001`) |
| `USER_CONNECTION_STRING` | Строка подключения к Postgres |

## Finance Service

| Переменная | Описание |
|------------|----------|
| `FINANCE_ASPNETCORE_URLS` | URL внутри контейнера (`http://+:8080`) |
| `FINANCE_ASPNETCORE_ENVIRONMENT` | `Development` / `Production` |
| `FINANCE_HOST_PORT` | Порт на хосте (по умолчанию `5002`) |
| `FINANCE_CONNECTION_STRING` | Строка подключения к Postgres |
| `FINANCE_SEED_ENABLED` | Seed demo-данных (`true` в dev, `false` в prod) |
| `FINANCE_SEED_TEST_USER_ID` | Id demo-пользователя |
| `FINANCE_SEED_TEST_USER_NAME` | Имя demo-пользователя |

## Gateway Service

| Переменная | Описание |
|------------|----------|
| `GATEWAY_ASPNETCORE_URLS` | URL внутри контейнера (`http://+:8080`) |
| `GATEWAY_ASPNETCORE_ENVIRONMENT` | `Development` / `Production` |
| `GATEWAY_HOST_PORT` | Порт на хосте (по умолчанию `5000`) |
| `GATEWAY_FINANCE_ADDRESS` | Upstream Finance (`http://finance:8080/`) |
| `GATEWAY_USERS_ADDRESS` | Upstream User (`http://user:8080/`) |

## Web (demo SPA)

| Переменная | Описание |
|------------|----------|
| `WEB_HOST_PORT` | Порт на хосте (по умолчанию `3000`) |

## Запуск

```bash
# Dev
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml up -d

# Prod
docker compose --env-file .env.prod -f docker-compose.yml -f docker-compose.prod.yml up -d
```
