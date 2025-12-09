# Real-Time Orders Platform

Учебный проект по статье  
"Project idea – Real-Time Orders Platform".

## Что делает система

- Генерирует заказы (order-producer)
- Обрабатывает платежи (payment-service)
- Проверяет на мошенничество (fraud-service)
- Считает аналитику (analytics-service)
- Хранит историю в Postgres
- Хранит real-time аналитику в Couchbase
- Использует Kafka как шину событий

## Технологии

- Apache Kafka, Kafka Connect, ksqlDB
- Postgres
- Couchbase
- Docker, Docker Compose
- Python (микросервисы)

## Как запустить локально

```bash
git clone https://github.com/YOUR_USER/kafka-enterprise-orders.git
cd kafka-enterprise-orders
docker-compose up -d --build
