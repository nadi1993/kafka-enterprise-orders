import json
import os
from collections import Counter

from kafka import KafkaConsumer
from couchbase.cluster import Cluster, ClusterOptions
from couchbase.auth import PasswordAuthenticator


def get_env(name: str, default: str) -> str:
    return os.environ.get(name, default)


# ----- Kafka config -----
KAFKA_BROKER = get_env("KAFKA_BROKER", "kafka:9092")
ORDERS_TOPIC = get_env("ORDERS_TOPIC", "orders")
PRINT_EVERY = int(get_env("ANALYTICS_PRINT_EVERY", "10"))

# ----- Couchbase config -----
COUCHBASE_HOST = get_env("COUCHBASE_HOST", "couchbase")
COUCHBASE_BUCKET = get_env("COUCHBASE_BUCKET", "order_analytics")
COUCHBASE_USERNAME = get_env("COUCHBASE_USERNAME", "Administrator")
COUCHBASE_PASSWORD = get_env("COUCHBASE_PASSWORD", "password")


def create_consumer() -> KafkaConsumer:
    """Создаём Kafka consumer для топика orders."""
    consumer = KafkaConsumer(
        ORDERS_TOPIC,
        bootstrap_servers=KAFKA_BROKER,
        group_id="analytics-service-group",
        value_deserializer=lambda v: json.loads(v.decode("utf-8")),
        key_deserializer=lambda k: int(k.decode("utf-8")) if k else None,
        auto_offset_reset="earliest",
        enable_auto_commit=True,
    )
    print(f"[analytics-service] Connected to Kafka at {KAFKA_BROKER}, topic='{ORDERS_TOPIC}'")
    return consumer


def create_couchbase_collection():
    """Подключаемся к Couchbase и берём default-коллекцию."""
    print(
        f"[analytics-service] Trying to connect to Couchbase at host='{COUCHBASE_HOST}', "
        f"bucket='{COUCHBASE_BUCKET}', user='{COUCHBASE_USERNAME}'"
    )
    try:
        cluster = Cluster(
            f"couchbase://{COUCHBASE_HOST}",
            ClusterOptions(
                PasswordAuthenticator(COUCHBASE_USERNAME, COUCHBASE_PASSWORD),
            ),
        )

        bucket = cluster.bucket(COUCHBASE_BUCKET)
        collection = bucket.default_collection()

        print(
            f"[analytics-service] Connected to Couchbase bucket "
            f"'{COUCHBASE_BUCKET}' at host '{COUCHBASE_HOST}'"
        )
        return collection
    except Exception as exc:
        print(f"[analytics-service] WARNING: could not connect to Couchbase: {exc}")
        return None


def main() -> None:
    consumer = create_consumer()
    collection = create_couchbase_collection()

    total_orders = 0
    total_amount = 0.0
    orders_by_country = Counter()

    for message in consumer:
        order = message.value
        key = message.key

        total_orders += 1
        amount = float(order.get("amount", 0))
        total_amount += amount

        country = order.get("country", "UNKNOWN")
        orders_by_country[country] += 1

        print(f"[analytics-service] Received order: key={key}, value={order}")

        # Сохраняем каждый заказ в Couchbase
        if collection is not None:
            doc_id = f"order::{order.get('order_id')}"
            try:
                collection.upsert(doc_id, order)
            except Exception as exc:
                print(f"[analytics-service] ERROR storing to Couchbase (id={doc_id}): {exc}")

        # Печатаем статистику каждые PRINT_EVERY заказов
        if total_orders % PRINT_EVERY == 0:
            avg_amount = total_amount / total_orders if total_orders else 0.0
            print("\n[analytics-service] ===== STATS =====")
            print(f"Total orders: {total_orders}")
            print(f"Total amount: {total_amount:.2f}")
            print(f"Average amount: {avg_amount:.2f}")
            print("Orders by country:")
            for c, count in orders_by_country.items():
                print(f"  {c}: {count}")
            print("[analytics-service] ====================\n")


if __name__ == "__main__":
    main()
