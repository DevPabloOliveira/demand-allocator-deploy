#!/usr/bin/env python3
import os
import uvicorn
from backend.app.main import app as api_app
from frontend.main     import app as ui_app

# Monta o UI do frontend na raiz da API
api_app.mount("/", ui_app, name="ui")

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    workers = os.cpu_count() or 1
    uvicorn.run(
        api_app,
        host="0.0.0.0",
        port=port,
        workers=workers
    )
