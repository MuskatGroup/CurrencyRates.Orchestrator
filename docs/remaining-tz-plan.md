# План выполнения оставшихся пунктов ТЗ

## Сводка по ТЗ

| # | Требование | Статус | Где |
|---|------------|--------|-----|
| 1 | Микросервис миграции БД | **Готово** | MigrationService (+ UNIQUE `user.name`) |
| 2 | Фоновый сервис CBR → `currency` | **Готово** | RatesWorkerService |
| 3 | User: register / login / logout + CA + CQRS | **Готово** | UserService |
| 4 | Finance: курсы по favorites + CA + CQRS | **Готово** | + API add/remove favorites |
| 5 | JWT | **Готово** | User выдаёт; Gateway + Finance валидируют |
| 6 | API Gateway | **Готово** | GatewayService |
| 7 | Unit-тесты User + Finance | **Готово** | оба сервиса |
| 8 | .NET 8, MSVS 2022, GitHub | Частично | `.sln` + `.slnx`; push / smoke на стенде |

**Рекомендуемый порядок:** smoke e2e из Orchestrator README → push на GitHub.

---

## Закрытые доработки после аудита

- UNIQUE `user.name` (migration `AddUniqueUserName`)
- `POST/DELETE /api/finance/favorites/{currencyId}`
- Валидный BCrypt seed (`demo` / `Demo123!`); `Seed:Enabled=false` в базовом appsettings
- Invalid user claim → 401
- Worker: User-Agent + timeout; warning на empty parse
- Классические `.sln` рядом со `.slnx`
- Smoke e2e в Orchestrator README

---

## Чеклист сдачи

- [x] MigrationService накатывает схему
- [x] Worker наполняет `currency` с CBR
- [x] User: register / login / logout + unit-тесты
- [x] Finance: rates + favorites API + unit-тесты; без своих migrations
- [x] JWT единый
- [x] Gateway — единая точка входа
- [x] Orchestrator поднимает все сервисы
- [ ] Репозитории на GitHub
- [ ] Smoke e2e на стенде ревьюера
