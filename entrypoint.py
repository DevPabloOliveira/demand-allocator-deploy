#!/usr/bin/env python3
import os, sys, importlib.util, importlib, uvicorn

BASE_DIR   = os.path.dirname(__file__)      # /app
BACK_PATH  = os.path.join(BASE_DIR, "backend")      # /app/backend
APP_PATH   = os.path.join(BACK_PATH, "app")         # /app/backend/app

# 1) chute fora qualquer pacote externo chamado “app”
sys.modules.pop("app", None)

# 2) garanta que /app/backend vem ANTES do site-packages
if BACK_PATH not in sys.path:
    sys.path.insert(0, BACK_PATH)

# 3) crie um *package* “app” com __path__ correcto
spec = importlib.util.spec_from_file_location(
    "app",
    os.path.join(APP_PATH, "__init__.py"),
    submodule_search_locations=[APP_PATH]   # ← ESSENCIAL!
)
app_pkg = importlib.util.module_from_spec(spec)
sys.modules["app"] = app_pkg
spec.loader.exec_module(app_pkg)

# 4) a partir daqui todos os “from app.…” resolvem para o seu código
from backend.app.main import app as api_app
from frontend.main     import app as ui_app

api_app.mount("/", ui_app, name="ui")

if __name__ == "__main__":
    uvicorn.run(
        api_app,
        host="0.0.0.0",
        port=int(os.getenv("PORT", 8000)),
        workers=1     

    )
