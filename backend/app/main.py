# backend/app/main.py

import logging
from fastapi import FastAPI
from app.config import settings
from app.routes import router as api_router
from fastapi.middleware.cors import CORSMiddleware

# importe a app do frontend
from frontend.main import app as ui_app

from app.config import settings
from app.routes import router as api_router

logger = logging.getLogger(__name__)

app = FastAPI(
    title=settings.APP_TITLE,
    description=settings.APP_DESCRIPTION,
    version=settings.APP_VERSION,
)

# monte o UI em "/"
app.mount("/", ui_app, name="ui")

# (aqui você continua a configurar CORS, routers, etc)
origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,  
    allow_credentials=True,
    allow_methods=["*"],   
    allow_headers=["*"],    
)
logger.info("Starting FastAPI application with title: %s", settings.APP_TITLE)
app.include_router(api_router)
logger.info("Router has been included. Application setup complete.")