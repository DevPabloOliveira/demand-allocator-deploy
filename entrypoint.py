#!/usr/bin/env python3
import os
import multiprocessing

# Importe primeiro as duas FastAPI apps
from app.main      import app as api_app
from frontend.main import app as ui_app

# Monte a UI no root da API
api_app.mount("/", ui_app, name="ui")

if __name__ == "__main__":
    import uvicorn

    # Porta vindo do Railway ou fallback
    port = int(os.environ.get("PORT", 8000))
    # Número de workers dinamicamente igual ao n.º de CPUs
    workers = multiprocessing.cpu_count()

    uvicorn.run(
        api_app,
        host="0.0.0.0",
        port=port,
        workers=workers,
    )
