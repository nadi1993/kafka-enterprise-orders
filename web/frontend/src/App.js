import "./App.css";

function App() {
  const clusterName = "kafka-enterprise-orders-nadi-2025-ecs-cluster";
  const dbEndpoint =
    "kafka-enterprise-orders-nadi-2025-postgres.ct2e4guyif1w.us-west-2.rds.amazonaws.com";

  const apiUrl = process.env.REACT_APP_API_URL || "#";
  const repoUrl = "https://github.com/nadi1993/kafka-enterprise-orders";

  return (
    <div className="App">
      <div className="App__overlay" />

      <div className="AppShell">
        <header className="AppHeader">
          <div className="AppBadge">KAFKA • ECS • RDS • TERRAFORM</div>
        </header>

        <main className="AppMain">
          <section className="AppHero">
            <h1 className="AppTitle">Real-time Orders Platform</h1>
            <p className="AppSubtitle">
              Demo project: orders events are produced to Kafka, processed by microservices on ECS
              Fargate, and stored in Postgres (RDS).
            </p>

            <div className="AppHeroButtons">
              <a className="AppBtn AppBtn--primary" href={apiUrl} target="_blank" rel="noreferrer">
                Open API / Backend
              </a>
              <a className="AppBtn" href={repoUrl} target="_blank" rel="noreferrer">
                View code on GitHub
              </a>
            </div>
          </section>

          <section className="AppStats">
            <div className="AppStat">
              <div className="AppStatLabel">ECS CLUSTER</div>
              <div className="AppStatValue">{clusterName}</div>
            </div>

            <div className="AppStat">
              <div className="AppStatLabel">POSTGRES ENDPOINT</div>
              <div className="AppStatValue">{dbEndpoint}</div>
            </div>
          </section>

          <section className="AppCardsRow">
            <article className="AppCard">
              <h3>Order Producer</h3>
              <p className="AppText">
                Generates test orders and publishes them to Kafka (<code>orders</code> topic).
              </p>
              <span className="AppTag">Fargate service</span>
            </article>

            <article className="AppCard">
              <h3>Fraud Service</h3>
              <p className="AppText">
                Consumes orders from Kafka, performs fraud checks, and publishes events to{" "}
                <code>fraud-alerts</code>.
              </p>
              <span className="AppTag AppTag--orange">Fraud checks</span>
            </article>

            <article className="AppCard">
              <h3>Payment Service</h3>
              <p className="AppText">
                Processes payments, updates the order status, and publishes events to{" "}
                <code>payments</code>.
              </p>
              <span className="AppTag AppTag--purple">Payments</span>
            </article>

            <article className="AppCard">
              <h3>Analytics Service</h3>
              <p className="AppText">
                Computes order aggregates (amount, status, count) and stores them in Postgres.
              </p>
              <span className="AppTag AppTag--blue">Analytics</span>
            </article>
          </section>
        </main>

        <footer className="AppFooter">
          <span>
            Deployed with <span className="AppHeart">♥</span> using Terraform &amp; AWS (region{" "}
            <code>us-west-2</code>)
          </span>
        </footer>
      </div>
    </div>
  );
}

export default App;
