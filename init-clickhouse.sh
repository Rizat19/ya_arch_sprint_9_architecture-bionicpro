#!/bin/bash

# Автоматическая инициализация ClickHouse для Linux
# Этот скрипт исправляет проблемы с правами доступа к директории данных

echo "Инициализация ClickHouse..."

# Проверяем, существует ли директория
if [ -d "clickhouse-data" ]; then
    echo "Директория clickhouse-data существует. Проверяем права доступа..."
    
    # Проверяем владельца директории
    OWNER=$(stat -c '%U:%G' clickhouse-data 2>/dev/null || echo "unknown")
    echo "Текущий владелец: $OWNER"
    
    # Если владелец не clickhouse:clickhouse (101:101), исправляем
    if [ "$OWNER" != "101:101" ]; then
        echo "Исправляем права доступа..."
        sudo chown -R 101:101 clickhouse-data/
        sudo chmod -R 755 clickhouse-data/
        echo "Права доступа исправлены."
    else
        echo "Права доступа уже корректны."
    fi
else
    echo "Директория clickhouse-data не существует. Создаем..."
    mkdir clickhouse-data
    sudo chown -R 101:101 clickhouse-data/
    sudo chmod -R 755 clickhouse-data/
    echo "Директория создана с корректными правами доступа."
fi

echo "Инициализация ClickHouse завершена!"
