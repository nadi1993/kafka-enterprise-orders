from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Разрешаем запросы с фронтенда (Vite / React будет на 5173 порту)
origins = [
    "http://localhost:5173",
    "http://127.0.0.1:5173",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/api/analytics")
def get_analytics():
    # Здесь пока фейковые данные, просто чтобы всё работало
    return {
        "total_orders": 123,
        "total_revenue": 45230.75,
        "successful_payments": 118,
        "failed_payments": 5,
        "currency": "USD",
    }

