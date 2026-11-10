#!/bin/bash

LOG_FILE="access.log"

echo "Заполнение log-файла $LOG_FILE..."

IPS=(
    "192.168.1.10"
    "10.0.0.5"
    "172.16.0.2"
    "192.168.1.20"
    "10.0.0.15"
)

METHODS=("GET" "POST" "PUT" "DELETE")
URLS=("/api/users" "/api/login" "/api/products" "/api/orders")
CODES=(200 200 200 201 400 401 403 404 500 502)

> "$LOG_FILE"

for i in $(seq 1 300); do
    IP=${IPS[$((i % 5))]}
    METHOD=${METHODS[$((i % 4))]}
    ENDPOINT=${URLS[$((i % 4))]}
    CODE=${CODES[$((i % 10))]}

    printf '%s - - [15/Aug/2026:10:%02d:%02d] "%s %s HTTP/1.1" %s\n' \
        "$IP" "$((i / 60))" "$((i % 60))" \
        "$METHOD" "$ENDPOINT" "$CODE" >> "$LOG_FILE"
done

echo "Создано строк: $(wc -l < "$LOG_FILE")"
echo

IP_REGEX='([0-9]{1,3}\.){3}[0-9]{1,3}'

TOTAL=$(grep -Ec "$IP_REGEX" "$LOG_FILE")

echo "========== АНАЛИЗ ЛОГОВ =========="
echo "Общее количество запросов: $TOTAL"
echo

echo "Топ-3 IP-адреса:"

grep -Eo "$IP_REGEX" "$LOG_FILE" |
    sort |
    uniq -c |
    sort -rn |
    head -3

echo

ERROR_4XX=$(awk '$8 ~ /^4[0-9][0-9]$/ {count++} END {print count+0}' "$LOG_FILE")

ERROR_5XX=$(awk '$8 ~ /^5[0-9][0-9]$/ {count++} END {print count+0}' "$LOG_FILE")

echo "Количество ошибок 4xx: $ERROR_4XX"
echo "Количество ошибок 5xx: $ERROR_5XX"

echo "================================="
