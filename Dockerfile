# ── builder stage: install dependencies into an isolated venv ──────────────
FROM python:3.12-slim AS builder

WORKDIR /app

ENV VIRTUAL_ENV=/opt/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# ── runtime stage: lean image with only what's needed at runtime ───────────
FROM python:3.12-slim

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN groupadd --system appuser && useradd --system --gid appuser appuser

COPY --from=builder $VIRTUAL_ENV $VIRTUAL_ENV

COPY app/ ./app/
COPY migrations/ ./migrations/
COPY create_table.py fetch_pricing_index.py docker-entrypoint.sh ./

RUN mkdir -p schema && chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
