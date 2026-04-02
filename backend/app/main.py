from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import listings, map, stats

app = FastAPI(
    title="AccomMap API",
    description="Price map of accommodation in South Moravia",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["GET"],
    allow_headers=["*"],
)

app.include_router(listings.router, prefix="/api")
app.include_router(map.router, prefix="/api")
app.include_router(stats.router, prefix="/api")


@app.get("/health")
def health():
    return {"status": "ok"}
