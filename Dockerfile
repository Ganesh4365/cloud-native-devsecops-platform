# Stage 1: Build & Dependency Resolution
FROM python:3.11-slim AS builder

WORKDIR /build
COPY app/requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Stage 2: Hardened Runtime Container
FROM python:3.11-slim AS runner

WORKDIR /app

# Security: Create non-root user and group
RUN groupadd -g 10001 appgroup && \
    useradd -u 10001 -g appgroup -s /bin/sh appuser

# Copy installed dependencies from builder
COPY --from=builder /root/.local /home/appuser/.local
COPY app/ .

# Ensure permissions and ownership
RUN chown -R appuser:appgroup /app
USER 10001
ENV PATH=/home/appuser/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1

EXPOSE 8000

# Healthcheck configuration
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/healthz || exit 1

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
