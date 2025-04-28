#!/usr/bin/env python3
import os
import uvicorn

# sys.path.insert(0, os.path.join(os.getcwd(), "backend"))
# sys.path.insert(0, os.path.join(os.getcwd(), "frontend"))

# este import agora encontra /app/backend/app/main.py
from app.main import app as api_app

# este import encontra /app/frontend/main.py
from main import app as ui_app

# monta a UI do frontend em /
api_app.mount("/", ui_app, name="ui")

if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(api_app, host="0.0.0.0", port=port, workers=os.cpu_count())
