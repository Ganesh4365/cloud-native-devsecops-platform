from fastapi import FastAPI, Response, status
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import time
import os

app = FastAPI(
    title="Cloud-Native Microservice",
    description="Production-grade API with Prometheus metrics & health probes",
    version="1.0.0"
)

# Prometheus Metrics
REQUEST_COUNT = Counter("http_requests_total", "Total HTTP Requests", ["method", "endpoint", "status"])
REQUEST_LATENCY = Histogram("http_request_duration_seconds", "HTTP Request Latency", ["endpoint"])

@app.middleware("http")
async def monitor_requests(request, call_next):
    start_time = time.time()
    response = await call_next(request)
    duration = time.time() - start_time
    
    endpoint = request.url.path
    REQUEST_COUNT.labels(method=request.method, endpoint=endpoint, status=response.status_code).inc()
    REQUEST_LATENCY.labels(endpoint=endpoint).observe(duration)
    return response

@app.get("/")
def read_root():
    return {
        "service": "cloud-native-devsecops-platform",
        "status": "healthy",
        "environment": os.getenv("ENVIRONMENT", "production"),
        "version": "1.0.0"
    }

@app.get("/healthz", status_code=status.HTTP_200_OK)
def health_check():
    # Liveness and readiness probe endpoint
    return {"status": "UP", "timestamp": time.time()}

@app.get("/metrics")
def metrics():
    # Prometheus scraping endpoint
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)
