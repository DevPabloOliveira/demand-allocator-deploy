# backend/app/main.py

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from frontend.main import app as ui_app
from backend.app.routes import router as api_router


app = FastAPI(title="Demand-Allocator")

# monta a API
app.include_router(api_router, prefix="/api")

# monta o UI sub-app na raiz
app.mount("/", ui_app)

# monta os assets de dentro do UI para a rota /assets
app.mount(
    "/assets",
    StaticFiles(directory="/app/frontend/web/assets"),
    name="assets"
)
