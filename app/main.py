from contextlib import asynccontextmanager

from fastapi import FastAPI

from app.migrations import run_migrations
from app.routers import pricing, versions


@asynccontextmanager
async def lifespan(app: FastAPI):
    run_migrations()
    yield


app = FastAPI(title="AWS Pricing List Loader", lifespan=lifespan)
app.include_router(pricing.router)
app.include_router(versions.router)


@app.get("/health")
def health():
    return {"status": "ok"}
