#!/usr/bin/env bash
set -e

# não precisa mais montar dinamicamente, você já incluiu isso em backend/app/main.py
exec uvicorn app.main:app \
     --host 0.0.0.0 \
     --port "${PORT:-8000}" \
     --workers $(nproc)
