import React, { useEffect, useState } from "react";

function App() {
  const [orders, setOrders] = useState([]);

  useEffect(() => {
    fetch("/api/analytics")
      .then(res => res.json())
      .then(data => {
        setOrders(data.orders || []);
      });
  }, []);

  return (
    <div style={{ padding: "20px" }}>
      <h1>Kafka Enterprise Orders – Dashboard</h1>
      <h3>Last 10 orders</h3>
      <table border="1">
        <thead>
          <tr>
            <th>Order ID</th>
            <th>Amount</th>
            <th>Country</th>
          </tr>
        </thead>
        <tbody>
          {orders.map((o, idx) => (
            <tr key={idx}>
              <td>{o.order.order_id}</td>
              <td>{o.order.amount}</td>
              <td>{o.order.country}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default App;

