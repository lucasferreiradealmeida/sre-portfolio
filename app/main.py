from fastapi import FastAPI, Response
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import time
import random

app = FastAPI()

# SLIs (Indicadores de Nível de Serviço) que vamos monitorar no Grafana
REQUEST_COUNT = Counter('app_requests_total', 'Total de requisições', ['method', 'endpoint', 'http_status'])
REQUEST_LATENCY = Histogram('app_request_latency_seconds', 'Latência das requisições', ['endpoint'])

@app.get("/")
def read_root():
    start_time = time.time()
    
    # Simula um leve atraso no processamento
    time.sleep(random.uniform(0.1, 0.3))
    
    REQUEST_COUNT.labels(method='GET', endpoint='/', http_status=200).inc()
    REQUEST_LATENCY.labels(endpoint='/').observe(time.time() - start_time)
    
    return {"message": "Hello, SRE World! API funcionando."}

@app.get("/error")
def simulate_error():
    # Este endpoint será usado pelo nosso script de Chaos para simular falhas em produção
    REQUEST_COUNT.labels(method='GET', endpoint='/error', http_status=500).inc()
    return Response(status_code=500, content="Erro interno simulado para teste de resiliência!")

@app.get("/metrics")
def metrics():
    # Rota que o Prometheus vai acessar para raspar as métricas
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)