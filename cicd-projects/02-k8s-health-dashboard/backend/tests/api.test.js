// Simple tests for K8s Health Dashboard Backend API
const request = require('supertest');

describe('K8s Health Dashboard API Tests', () => {
  let app;
  let server;

  beforeAll(() => {
    // Mock Kubernetes client for testing
    process.env.NODE_ENV = 'test';
    app = require('../server');
  });

  afterAll((done) => {
    if (server) {
      server.close(done);
    } else {
      done();
    }
  });

  describe('Health Check Endpoint', () => {
    it('should return 200 and healthy status', async () => {
      const res = await request(app).get('/api/health');
      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('status', 'healthy');
    });
  });

  describe('API Endpoints Structure', () => {
    it('should have timestamp in responses', async () => {
      const res = await request(app).get('/api/health');
      expect(res.body).toHaveProperty('timestamp');
    });
  });
});
