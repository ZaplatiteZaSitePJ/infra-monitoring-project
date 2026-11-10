#!/bin/bash

if [ -z "$1" ]; then
	echo "Необходимо ОБЯЗАТЕЛЬНО указать url"
	exit 1
fi

URL="$1"

HTTP_CODE=$(curl -o /dev/null -w "%{http_code}" --connect-timeout 10 "$URL")

if [ "$HTTP_CODE" = "200" ]; then
	echo "API доступен"
	exit 0
else
	echo "API недоступен, код ответа: $HTTP_CODE"
	exit 1
fi
