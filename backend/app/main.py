import logging
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import settings
from app.routes import router as api_router

# Importa a app FastAPI do frontend
from frontend.main import app as ui_app

logger = logging.getLogger(__name__)

# Cria a instância principal
app = FastAPI(
    title=settings.APP_TITLE,
    description=settings.APP_DESCRIPTION,
    version=settings.APP_VERSION,
)

# Monta o front-end (UI) em raiz “/”
app.mount("/", ui_app, name="ui")

# Configura CORS para a API
origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

logger.info("Starting FastAPI application with title: %s", settings.APP_TITLE)

# Inclui o roteador da sua API (todos os endpoints em /knn_model, /api/eda, /consulta_base…)
app.include_router(api_router)

logger.info("Router has been included. Application setup complete.")
