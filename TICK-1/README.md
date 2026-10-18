# ДЗ 6: Установка и настройка TICK стека

На VM с WordPress, nginx, PHP-FPM и MariaDB установлен TICK: Telegraf 1.40.2, InfluxDB 1.13.1, Chronograf 1.11.5 и Kapacitor 1.8.7. Компоненты работают в Docker Compose.

## Что выполнено

- Telegraf собирает метрики VM, nginx, PHP-FPM, базы данных и HTTP-доступности CMS каждые 10 секунд. JSON access log используется для подсчёта ответов 500–599.
- Метрики отправляются в InfluxDB; срок хранения — 14 дней.
- В Chronograf создан сводный дашборд из девяти панелей: CPU, RAM, диск, HTTP-код, запросы nginx, процессы и очередь PHP-FPM, соединения БД, время ответа и HTTP 5xx.
- Восемь правил Kapacitor контролируют CPU/RAM >90% и диск >85% в течение 5 минут, отсутствие метрик компонентов, доступность WordPress и HTTP 5xx. Сообщения о проблеме и восстановлении отправляются в Telegram.

## Конфигурации

| Компонент | Файлы |
|---|---|
| Telegraf | [VM](telegraf.conf), [CMS](telegraf-cms.conf) |
| InfluxDB | [Настройки](influxdb.conf), [инициализация БД и срока хранения](initdb/01-retention.iql) |
| Chronograf | [Сервис chronograf и его environment](compose.yaml) |
| Kapacitor | [Настройки](kapacitor.conf), [восемь правил](tick/) |
| nginx CMS | [Конфигурация](nginx/nginx.conf), [дополнение Compose](cms.override.yaml) |

## Запуск настроенного стенда

CMS расположена в `/opt/otus/GAP-1`, TICK — в `/opt/otus/TICK-1`; используется существующая сеть `gap-1_default`. Пользователь БД `tick_metrics`, сертификат HTTPS и файл пароля `secrets/chronograf.htpasswd` подготовлены при настройке. Пароли и токен берутся из локального `.env`, исключённого из Git.

```bash
cd /opt/otus/TICK-1
install -d -m 755 logs/nginx
docker compose config --quiet
docker compose up -d
docker compose ps
```

После готовности Kapacitor загрузить правила:

```bash
for file in tick/*.tick; do
    name="tick-$(basename "$file" .tick)"
    docker compose exec -T kapacitor kapacitor define "$name" \
        -type stream -dbrp telegraf.autogen -tick "/etc/kapacitor/$file" || break
    docker compose exec -T kapacitor kapacitor enable "$name" || break
done
```

Для управления CMS с подключёнными настройками nginx используется объединение Compose-файлов, например проверка состояния:

```bash
cd /opt/otus/GAP-1
docker compose --project-name gap-1 --project-directory /opt/otus/GAP-1 \
    -f /opt/otus/GAP-1/compose.yaml -f /opt/otus/TICK-1/cms.override.yaml ps
```

## Результат проверки

Контрольная задача CPU подтвердила доставку CRITICAL / OK. Остановка WordPress вызвала HTTP 502 и алерты WordPress, PHP-FPM и HTTP 5xx. После запуска сайта пришли уведомления о восстановлении, HTTP вернулся к 200. Ошибок в трёх проверенных правилах нет; все восемь основных задач выполняются.

[Chronograf — HTTPS и вход с паролем](https://tick.adubaev.ru) · [Канал уведомлений](https://t.me/otus_gap5).
