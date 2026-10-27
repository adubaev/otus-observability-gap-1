# ДЗ 9. Централизованное логирование на основе OpenSearch

Настроена цепочка:

**Fluent Bit → Data Prepper → OpenSearch → OpenSearch Dashboards.**

Fluent Bit читает Docker-журналы nginx, PHP-FPM и MariaDB, добавляет имя сервиса и отправляет сообщения в HTTP-приёмник Data Prepper. Data Prepper разбирает access-логи nginx через grok, преобразует `status` и `bytes` в числа и добавляет поле `pipeline: data-prepper`.

Конфигурации:

- [Fluent Bit](fluent-bit.conf).
- [Конвейер Data Prepper](pipelines.yaml).
- [Основные настройки Data Prepper](data-prepper-config.yaml).

В примере пароль OpenSearch заменён на `${OPENSEARCH_PASSWORD}`. При развёртывании нужно подставить свой пароль в приватную копию конфигурации.

Перед запуском отправки создан индекс `hw9-cms-structured` с явными типами полей: `event_time` — date; `service_name`, `pipeline`, `method`, `path` — keyword; `status` — integer; `bytes` — long. Для учебного индекса используется один primary shard без реплик.

## Проверка

На nginx отправлены контрольные запросы к несуществующим страницам с префиксом `/otus-hw9-`. В OpenSearch найдены полученные записи с полями HTTP-запроса и метками Fluent Bit/Data Prepper. Ответ 404 в этих записях ожидаемый.

В Dashboards создано представление индекса и дашборд: число событий, источники журналов, HTTP-коды и поступление логов во времени. Сохранённые представления находятся в tenant **Private** учебной учётной записи.

## ISM — задание со звёздочкой

Политика `hw9-logs-retention` назначена индексу `hw9-cms-structured`:

- До 7 дней — состояние `hot`, запись и поиск, ноль реплик на учебном узле.
- С 7 дней — `read_only`, индекс доступен для поиска, запись запрещена.
- С 30 дней — `delete`, учебный индекс удаляется.

Возраст считается от создания индекса. Шаблон ISM автоматически назначает политику новым индексам `hw9-cms-structured*`. Существующему индексу политика назначена отдельно через ISM API. Индексы Graylog не входят в шаблон.

[Конфигурация политики](ism-policy.json). Проверка выполнена через Explain API. Подтверждены назначение политики, `enabled: true`, состояние `hot` и успешная установка нулевого числа реплик. В Dashboards задача отображается как `Running`. Переходы через 7/30 дней и удаление принудительно не запускались. Это политика хранения учебного индекса, ротация через rollover здесь не настроена.

## Скриншоты

Снимки OpenSearch Dashboards:

1. [Полученные записи](screenshots/01-discover-records.jpg).
2. [Разобранные поля события](screenshots/02-event-fields.jpg).
3. [JSON документа](screenshots/03-event-json.jpg).
4. [Дашборд логирования](screenshots/04-dashboard.jpg).
5. [Состояние индекса](screenshots/05-index-status.jpg).
6. [Типы полей](screenshots/06-index-mappings.jpg).
7. [Политика ISM: состояния и переходы](screenshots/07-ism-policy.jpg).
8. [Привязка политики к учебному индексу](screenshots/08-ism-managed-index.jpg).
