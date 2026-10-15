#!/bin/sh
# Генератор учебных метрик для ДЗ 5 по Zabbix.
set -eu

random_value() {
    # Читаем случайное число из /dev/urandom и получаем значение 0–100.
    number=$(od -An -N4 -tu4 /dev/urandom)
    printf '%s\n' "$((number % 101))"
}

case "${1:-all}" in
    discovery)
        # LLD получает список имён и подставляет их в прототипы.
        printf '%s\n' '[{"{#METRIC}":"metric1"},{"{#METRIC}":"metric2"},{"{#METRIC}":"metric3"}]'
        ;;
    metric1|metric2|metric3)
        # При опросе одного элемента данных агенту нужно только число.
        random_value
        ;;
    all)
        # Без аргументов показываем все ключи и их значения для проверки.
        for metric in metric1 metric2 metric3; do
            printf 'otus_important_metrics[%s] %s\n' "$metric" "$(random_value)"
        done
        ;;
    *)
        printf 'Использование: %s [all|discovery|metric1|metric2|metric3]\n' "$0" >&2
        exit 2
        ;;
esac
