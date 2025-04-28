#!/usr/bin/env python3
import os, sys, importlib.util, types, uvicorn

BASE_DIR  = os.path.dirname(__file__)      #  /app
BACK_PATH = os.path.join(BASE_DIR, "backend")   #  /app/backend
APP_PATH  = os.path.join(BACK_PATH, "app")      #  /app/backend/app

# ── 1) se já houver um “app” alheio nos módulos cargados → descarte-o
sys.modules.pop("app", None)

# ── 2) injecta o nosso pacote “app” como **top-level** ANTES de qualquer import
spec = importlib.util.spec_from_file_location("app", os.path.join(APP_PATH, "__init__.py"))
app_pkg = importlib.util.module_from_spec(spec)
sys.modules["app"] = app_pkg     # reserva o nome
spec.loader.exec_module(app_pkg) # executa __init__.py (mesmo que vazio)

# ── 3) adiciona /app/backend no topo do sys.path (se ainda não estiver)
if BACK_PATH not in sys.path:
    sys.path.insert(0, BACK_PATH)

# ── 4) agora é seguro importar o resto
from backend.app.main import app as api_app
from frontend.main     import app as ui_app

api_app.mount("/", ui_app, name="ui")

if __name__ == "__main__":
    uvicorn.run(
        api_app,
        host="0.0.0.0",
        port=int(os.getenv("PORT", 8000)),
        workers=os.cpu_count() or 1
    )
