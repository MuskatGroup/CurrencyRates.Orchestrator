# CurrencyRates — руководство для AI-агента

## Обзор

Тестовое задание: микросервисная система курсов валют на .NET 8 + PostgreSQL.
Каждый сервис — отдельный git-репозиторий в [MuskatGroup](https://github.com/orgs/MuskatGroup/repositories).

## Где что лежит

| Путь локально | GitHub |
|---------------|--------|
| `CurrencyRates.Orchestrator` | MuskatGroup/CurrencyRates.Orchestrator |
| `CurrencyRates.MigrationService` | MuskatGroup/CurrencyRates.MigrationService |
| `CurrencyRates.RatesWorkerService` | MuskatGroup/CurrencyRates.RatesWorkerService |
| `CurrencyRates.UserService` | MuskatGroup/CurrencyRates.UserService |
| `CurrencyRates.FinanceService` | MuskatGroup/CurrencyRates.FinanceService |
| `CurrencyRates.GatewayService` | MuskatGroup/CurrencyRates.GatewayService |

## Cursor-конфигурация

- **Skill** (архитектура всего решения): `.cursor/skills/currencyrates-architecture/SKILL.md` — только здесь
- **Rules** в C#-репозиториях: `.cursor/rules/currencyrates-common.mdc` + сервисный `.mdc`
- **MCP** — глобально в Cursor, не в репозиториях

## Порядок разработки

1. MigrationService → схема БД *(сделано)*
2. RatesWorkerService → CBR sync *(сделано)*
3. UserService → auth + JWT *(сделано)*
4. FinanceService → rates по favorites *(сделано)*
5. GatewayService → YARP *(сделано)*
6. Orchestrator → полный docker-compose *(сделано; smoke e2e опционально)*

Оставшиеся задачи по сервисам: [docs/remaining-tz-plan.md](docs/remaining-tz-plan.md).

## Открытие workspace

Работайте в root конкретного сервиса (например `CurrencyRates.UserService`), чтобы rules применялись корректно.
