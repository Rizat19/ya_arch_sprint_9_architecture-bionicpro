#!/bin/bash

# Автоматическое определение операционной системы

echo "Run BionicPRO"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux"
    
    # Проверка дотсупа
    if ! docker info >/dev/null 2>&1; then
        echo "Docker не доступен. Попробуйте запустить с sudo или добавьте пользователя в группу docker:"
        echo "   sudo usermod -aG docker \$USER"
        echo "   newgrp docker"
        exit 1
    fi
    
    # init ClickHouse 
    echo "🔧 Инициализация ClickHouse для Linux..."
    ./init-clickhouse.sh
    
    # Запускаем с Linux настройками
    echo "Запуск Linux контейнеров"
    docker compose -f docker-compose.yaml -f docker-compose.linux.yaml up -d --build

elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    echo "Обнаружен Windows"
    echo "Запуск Windows контейнеров"
    docker compose up -d --build

else
    echo "Неизвестная ОС: $OSTYPE"
    echo "Запуск базовой конфигурацией"
    docker compose up -d --build
fi

echo "Ожидание запуска всех сервисов"
sleep 10

echo "Статус сервисов"
docker compose ps

echo ""
echo "Доступные сервисы:"
echo "   Frontend: http://localhost:3001"
echo "   Backend:  http://localhost:8000/healthz"
echo "   Keycloak: http://localhost:8080"
echo "   Airflow:  http://localhost:8081"
echo ""
echo "Проект запущен"
