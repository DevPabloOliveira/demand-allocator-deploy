#!/usr/bin/env python3
import os
import sys
import uvicorn

# ─── GARANTE QUE O NOSSO "app" TEM PRIORIDADE ─────────────────────
BASE_DIR     = os.path.dirname(__file__)      # /app
BACKEND_PATH = os.path.join(BASE_DIR, "backend")
if BACKEND_PATH not in sys.path:              # insere na posição 0
    sys.path.insert(0, BACKEND_PATH)

# agora os imports locais prevalecem sobre quaisquer pacotes externos
from backend.app.main import app as api_app
from frontend.main     import app as ui_app
# ───────────────────────────────────────────────────────────────────

api_app.mount("/", ui_app, name="ui")

if __name__ == "__main__":
    uvicorn.run(
        api_app,
        host="0.0.0.0",
        port=int(os.getenv("PORT", 8000)),
        workers=os.cpu_count() or 1
    )
