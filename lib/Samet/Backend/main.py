"""
Bütçe Takip - Authentication Backend
=====================================
Çalıştırmak için:
  cd lib/Samet/Backend
  pip install -r requirements.txt
  python -m uvicorn main:app --reload --port 8001
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from auth import router as auth_router

# ─── FastAPI Uygulaması ───────────────────────────────────────
app = FastAPI(
    title="Bütçe Takip - Auth API",
    description="Kimlik doğrulama ve kullanıcı yönetimi API'si",
    version="1.0.0",
)

# ─── CORS Middleware ──────────────────────────────────────────
# Flutter uygulamasından gelen isteklere izin ver
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ─── Router'ları Dahil Et ────────────────────────────────────
app.include_router(auth_router)


# ─── Ana Endpoint ────────────────────────────────────────────
@app.get("/")
async def root():
    return {
        "message": "Bütçe Takip Auth API çalışıyor!",
        "docs": "/docs",
        "endpoints": {
            "register": "POST /auth/register",
            "login": "POST /auth/login",
            "me": "GET /auth/me",
        },
    }
