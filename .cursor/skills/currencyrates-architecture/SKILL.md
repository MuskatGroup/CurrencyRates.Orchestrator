---
name: currencyrates-architecture
description: Архитектура решения CurrencyRates — микросервисы, БД, CQRS, JWT, порядок запуска. Использовать при разработке любого сервиса CurrencyRates.
---

# CurrencyRates — архитектура решения

## Репозитории (MuskatGroup)

| Сервис | Репозиторий | Назначение |
|--------|-------------|------------|
| Orchestrator | CurrencyRates.Orchestrator | docker-compose, документация, запуск стека |
| Migration | CurrencyRates.MigrationService | EF Core migrations — единственный владелец схемы БД |
| Worker | CurrencyRates.RatesWorkerService | Фоновая синхронизация курсов с CBR |
| User | CurrencyRates.UserService | Register, Login, Logout + JWT |
| Finance | CurrencyRates.FinanceService | Курсы валют по favorites пользователя |
| Gateway | CurrencyRates.GatewayService | YARP API Gateway |

## Стек

- .NET 8, C# 12
- PostgreSQL + EF Core (Npgsql)
- Clean Architecture: Domain → Application → Infrastructure → Api
- CQRS: MediatR (Commands / Queries + Handlers)
- JWT Bearer authentication
- API Gateway: YARP
- Unit-тесты: xUnit + NSubstitute или Moq
- FluentValidation для валидации команд

## Схема БД

```sql
currency (id, name, rate)          -- rate к рублю
user   (id, name, password)        -- password — хеш, не plaintext
favorites (user_id, currency_id)   -- PK (user_id, currency_id)
```

Миграции создаются **только** в MigrationService.

## Порядок запуска

1. PostgreSQL (docker-compose)
2. MigrationService — применить миграции
3. RatesWorkerService — наполнить currency из CBR
4. UserService + FinanceService
5. GatewayService — единая точка входа

## CBR XML

- URL: http://www.cbr.ru/scripts/XML_daily.asp
- Кодировка: windows-1251
- Учитывать Nominal при расчёте rate (rate = Value / Nominal)

## JWT

- UserService выдаёт токен при Login
- Gateway и downstream-сервисы валидируют JWT
- Logout: stateless (клиент удаляет токен); описать в README

## Структура C#-сервиса (User, Finance)

```
src/
  {Service}.Domain/
  {Service}.Application/     # Commands, Queries, Handlers, Interfaces
  {Service}.Infrastructure/  # EF, Repositories, JWT
  {Service}.Api/               # Controllers / Minimal API
tests/
  {Service}.UnitTests/
```

## Соглашения

- Не коммитить bin/, obj/, .vs/
- Минимальный scope изменений
- Один concern на handler
- Пароли: BCrypt или ASP.NET Identity PasswordHasher
