# Конфигурация CurrencyRates Orchestrator

Переменные задаются в `.env.dev` / `.env.prod` (шаблон: `.env.example`).

## PostgreSQL

| Переменная | Описание |
|------------|----------|
| `POSTGRES_USER` | Пользователь БД |
| `POSTGRES_PASSWORD` | Пароль |
| `POSTGRES_DB` | Имя базы |

## JWT

| Переменная | Описание |
|------------|----------|
| `JWT_ISSUER` | Issuer токена |
| `JWT_AUDIENCE` | Audience токена |
| `JWT_SECRET_KEY` | Секрет подписи (минимум 32 символа). В prod: `openssl rand -base64 48` |

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
| `GATEWAY_USERS_ADDRESS` | Upstream User (`http://user:8080/`) — до UserService будет 502 |

## Запуск

```bash
# Dev
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml up -d

# Prod
docker compose --env-file .env.prod -f docker-compose.yml -f docker-compose.prod.yml up -d
```
