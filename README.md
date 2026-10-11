# Домашние задания OTUS

## Домашнее задание 1

На своей VM с Ubuntu 22.04 я установил WordPress. Он работает через nginx и PHP-FPM, данные хранит в MariaDB. Всё запущено в Docker Compose.

Для мониторинга поставил Prometheus и экспортеры:

- node exporter — метрики VM;
- nginx exporter — метрики веб-сервера;
- PHP-FPM exporter — состояние PHP-FPM;
- mysqld exporter — метрики базы данных;
- blackbox exporter — проверка сайта по HTTP.

Prometheus опрашивает их каждые 5 секунд. Порты экспортеров и базы данных наружу не открывал. Интерфейс Prometheus доступен только на самой VM; подключаюсь к нему через SSH-туннель.

### Проверка

После установки WordPress главная страница отвечала HTTP 200. В Prometheus все 7 целей имели `up = 1`. Проверка сайта `probe_success`, а также `mysql_up`, `nginx_up` и `phpfpm_up` показывали `1`.

Конфигурацию Prometheus проверил через `promtool check config`, конфигурацию Alertmanager — через `amtool check-config`. Обе проверки прошли успешно.

### Файлы для сдачи

- [Конфигурация Prometheus](GAP-1/prometheus.yml)
- [Конфигурация Alertmanager](GAP-1/alertmanager.yml)

На этапе ДЗ 1 в рабочей конфигурации Prometheus использовал ещё локальный `rules.yml` с двумя правилами доступности. Канал уведомлений Alertmanager, SSL и авторизацию тогда ещё не настраивал.

## Домашнее задание 4

[Описание работы с Grafana](GAP-4/README.md).
