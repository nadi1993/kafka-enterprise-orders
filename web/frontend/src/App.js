import React from "react";
import "./App.css";

function App() {
  // сюда можешь потом подставить свой API URL, если нужно
  const apiUrl =
    process.env.REACT_APP_API_URL ||
    "https://kafka-enterprise-orders-nadi-2025.example.com/api"; // просто пример

  const clusterName =
    process.env.REACT_APP_ECS_CLUSTER ||
    "kafka-enterprise-orders-nadi-2025-ecs-cluster";

  const dbEndpoint =
    process.env.REACT_APP_DB_ENDPOINT ||
    "kafka-enterprise-orders-nadi-2025-postgres.ct2e4guyif1w.us-west-2.rds.amazonaws.com";

  return (
    <div className="App">
      <div className="App__overlay">
        <header className="AppHeader">
          <span className="AppBadge">Kafka • ECS • RDS • Terraform</span>
          <h1 className="AppTitle">Real-time Orders Platform</h1>
          <p className="AppSubtitle">
            Демонстрационный проект: события заказов идут в Kafka, обрабатываются
            микросервисами на ECS Fargate и сохраняются в Postgres (RDS).
          </p>

          <div className="AppHeaderButtons">
            <a
              className="AppButton AppButton--primary"
              href={apiUrl}
              target="_blank"
              rel="noreferrer"
            >
              Открыть API / Backend
            </a>
            <a
              className="AppButton AppButton--ghost"
              href="https://github.com/nadi1993/kafka-enterprise-orders"
              target="_blank"
              rel="noreferrer"
            >
              Посмотреть код на GitHub
            </a>
          </div>
        </header>

        <main className="AppMain">
          <section className="AppCard AppCard--wide">
            <h2>Инфраструктура в AWS</h2>
            <p className="AppText">
              Весь этот стенд развёрнут с помощью Terraform: VPC, субсети,
              Internet Gateway, Security Groups, ECS кластер, RDS, WAF, Secrets
              Manager, CloudWatch.
            </p>

            <div className="AppGrid AppGrid--2">
              <div className="AppKV">
                <span className="AppKVLabel">ECS Cluster</span>
                <span className="AppKVValue">{clusterName}</span>
              </div>
              <div className="AppKV">
                <span className="AppKVLabel">Postgres endpoint</span>
                <span className="AppKVValue AppKVValue--mono">
                  {dbEndpoint}
                </span>
              </div>
            </div>
          </section>

          <section className="AppCardsRow">
            <article className="AppCard">
              <h3>Order Producer</h3>
              <p className="AppText">
                Генерирует тестовые заказы и публикует их в Kafka&nbsp;(
                <code>orders</code> topic).
              </p>
              <span className="AppTag">Fargate service</span>
            </article>

            <article className="AppCard">
              <h3>Fraud Service</h3>
              <p className="AppText">
                Читает заказы из Kafka, проверяет на мошенничество и пишет события
                в&nbsp;<code>fraud-alerts</code>.
              </p>
              <span className="AppTag AppTag--orange">Fraud checks</span>
            </article>

            <article className="AppCard">
              <h3>Payment Service</h3>
              <p className="AppText">
                Обрабатывает платежи, обновляет статус заказа и пишет в&nbsp;
                <code>payments</code>.
              </p>
              <span className="AppTag AppTag--purple">Payments</span>
            </article>

            <article className="AppCard">
              <h3>Analytics Service</h3>
              <p className="AppText">
                Считает агрегаты по заказам (сумма, статус, количество) и
                сохраняет в Postgres.
              </p>
              <span className="AppTag AppTag--blue">Analytics</span>
            </article>
          </section>
        </main>

        <footer className="AppFooter">
          <span>
            Deployed with <span className="AppHeart">♥</span> using Terraform &amp; AWS
            (region <code>us-west-2</code>)
          </span>
        </footer>
      </div>
    </div>
  );
}

export default App;

