# План выполнения оставшихся пунктов ТЗ

Актуально на момент создания документа. Цель — закрыть всё тестовое задание по сервисам.

## Сводка по ТЗ

| # | Требование | Статус | Где |
|---|------------|--------|-----|
| 1 | Микросервис миграции БД | **Готово** | MigrationService |
| 2 | Фоновый сервис CBR → `currency` | Не начат | RatesWorkerService |
| 3 | User: register / login / logout + CA + CQRS | Каркас | UserService |
| 4 | Finance: курсы по favorites + CA + CQRS | Готово | FinanceService (без своих migrations) |
| 5 | JWT | Частично | Finance + Gateway есть; User должен выдавать токен |
| 6 | API Gateway | Почти готово | GatewayService (User downstream ещё нет) |
| 7 | Unit-тесты User + Finance | Частично | Только Finance |
| 8 | .NET 8, MSVS 2022, GitHub | Частично | Код есть в Finance/Gateway; Migration/Worker без кода |

**Рекомендуемый порядок:** Migration → Worker → User → доработка Finance (убрать владение миграциями) → Orchestrator (полный compose) → полировка Gateway.

---

## 1. CurrencyRates.MigrationService

**Статус:** готово.

Схема `currency` / `user` / `favorites`, Runner + Dockerfile, в Orchestrator как one-shot после Postgres.

---

## 2. CurrencyRates.RatesWorkerService

**Статус:** не начат (только README + rules).

### Цель по ТЗ

Фоновый сервис: периодически ходит на CBR XML и upsert в `currency`.

### Задачи

1. Проект Worker (`net8.0`): `BackgroundService` / `IHostedService`
2. `IHttpClientFactory` → `http://www.cbr.ru/scripts/XML_daily.asp`
3. Парсер XML:
   - кодировка **windows-1251**
   - CharCode, Name, Value, Nominal
   - `rate = Value / Nominal` (запятая → точка)
   - Id валюты = CharCode (как в Finance)
4. EF / raw SQL upsert в `currency` (без своих migrations)
5. Retry с backoff при ошибках сети; сервис не должен падать навсегда
6. Конфиг: интервал опроса, connection string
7. Dockerfile + README
8. В Orchestrator после Migration; unit-тесты **не обязательны** (по желанию — парсер)

### Критерий готовности

После старта в таблице `currency` появляются актуальные курсы с CBR (не только seed).

---

## 3. CurrencyRates.UserService

**Статус:** каркас Api + пустые Domain/Application/Infrastructure без связей.

### Цель по ТЗ

Register, Login, Logout; Clean Architecture + CQRS; JWT; unit-тесты.

### Задачи

1. Структура как у Finance (`src/` + `tests/`):
   - Domain → Application → Infrastructure → Api
   - ProjectReference между слоями
2. Application (MediatR + FluentValidation):
   - `RegisterCommand` + Handler + Validator
   - `LoginCommand` + Handler + Validator → `{ token }`
   - `LogoutCommand` + Handler (stateless: 204; логика «клиент удаляет токен» в README)
3. Infrastructure:
   - EF к той же БД (без migrations)
   - `UserRepository`
   - Password hash (BCrypt или `PasswordHasher`)
   - `JwtTokenService` (тот же Issuer/Audience/Secret, что Gateway/Finance)
4. Api:
   - `POST /api/users/register`
   - `POST /api/users/login`
   - `POST /api/users/logout` `[Authorize]` → 204
   - JWT validation, Swagger в Dev, health
   - Dockerfile, порт **5001**
5. Unit-тесты (xUnit + NSubstitute):
   - Register / Login handlers
   - validators
6. В Orchestrator: сервис `user`, upstream для Gateway уже `http://user:8080`

### Критерий готовности

Через Gateway: register → login → token → (опционально) logout; rates с токеном User работают без Finance `dev/token`.

---

## 4. CurrencyRates.FinanceService

**Статус:** готово по функционалу ТЗ; нужны правки под MigrationService.

### Уже сделано

- CA + CQRS, `GET /api/finance/rates`, JWT, EF, seed, unit-тесты, Docker, Orchestrator

### Оставшиеся задачи

1. ~~Передать владение схемой MigrationService~~ — сделано
2. Убрать или ограничить `POST /api/finance/dev/token` после появления UserService
3. Убедиться, что seed не конфликтует с Worker
4. Почистить мусорные scaffold-папки в корне репо, если ещё остались вне `src/`
5. Прогнать тесты после рефакторинга инициализации БД

### Критерий готовности

Finance стартует **после** Migration; курсы приходят из Worker; auth — через User JWT.

---

## 5. CurrencyRates.GatewayService

**Статус:** готов по своей части ТЗ.

### Уже сделано

- YARP, JWT на защищённых маршрутах, anonymous login/register/dev, `/health`, Docker, Orchestrator

### Оставшиеся задачи

1. После появления UserService — проверить end-to-end: register/login через `:5000`
2. Убедиться, что `GATEWAY_USERS_ADDRESS=http://user:8080/` в compose совпадает с именем сервиса
3. (Опционально) убрать/не рекламировать finance-dev proxy в Production README

### Критерий готовности

Все клиентские вызовы идут на Gateway **:5000**; User и Finance отвечают без 502.

---

## 6. CurrencyRates.Orchestrator

**Статус:** частично — postgres + finance + gateway.

### Уже сделано

- Dev/Prod compose, scripts, env, docs, README

### Оставшиеся задачи

1. Добавить в `docker-compose.yml`:
   - `migration` (one-shot, после healthy postgres)
   - `worker` (после migration)
   - `user` (после migration; рядом с finance)
   - порядок: **Postgres → Migration → Worker + User + Finance → Gateway**
2. Расширить `.env.example` / `docs/configuration.md` переменными User / Worker / Migration
3. Обновить README: полный стек, порты (Gateway 5000, User 5001, Finance 5002)
4. Проверить `deploy_dev.sh` / `deploy_prod.sh` на полный compose
5. Финальный smoke-test из README (register → login → rates через gateway)

### Критерий готовности

Одна команда `docker compose ... up -d --build` поднимает весь стек по ТЗ.

---

## Чеклист сдачи

- [ ] MigrationService накатывает схему
- [ ] Worker наполняет `currency` с CBR
- [ ] User: register / login / logout + unit-тесты
- [ ] Finance: rates + unit-тесты; без своих migrations
- [ ] JWT единый (User выдаёт, Gateway + Finance проверяют)
- [ ] Gateway — единая точка входа
- [ ] Orchestrator поднимает все сервисы
- [ ] Репозитории на GitHub, код собирается в VS 2022 / `net8.0`
- [ ] Нет `bin/`/`obj/` в коммитах; README с инструкцией запуска
