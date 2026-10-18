# TICK: ресурсы для домашнего задания

## Статья

[InfluxDB 3: System Architecture — InfluxData](https://www.influxdata.com/blog/influxdb-3-0-system-architecture/).

Описывает архитектуру InfluxDB 3: приём и обработку записей, каталог метаданных, хранение Parquet в object storage и выполнение запросов. Это материал для понимания третьего поколения InfluxDB, а не готовая инструкция установки классического TICK.

## Файлы курса

Все пять PDF и каталог `docker_compose-580477-07d578` скопированы из Downloads в [resources/TICK](../resources/TICK/README.md). Содержимое исходников сохранено.

В каталоге примера находятся конфигурации IoT-стенда, Node-RED, Mosquitto, InfluxDB, Telegraf и Chronograf, а также сохранённые данные. В Compose нет Kapacitor, Telegraf настроен на MQTT. Для мониторинга CMS этот пример нужно адаптировать.

PDF и каталог исходного стенда исключены локальным `.gitignore`: сохранённые базы и настройки остаются учебными материалами на компьютере.

## Документация для реализации

- [Классический TICK: сбор, хранение, визуализация и алертинг](https://docs.influxdata.com/platform/getting-started/).
- [Установка InfluxDB OSS 1.x в Docker](https://docs.influxdata.com/influxdb/v1/introduction/install/docker/).
- [Подключения Chronograf к InfluxDB и Kapacitor](https://docs.influxdata.com/chronograf/v1/administration/creating-connections/).
- [Chronograf с InfluxDB 3 Core](https://docs.influxdata.com/influxdb3/core/visualize-data/chronograf/).
- [Установка и настройка Kapacitor](https://docs.influxdata.com/kapacitor/v1/introduction/installation/).
- [Telegraf: nginx](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/nginx).
- [Telegraf: PHP-FPM](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/phpfpm).
- [Telegraf: MySQL/MariaDB](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/mysql).
- [Telegraf: HTTP-проверки](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/http_response).
- [Telegraf: чтение логов](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/tail).
- [Telegraf: WireGuard](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/wireguard).
- [Официальный AmneziaWG userspace](https://github.com/amnezia-vpn/amneziawg-go).
- [Официальные инструменты AmneziaWG](https://github.com/amnezia-vpn/amneziawg-tools).

## Выбор для TICK-1

Для этого ДЗ установлены InfluxDB OSS 1.13.1, Telegraf 1.40.2, Chronograf 1.11.5 и Kapacitor 1.8.7. Сохранена стандартная схема подписок InfluxDB → Kapacitor. Теги проверены перед установкой и зафиксированы в Compose; `influxdb:latest` не используется.

Chronograf уже поддерживает InfluxDB 3 с отдельной настройкой. Поэтому утверждать, что Chronograf вообще несовместим с InfluxDB 3, неверно. Выбор 1.x здесь относится к общей схеме TICK и алертингу Kapacitor.

Проверено по документации 18 октября 2026 года.
