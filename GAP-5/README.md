# Домашнее задание 5

LLD и оповещения Zabbix.

## Что сделал

Установил Zabbix 7.0.31, PostgreSQL и агент через [Docker Compose](compose.yaml).

Написал [скрипт](otus_metrics.sh), который генерирует случайные целые значения от 0 до 100 для ключей `otus_important_metrics[metric1]`, `[metric2]` и `[metric3]`. Подключил его через [UserParameter агента](agent/otus.conf).

На хосте `otus-lld` настроил LLD с ключом `otus.metrics.discovery`. Из прототипов автоматически создаются три элемента данных и три триггера. Метрики опрашиваются каждые 10 секунд, обнаружение — раз в минуту.

Условие прототипа триггера, уровень Warning:

```text
last(/otus-lld/otus_important_metrics[{#METRIC}])>=95
```

Настроил Action для отправки уведомлений в **[Telegram-канал](https://t.me/otus_gap5)**. Сообщения пришли по всем трём метрикам: значения 95, 98 и 96. Построил общий график за 15 минут.

## Скриншоты

- [Обнаруженные элементы](screenshots/lld-items.png)
- [Автоматически созданные триггеры](screenshots/lld-triggers.png)
- [Action для Telegram](screenshots/telegram-action.png)
- [График метрик](screenshots/metrics-graph.png)
- [Уведомления в канале](screenshots/telegram-alerts.png)
