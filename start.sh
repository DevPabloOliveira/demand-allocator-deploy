#!/usr/bin/env bash
set -e

# só dispara o seu entrypoint Python que monta os dois FastAPI.apps e roda o uvicorn
exec python entrypoint.py
