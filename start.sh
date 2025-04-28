#!/usr/bin/env bash
set -e

# monta o UI do Kepler dentro da API
python - <<'PY'
from backend.app.main import app as api_app
from frontend.main     import app as ui_app

# servir UI em "/"
api_app.mount("/", ui_app, name="ui")
PY

# executa tudo numa só porta (a que o Railway fornecer)
exec uvicorn backend.app.main:app --host 0.0.0.0 --port "${PORT:-8000}" --workers $(nproc)
