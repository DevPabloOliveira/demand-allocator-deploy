#!/bin/sh
# start-backend.sh

# 1) API (FastAPI): escuta em $PORT (Railway)
uvicorn app.main:app \
  --host 0.0.0.0 \
  --port ${PORT:-8050} &

# 2) UI (FastAPI + Jinja) ou router estático
#    se você mantiver o frontend como app separado,
#    escolhe outra porta interna (ex: 8000).
uvicorn main:app \
  --host 0.0.0.0 \
  --port 8000

# o segundo processo fica em foreground, o primeiro em background
