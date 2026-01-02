from fastapi import FastAPI
from src.api.router import router as api_router

app = FastAPI(version="0.1")
app.include_router(api_router)