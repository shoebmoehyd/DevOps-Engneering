# Stage 1: Build dependencies
FROM python:3.11-alpine AS builder

WORKDIR /app

# Install dependencies in a virtual environment
COPY requirements.txt .
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# Stage 2: Production image
FROM python:3.11-alpine

WORKDIR /app

# Copy virtual environment from builder
COPY --from=builder /opt/venv /opt/venv

# Copy application code
COPY app.py .
COPY templates/ templates/

# Create non-root user
RUN adduser -D appuser && chown -R appuser:appuser /app
USER appuser

# Activate virtual environment
ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 5000

CMD ["python", "app.py"]
