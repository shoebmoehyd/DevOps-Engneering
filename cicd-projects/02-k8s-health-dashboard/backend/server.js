// ========================================
// K8s Health Dashboard - Backend Server
// ========================================
// This server connects to your Kubernetes cluster
// and provides API endpoints to fetch cluster data

import express from 'express';
import cors from 'cors';
import * as k8s from '@kubernetes/client-node';

const app = express();
const PORT = 3000;

// Enable CORS so frontend can connect
app.use(cors());
app.use(express.json());

// ========================================
// Kubernetes Configuration
// ========================================
// This loads your kubeconfig file (same one kubectl uses)
const kc = new k8s.KubeConfig();

try {
    // Load kubeconfig from default location (~/.kube/config)
    kc.loadFromDefault();
    console.log('✅ Kubeconfig loaded successfully!');
    console.log('📍 Current context:', kc.getCurrentContext());
} catch (error) {
    console.error('❌ Failed to load kubeconfig:', error.message);
    console.log('💡 Make sure you have Minikube running: minikube start');
}

// Create API clients
const k8sApi = kc.makeApiClient(k8s.CoreV1Api);
const appsApi = kc.makeApiClient(k8s.AppsV1Api);

// ========================================
// API Endpoints
// ========================================

// Health check endpoint
app.get('/api/health', (req, res) => {
    res.json({ 
        status: 'ok', 
        message: 'K8s Health Dashboard API is running!',
        timestamp: new Date().toISOString()
    });
});

// Get all pods from all namespaces
app.get('/api/pods', async (req, res) => {
    try {
        console.log('📦 Fetching pods...');
        const response = await k8sApi.listPodForAllNamespaces();
        
        // Check if response has the expected structure
        const items = response?.body?.items || response?.items || [];
        
        // Simplify the pod data
        const pods = items.map(pod => ({
            name: pod.metadata?.name || 'unknown',
            namespace: pod.metadata?.namespace || 'default',
            status: pod.status?.phase || 'Unknown',
            ready: pod.status?.containerStatuses 
                ? pod.status.containerStatuses.every(c => c.ready)
                : false,
            restarts: pod.status?.containerStatuses 
                ? pod.status.containerStatuses.reduce((sum, c) => sum + c.restartCount, 0)
                : 0,
            age: calculateAge(pod.metadata?.creationTimestamp),
            node: pod.spec?.nodeName || 'N/A'
        }));

        console.log(`✅ Found ${pods.length} pods`);
        res.json(pods);
    } catch (error) {
        console.error('❌ Error fetching pods:', error.message);
        res.status(500).json({ 
            error: 'Failed to fetch pods',
            message: error.message,
            details: error.stack
        });
    }
});

// Get all nodes
app.get('/api/nodes', async (req, res) => {
    try {
        console.log('🖥️  Fetching nodes...');
        const response = await k8sApi.listNode();
        
        // Check if response has the expected structure
        const items = response?.body?.items || response?.items || [];
        
        // Simplify the node data
        const nodes = items.map(node => ({
            name: node.metadata?.name || 'unknown',
            status: node.status?.conditions?.find(c => c.type === 'Ready')?.status === 'True' 
                ? 'Ready' 
                : 'NotReady',
            roles: node.metadata?.labels?.['node-role.kubernetes.io/control-plane'] 
                ? 'control-plane' 
                : 'worker',
            version: node.status?.nodeInfo?.kubeletVersion || 'N/A',
            os: node.status?.nodeInfo?.osImage || 'N/A',
            age: calculateAge(node.metadata?.creationTimestamp)
        }));

        console.log(`✅ Found ${nodes.length} nodes`);
        res.json(nodes);
    } catch (error) {
        console.error('❌ Error fetching nodes:', error.message);
        res.status(500).json({ 
            error: 'Failed to fetch nodes',
            message: error.message,
            details: error.stack
        });
    }
});

// Get all deployments
app.get('/api/deployments', async (req, res) => {
    try {
        console.log('🚀 Fetching deployments...');
        const response = await appsApi.listDeploymentForAllNamespaces();
        
        // Simplify the deployment data
        const deployments = response.body.items.map(dep => ({
            name: dep.metadata.name,
            namespace: dep.metadata.namespace,
            replicas: dep.spec.replicas,
            available: dep.status.availableReplicas || 0,
            ready: dep.status.readyReplicas || 0,
            upToDate: dep.status.updatedReplicas || 0,
            age: calculateAge(dep.metadata.creationTimestamp)
        }));

        console.log(`✅ Found ${deployments.length} deployments`);
        res.json(deployments);
    } catch (error) {
        console.error('❌ Error fetching deployments:', error.message);
        res.status(500).json({ 
            error: 'Failed to fetch deployments',
            message: error.message 
        });
    }
});

// Get cluster summary
app.get('/api/cluster', async (req, res) => {
    try {
        console.log('📊 Fetching cluster summary...');
        
        const [podsResponse, nodesResponse, deploymentsResponse] = await Promise.all([
            k8sApi.listPodForAllNamespaces(),
            k8sApi.listNode(),
            appsApi.listDeploymentForAllNamespaces()
        ]);

        const pods = podsResponse?.body?.items || podsResponse?.items || [];
        const nodes = nodesResponse?.body?.items || nodesResponse?.items || [];
        const deployments = deploymentsResponse?.body?.items || deploymentsResponse?.items || [];

        const summary = {
            cluster: {
                name: kc.getCurrentContext(),
                totalNodes: nodes.length,
                readyNodes: nodes.filter(n => 
                    n.status?.conditions?.find(c => c.type === 'Ready')?.status === 'True'
                ).length
            },
            pods: {
                total: pods.length,
                running: pods.filter(p => p.status?.phase === 'Running').length,
                pending: pods.filter(p => p.status?.phase === 'Pending').length,
                failed: pods.filter(p => p.status?.phase === 'Failed').length,
                succeeded: pods.filter(p => p.status?.phase === 'Succeeded').length
            },
            deployments: {
                total: deployments.length,
                ready: deployments.filter(d => 
                    d.status?.readyReplicas === d.spec?.replicas
                ).length
            }
        };

        console.log('✅ Cluster summary generated');
        res.json(summary);
    } catch (error) {
        console.error('❌ Error fetching cluster summary:', error.message);
        res.status(500).json({ 
            error: 'Failed to fetch cluster summary',
            message: error.message,
            details: error.stack
        });
    }
});

// ========================================
// Helper Functions
// ========================================

// Calculate age from creation timestamp
function calculateAge(creationTimestamp) {
    const created = new Date(creationTimestamp);
    const now = new Date();
    const diffMs = now - created;
    
    const days = Math.floor(diffMs / (1000 * 60 * 60 * 24));
    const hours = Math.floor((diffMs % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((diffMs % (1000 * 60 * 60)) / (1000 * 60));
    
    if (days > 0) return `${days}d`;
    if (hours > 0) return `${hours}h`;
    return `${minutes}m`;
}

// ========================================
// Start Server
// ========================================

app.listen(PORT, () => {
    console.log('\n🚀 K8s Health Dashboard Backend Started!');
    console.log(`📡 Server running on http://localhost:${PORT}`);
    console.log('\n📍 Available endpoints:');
    console.log('   GET /api/health       - Health check');
    console.log('   GET /api/cluster      - Cluster summary');
    console.log('   GET /api/pods         - All pods');
    console.log('   GET /api/nodes        - All nodes');
    console.log('   GET /api/deployments  - All deployments');
    console.log('\n💡 Test it: curl http://localhost:3000/api/health');
    console.log('');
});
