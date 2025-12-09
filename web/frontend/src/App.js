import React, { useEffect, useState } from "react";
import axios from "axios";
import "./App.css";

function App() {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const [summary, setSummary] = useState({
    total_orders: 0,
    total_amount: 0,
    average_amount: 0,
  });

  useEffect(() => {
    const fetchAnalytics = async () => {
      try {
        setLoading(true);
        setError(null);

        // благодаря "proxy" в package.json это уйдет на http://127.0.0.1:8000/api/analytics
        const resp = await axios.get("/api/analytics");

        setOrders(resp.data.orders || []);
        setSummary({
          total_orders: resp.data.total_orders || 0,
          total_amount: resp.data.total_amount || 0,
          average_amount: resp.data.average_amount || 0,
        });
      } catch (err) {
        console.error(err);
        setError("Failed to load analytics data");
      } finally {
        setLoading(false);
      }
    };

    fetchAnalytics();
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <h1>Real-Time Orders Dashboard</h1>
        <p className="subtitle">Kafka → Consumers → Analytics → FastAPI → React</p>
      </header>

      <main className="App-content">
        {loading && <p className="info-text">Loading analytics...</p>}
        {error && <p className="error-text">{error}</p>}

        {!loading && !error && (
          <>
            {/* Блок с цифрами */}
            <section className="summary-cards">
              <div className="card">
                <h3>Total Orders</h3>
                <p className="card-number">{summary.total_orders}</p>
              </div>
              <div className="card">
                <h3>Total Amount ($)</h3>
                <p className="card-number">
                  {summary.total_amount.toFixed
                    ? summary.total_amount.toFixed(2)
                    : summary.total_amount}
                </p>
              </div>
              <div className="card">
                <h3>Average Order ($)</h3>
                <p className="card-number">
                  {summary.average_amount.toFixed
                    ? summary.average_amount.toFixed(2)
                    : summary.average_amount}
                </p>
              </div>
            </section>

            {/* Таблица заказов */}
            <section className="table-section">
              <h2>Recent Orders</h2>
              {orders.length === 0 ? (
                <p className="info-text">No orders yet.</p>
              ) : (
                <div className="table-wrapper">
                  <table>
                    <thead>
                      <tr>
                        <th>Order ID</th>
                        <th>User</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Created At</th>
                      </tr>
                    </thead>
                    <tbody>
                      {orders.map((order) => (
                        <tr key={order.order_id}>
                          <td>{order.order_id}</td>
                          <td>{order.user_id}</td>
                          <td>${order.amount}</td>
                          <td>
                            <span className={`status-badge status-${order.status}`}>
                              {order.status}
                            </span>
                          </td>
                          <td>{order.created_at}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </section>
          </>
        )}
      </main>
    </div>
  );
}

export default App;

