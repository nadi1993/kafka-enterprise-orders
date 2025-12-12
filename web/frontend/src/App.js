import "./App.css";

function App() {
  return (
    <div className="AppBg">
      <div className="App">
        <header className="AppHeader">
          <div className="AppBrand">
            <div className="AppLogo" aria-hidden="true">DA</div>
            <div className="AppBrandText">
              <div className="AppName">DevOps Portfolio Project</div>
              <div className="AppSmall">Kafka • ECS • RDS • Terraform</div>
            </div>
          </div>

          <nav className="AppNav">
            <a className="AppNavLink" href="#about">About</a>
            <a className="AppNavLink" href="#services">Services</a>
            <a className="AppNavLink" href="#infra">Infrastructure</a>
          </nav>
        </header>

        <main className="AppMain">
          <section className="AppHero" id="about">
            <div className="AppHeroLeft">
              <div className="AppPill">
                <span className="AppDot" />
                KAFKA • ECS • RDS • TERRAFORM
              </div>

              <h1 className="AppTitle">Real-time Orders Platform</h1>

              <p className="AppLead">
                Demo project: order events are produced to Kafka, processed by microservices
                on ECS Fargate, and stored in Postgres (RDS).
              </p>

              <div className="AppButtons">
                <a className="AppBtn AppBtnPrimary" href="#infra">
                  Open API / Backend
                </a>
                <a
                  className="AppBtn AppBtnGhost"
                  href="https://github.com/nadi1993/kafka-enterprise-orders"
                  target="_blank"
                  rel="noreferrer"
                >
                  View code on GitHub
                </a>
              </div>
            </div>

            <div className="AppHeroRight">
              <div className="AppCard AppInfo">
                <div className="AppInfoRow">
                  <span className="AppInfoKey">Location</span>
                  <span className="AppInfoVal">Chicago, USA</span>
                </div>
                <div className="AppInfoRow">
                  <span className="AppInfoKey">Focus</span>
                  <span className="AppInfoVal">AWS • Docker • Kubernetes • Terraform</span>
                </div>
                <div className="AppInfoRow">
                  <span className="AppInfoKey">Open to</span>
                  <span className="AppInfoVal">Internship & Junior DevOps roles</span>
                </div>
              </div>
            </div>
          </section>

          <section className="AppSection" id="infra">
            <h2 className="AppSectionTitle">AWS Infrastructure</h2>

            <p className="AppText">
              Provisioned with Terraform: VPC, subnets, Internet Gateway, Security Groups,
              ECS cluster, RDS (Postgres), WAF, Secrets Manager, and CloudWatch.
            </p>

            <div className="AppInfraRow">
              <div className="AppCard AppInfraCard">
                <div className="AppInfraLabel">ECS CLUSTER</div>
                <div className="AppInfraValue">kafka-enterprise-orders-nadi-2025-ecs-cluster</div>
              </div>

              <div className="AppCard AppInfraCard">
                <div className="AppInfraLabel">POSTGRES ENDPOINT</div>
                <div className="AppInfraValue">
                  kafka-enterprise-orders-nadi-2025-postgres.ct2e4guyif1w.us-west-2.rds.amazonaws.com
                </div>
              </div>
            </div>
          </section>

          <section className="AppSection" id="services">
            <h2 className="AppSectionTitle">Services</h2>

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
