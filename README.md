# BionicPRO
---

Коротко: компания производит бионические протезы и собирает телеметрию для улучшения ML-модели.  
Цель проекта: безопасность через PKCE и выдача отчетов из OLAP по запросу пользователя с доступом только к своим данным.

## Технологии
* OAuth 2.0
* Docker и Docker Compose
* React + TypeScript + TailwindCSS
* Keycloak PKCE S256
* FastAPI Python 3.11
* ClickHouse OLAP
* Apache Airflow DAG для ETL
* Draw.io для C4

## Ветки
* `main` — целевая
* `sprint_9` — для работы

## Документация
* Диаграмма C4: [docs/Task 1/BionicPRO_C4_model.drawio_Task_1.xml](docs/Task 1/BionicPRO_C4_model.drawio_Task_1.xml)

## Что внутри
---
* PKCE во фронтенде и настройка клиента в Keycloak
* Сервис отчетов на FastAPI (`/reports`) с проверкой JWT по JWKS Keycloak
* OLAP ClickHouse с простой витриной `user_reports`
* ETL в Airflow: объединение источников и запись маркеров загрузки `load_markers`
* UI с выбором периода и скачиванием отчета `report.txt`

## Структура проекта
---
```
.
├─ backend
│  ├─ app
│  │  └─ main.py
│  └─ requirements.txt
├─ frontend
│  └─ src
│     ├─ App.tsx
│     └─ components
│        └─ ReportPage.tsx
├─ keycloak
│  └─ realm-export.json
├─ airflow
│  ├─ Dockerfile
│  └─ dags
│     └─ reports_etl_dag.py
├─ docs
│  ├─ Task1
│  │   └─ BionicPRO_C4_model.drawio_Task_1.xml
│  └─ Task2
│      └─ BionicPRO_C4_model.drawio.xml
├─ docker-compose.yaml
├─ docker-compose.linux.yaml
├─ start.sh
├─ stop.sh
└─ init-clickhouse.sh
```

## Быстрый старт
---

### Подготовка Windows
* Установи Docker Desktop
* Установи Python 3.11 и pip

### Подготовка Linux
* Установи Docker и Docker Compose
* Установи Python 3.11 и pip

### Запуск всего стенда
```bash
./start.sh
```

### Остановка проекта
```bash
./stop.sh
# или
docker compose down
```

![img.png](img.png)

### Проверка сервисов
```
Frontend   http://localhost:3001
Backend    http://localhost:8000/healthz
Keycloak   http://localhost:8080
Airflow    http://localhost:8081
```

### Логин в приложение
* Нажми **Login** во фронтенде
* Войди под пользователем `user1` с паролем `password123`

### Получение отчета
* Выбери период в пределах обработанного окна Airflow
* Нажми **Download Report**
* Скачается файл `report.txt`
* Если период вне обработанного окна, придет ответ `400` с подсказкой по допустимому окну

### Как запустить ETL в Airflow
* Открой Airflow по адресу из раздела выше
* Найди DAG `reports_etl_dag`
* Запусти вручную либо дождись планового запуска

## Безопасность
---
* PKCE S256 во фронтенде и клиент Keycloak
* JWT проверяется по подписи и issuer, сервер берет JWKS из Keycloak
* Доступ к отчету только по своему `subject` из токена

### Переменные окружения
* Все значения заданы в `docker-compose.yaml`
* При необходимости можно создать файл `.env.example` и задокументировать собственные параметры

## Диаграммы
---
* [docs/Task 2/BionicPRO_C4_model.drawio.xml](docs/Task 2/BionicPRO_C4_model.drawio.xml)
