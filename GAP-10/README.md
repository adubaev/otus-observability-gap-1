# ДЗ 10. Сбор и маршрутизация логов в Graylog

Используются журналы CMS WordPress: nginx, PHP-FPM и MariaDB.

Основной маршрут:

`Журналы контейнеров → Filebeat под управлением Graylog Sidecar → Beats input → Graylog → стримы`

Sidecar получает конфигурацию с тегом `cms` от Graylog и запускает Filebeat. Поле `service_name` определяет поток:

| Стрим | Условие |
| --- | --- |
| CMS / nginx | `service_name = nginx` |
| CMS / php-fpm | `service_name = php-fpm` |
| CMS / mariadb | `service_name = mariadb` |

Дополнительный маршрут с Data Prepper:

`Fluent Bit → Data Prepper → JSON-файл в общем томе → Fluent Bit → GELF TCP input → Graylog`

Data Prepper добавляет поле `pipeline = data-prepper`. Файловый выход используется потому, что HTTP sink не включён в официальный образ Data Prepper 2.11.0. Обработанные записи можно найти запросом `pipeline:"data-prepper"`.

## Конфигурации

- [sidecar.yml](sidecar.yml) — подключение Sidecar и тег `cms`. Вместо `${SIDECAR_API_TOKEN}` необходимо подставить собственный токен.
- [filebeat.yml](filebeat.yml) — шаблон конфигурации коллектора в Graylog; переменные `${sidecar.nodeName}` и `${sidecar.nodeId}` подставляет Sidecar.
- [fluent-bit.conf](fluent-bit.conf) — чтение журналов и доставка обработанных событий по GELF TCP на порт 12202.
- [pipelines.yaml](pipelines.yaml) — обработка в Data Prepper.
- [data-prepper-config.yaml](data-prepper-config.yaml) — параметры Data Prepper.

Graylog 6.3.6, Sidecar 1.5.6, Filebeat 8.19.22, OpenSearch 2.19.4, MongoDB 7.0.26, Data Prepper 2.11.0, Fluent Bit 4.2.2.

## Скриншоты

Для MariaDB выбран период 30 дней, чтобы показать сохранённые стартовые сообщения базы.

- [Три стрима](screenshots/01-streams.jpg)
- [Зарегистрированный Sidecar](screenshots/02-sidecar.jpg)
- [Записи nginx](screenshots/03-nginx.jpg)
- [Записи PHP-FPM](screenshots/04-php-fpm.jpg)
- [Записи MariaDB](screenshots/05-mariadb.jpg)
- [События, обработанные Data Prepper](screenshots/06-data-prepper.jpg)
- [Работающие входы Beats и GELF TCP](screenshots/07-inputs.jpg)

Проверены записи Filebeat во всех трёх потоках и отдельные события с меткой Data Prepper. Контрольные запросы к несуществующим URL возвращают ожидаемый HTTP 404.
