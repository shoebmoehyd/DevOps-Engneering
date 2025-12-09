import { useState, useEffect } from 'react';
import './App.css';

function App() {
  // State for storing cluster data
  const [clusterData, setClusterData] = useState(null);
  const [pods, setPods] = useState([]);
  const [nodes, setNodes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [lastUpdate, setLastUpdate] = useState(new Date());

  // Backend API URL - use localhost:3000 when using port-forward
  const API_URL = 'http://localhost:3000/api';

  // Fetch all data from backend
  const fetchData = async () => {
    try {
      setLoading(true);
      setError(null);

      // Fetch cluster summary, pods, and nodes in parallel
      const [clusterRes, podsRes, nodesRes] = await Promise.all([
        fetch(`${API_URL}/cluster`),
        fetch(`${API_URL}/pods`),
        fetch(`${API_URL}/nodes`)
      ]);

      // Check if all requests were successful
      if (!clusterRes.ok || !podsRes.ok || !nodesRes.ok) {
        throw new Error('Failed to fetch data from backend');
      }

      const clusterData = await clusterRes.json();
      const podsData = await podsRes.json();
      const nodesData = await nodesRes.json();

      setClusterData(clusterData);
      setPods(podsData);
      setNodes(nodesData);
      setLastUpdate(new Date());
      setLoading(false);
    } catch (err) {
      console.error('Error fetching data:', err);
      setError(err.message);
      setLoading(false);
    }
  };

  // Fetch data on component mount
  useEffect(() => {
    fetchData();
    
    // Auto-refresh every 10 seconds
    const interval = setInterval(fetchData, 10000);
    
    // Cleanup on unmount
    return () => clearInterval(interval);
  }, []);

  // Helper function to get status color
  const getStatusColor = (status) => {
    const statusLower = status.toLowerCase();
    if (statusLower === 'running' || statusLower === 'ready') return 'status-running';
    if (statusLower === 'pending') return 'status-pending';
    if (statusLower === 'failed') return 'status-failed';
    return 'status-unknown';
  };

  // Loading state
  if (loading && !clusterData) {
    return (
      <div className="app">
        <div className="loading">
          <div className="spinner"></div>
          <p>Loading cluster data...</p>
        </div>
      </div>
    );
  }

  // Error state
  if (error) {
    return (
      <div className="app">
        <div className="error">
          <h2>❌ Error</h2>
          <p>{error}</p>
          <p className="hint">💡 Make sure your backend server is running on port 3000!</p>
          <button onClick={fetchData} className="retry-btn">🔄 Retry</button>
        </div>
      </div>
    );
  }

  return (
    <div className="app">
      {/* Header */}
      <header className="header">
        <h1>🎯 K8s Health Dashboard</h1>
        <div className="header-info">
          <span className="cluster-name">📍 {clusterData?.cluster?.name}</span>
          <span className="last-update">
            🕐 Last update: {lastUpdate.toLocaleTimeString()}
          </span>
          <button onClick={fetchData} className="refresh-btn" disabled={loading}>
            {loading ? '⏳' : '🔄'} Refresh
          </button>
        </div>
      </header>

      {/* Cluster Summary Cards */}
      <div className="summary-cards">
        <div className="card">
          <div className="card-icon">🖥️</div>
          <div className="card-content">
            <h3>Nodes</h3>
            <div className="card-value">
              {clusterData?.cluster?.readyNodes} / {clusterData?.cluster?.totalNodes}
            </div>
            <div className="card-label">Ready</div>
          </div>
        </div>

        <div className="card">
          <div className="card-icon">📦</div>
          <div className="card-content">
            <h3>Pods</h3>
            <div className="card-value">{clusterData?.pods?.total}</div>
            <div className="card-stats">
              <span className="stat-running">▶ {clusterData?.pods?.running}</span>
              <span className="stat-pending">⏸ {clusterData?.pods?.pending}</span>
              <span className="stat-failed">✖ {clusterData?.pods?.failed}</span>
            </div>
          </div>
        </div>

        <div className="card">
          <div className="card-icon">🚀</div>
          <div className="card-content">
            <h3>Deployments</h3>
            <div className="card-value">
              {clusterData?.deployments?.ready} / {clusterData?.deployments?.total}
            </div>
            <div className="card-label">Ready</div>
          </div>
        </div>
      </div>

      {/* Pods Table */}
      <div className="section">
        <h2>📦 Pods ({pods.length})</h2>
        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                <th>Name</th>
                <th>Namespace</th>
                <th>Status</th>
                <th>Ready</th>
                <th>Restarts</th>
                <th>Age</th>
                <th>Node</th>
              </tr>
            </thead>
            <tbody>
              {pods.slice(0, 20).map((pod, index) => (
                <tr key={index}>
                  <td className="pod-name">{pod.name}</td>
                  <td>
                    <span className="namespace-badge">{pod.namespace}</span>
                  </td>
                  <td>
                    <span className={`status-badge ${getStatusColor(pod.status)}`}>
                      {pod.status}
                    </span>
                  </td>
                  <td className="text-center">
                    {pod.ready ? '✅' : '❌'}
                  </td>
                  <td className="text-center">{pod.restarts}</td>
                  <td>{pod.age}</td>
                  <td className="node-name">{pod.node}</td>
                </tr>
              ))}
            </tbody>
          </table>
          {pods.length > 20 && (
            <div className="table-footer">
              Showing 20 of {pods.length} pods
            </div>
          )}
        </div>
      </div>

      {/* Nodes Table */}
      <div className="section">
        <h2>🖥️ Nodes ({nodes.length})</h2>
        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                <th>Name</th>
                <th>Status</th>
                <th>Role</th>
                <th>Version</th>
                <th>OS</th>
                <th>Age</th>
              </tr>
            </thead>
            <tbody>
              {nodes.map((node, index) => (
                <tr key={index}>
                  <td className="node-name">{node.name}</td>
                  <td>
                    <span className={`status-badge ${getStatusColor(node.status)}`}>
                      {node.status}
                    </span>
                  </td>
                  <td>
                    <span className="role-badge">{node.roles}</span>
                  </td>
                  <td>{node.version}</td>
                  <td className="os-info">{node.os}</td>
                  <td>{node.age}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Footer */}
      <footer className="footer">
        <p>Built with ❤️ using React + Node.js + Kubernetes API</p>
      </footer>
    </div>
  );
}

export default App;
