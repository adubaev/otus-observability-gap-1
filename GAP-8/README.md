# ДЗ 8. Преобразование логов с помощью Logstash и Vector

Проверены два варианта доставки логов nginx:

1. Filebeat → Logstash (grok) → Elasticsearch → Kibana.
2. Filebeat → Vector (VRL) → Elasticsearch → Kibana.

Filebeat извлекает сообщение из Docker-конверта без разбора HTTP-полей. Logstash и Vector выделяют `method`, `path`, `status`, `bytes`, адрес клиента и время. `status` и `bytes` — числа, `parse_success` — логический признак успешного разбора. Нераспознанные строки сохраняются с тегом `parse_failed`.

Конфигурации: [Filebeat](filebeat.yml), [Logstash](logstash.conf), [Vector](vector.yaml). Для Elasticsearch используется переменная `ELASTIC_PASSWORD`; пароль в репозиторий не включён. Временный стенд использует Filebeat 8.19.22 с input `container`; `tail_files: true` предназначен для сбора новых записей при первом запуске.

Для каждого варианта отправлены три HTTP-запроса с уникальными URL. В Elasticsearch проверены полученные поля и их типы. Ответы 404 ожидаемы: запросы направлены на несуществующие страницы, чтобы получить различимые записи nginx.

DLQ и ILM из задания со звёздочкой не выполнялись.


## Скриншоты

Полноэкранные снимки Kibana, :

1. [Logstash — полученные записи](screenshots/01-logstash-records.jpg).
2. [Logstash — разобранные поля события](screenshots/02-logstash-event.jpg).
3. [Logstash — типы и статистика полей](screenshots/03-logstash-fields.jpg).
4. [Vector — полученные записи](screenshots/04-vector-records.jpg).
5. [Vector — разобранные поля события](screenshots/05-vector-event.jpg).
6. [Vector — типы и статистика полей](screenshots/06-vector-fields.jpg).
