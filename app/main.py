from fastapi import FastAPI
from app.routers import pricing, versions

app = FastAPI(title="AWS Pricing List Loader")
app.include_router(pricing.router)
app.include_router(versions.router)


@app.get("/health")
def health():
    return {"status": "ok"}
