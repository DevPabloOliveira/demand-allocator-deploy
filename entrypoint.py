import os
import uvicorn
from backend.app.main import app as api_app
from frontend.main     import app as ui_app

# monta o frontend no caminho "/"
api_app.mount("/", ui_app, name="ui")

if __name__ == "__main__":
    port = int(os.getenv("PORT", 8000))
    uvicorn.run(
        api_app,
        host="0.0.0.0",
        port=port,
        workers=os.cpu_count()
    )
