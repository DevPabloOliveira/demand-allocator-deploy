#!/usr/bin/env bash
set -e

# garante que o conda/bin esteja no PATH
export PATH="/opt/conda/bin:${PATH}"

# chama o entrypoint em Python, que monta o frontend na API e roda o uvicorn
exec python /app/entrypoint.py
