"""
Authentication API Endpointleri
- POST /auth/register → Yeni kullanıcı kaydı
- POST /auth/login    → Kullanıcı girişi + JWT token
- GET  /auth/me       → Token ile kullanıcı bilgisi
"""

from fastapi import APIRouter, HTTPException, Header
from models import UserRegister, UserLogin
import bcrypt
import jwt
import json
import os
import uuid
from datetime import datetime, timedelta, timezone
import firebase_admin
from firebase_admin import credentials, firestore

# ─── Yapılandırma ────────────────────────────────────────────
router = APIRouter(prefix="/auth", tags=["Authentication"])

SECRET_KEY = "butce_takip_jwt_secret_key_2024"
ALGORITHM = "HS256"
TOKEN_EXPIRE_HOURS = 24

# ─── Firebase Entegrasyonu ───────────────────────────────────
# Klasördeki .json uzantılı Firebase key dosyasını bul (users.json hariç)
key_file_path = None
backend_dir = os.path.dirname(os.path.abspath(__file__))
for filename in os.listdir(backend_dir):
    if filename.endswith(".json") and filename != "users.json" and ("firebase" in filename.lower() or filename.startswith("butce-takip")):
        key_file_path = os.path.join(backend_dir, filename)
        break

if not key_file_path:
    # Varsayılan fallback
    key_file_path = os.path.join(backend_dir, "firebase_key.json")

try:
    cred = credentials.Certificate(key_file_path)
    firebase_admin.initialize_app(cred)
    db = firestore.client()
    print(f"Firebase başarıyla başlatıldı. Anahtar: {os.path.basename(key_file_path)}")
except Exception as e:
    print(f"Firebase başlatma hatası: {e}")
    db = None



def hash_password(password: str) -> str:
    """Şifreyi bcrypt ile hashle"""
    salt = bcrypt.gensalt()
    hashed = bcrypt.hashpw(password.encode("utf-8"), salt)
    return hashed.decode("utf-8")


def verify_password(password: str, hashed: str) -> bool:
    """Şifreyi hash ile karşılaştır"""
    return bcrypt.checkpw(password.encode("utf-8"), hashed.encode("utf-8"))


def create_token(user_id: str, email: str) -> str:
    """JWT token oluştur (24 saat geçerli)"""
    payload = {
        "user_id": user_id,
        "email": email,
        "exp": datetime.now(timezone.utc) + timedelta(hours=TOKEN_EXPIRE_HOURS),
        "iat": datetime.now(timezone.utc),
    }
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)


def decode_token(token: str) -> dict:
    """JWT token'ı çöz ve doğrula"""
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token süresi dolmuş. Lütfen tekrar giriş yapın.")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Geçersiz token.")


# ─── API Endpointleri ────────────────────────────────────────

@router.post("/register")
async def register(user: UserRegister):
    """
    Yeni kullanıcı kaydı oluştur.
    - Firestore'da e-posta benzersizlik kontrolü yapar
    - Şifreyi bcrypt ile hashler
    - Kullanıcıyı Firestore 'users' koleksiyonuna kaydeder
    """
    # Validasyon
    if not user.name.strip():
        raise HTTPException(status_code=400, detail="Ad Soyad boş olamaz.")
    if not user.email.strip() or "@" not in user.email:
        raise HTTPException(status_code=400, detail="Geçerli bir e-posta adresi giriniz.")
    if len(user.password) < 6:
        raise HTTPException(status_code=400, detail="Şifre en az 6 karakter olmalıdır.")

    if db is None:
        raise HTTPException(status_code=500, detail="Firebase veritabanı bağlantısı kurulamadı.")

    # E-posta benzersizlik kontrolü
    users_ref = db.collection("users")
    query = users_ref.where("email", "==", user.email.strip().lower()).limit(1).stream()
    existing_user = None
    for doc in query:
        existing_user = doc.to_dict()

    if existing_user:
        raise HTTPException(status_code=400, detail="Bu e-posta adresi zaten kayıtlı.")

    # Yeni kullanıcı oluştur
    new_user_id = str(uuid.uuid4())
    new_user = {
        "id": new_user_id,
        "name": user.name.strip(),
        "email": user.email.strip().lower(),
        "password": hash_password(user.password),
        "created_at": datetime.now(timezone.utc).isoformat(),
    }

    db.collection("users").document(new_user_id).set(new_user)

    return {
        "message": "Kayıt başarılı!",
        "user": {
            "id": new_user["id"],
            "name": new_user["name"],
            "email": new_user["email"],
        },
    }


@router.post("/login")
async def login(user: UserLogin):
    """
    Kullanıcı girişi yap.
    - E-posta ve şifre doğrulaması yapar (Firestore üzerinden)
    - Başarılı ise JWT token döndürür
    """
    if not user.email.strip() or not user.password:
        raise HTTPException(status_code=400, detail="E-posta ve şifre gereklidir.")

    if db is None:
        raise HTTPException(status_code=500, detail="Firebase veritabanı bağlantısı kurulamadı.")

    # Kullanıcıyı bul
    users_ref = db.collection("users")
    query = users_ref.where("email", "==", user.email.strip().lower()).limit(1).stream()
    existing_user = None
    for doc in query:
        existing_user = doc.to_dict()

    if existing_user:
        # Şifre kontrolü
        if verify_password(user.password, existing_user["password"]):
            token = create_token(existing_user["id"], existing_user["email"])
            return {
                "message": "Giriş başarılı!",
                "token": token,
                "user": {
                    "id": existing_user["id"],
                    "name": existing_user["name"],
                    "email": existing_user["email"],
                },
            }
        else:
            raise HTTPException(status_code=401, detail="E-posta adresi veya şifre hatalı.")

    raise HTTPException(status_code=401, detail="E-posta adresi veya şifre hatalı.")


@router.get("/me")
async def get_current_user(authorization: str = Header(...)):
    """
    Token ile giriş yapmış kullanıcının bilgilerini döndür.
    Header: Authorization: Bearer <token>
    """
    # Token'ı ayıkla
    if not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Geçersiz Authorization header formatı.")

    if db is None:
        raise HTTPException(status_code=500, detail="Firebase veritabanı bağlantısı kurulamadı.")

    token = authorization.replace("Bearer ", "")
    payload = decode_token(token)

    # Kullanıcıyı Firestore'dan çek
    doc_ref = db.collection("users").document(payload["user_id"])
    doc = doc_ref.get()
    
    if doc.exists:
        user_data = doc.to_dict()
        return {
            "id": user_data["id"],
            "name": user_data["name"],
            "email": user_data["email"],
        }

    raise HTTPException(status_code=404, detail="Kullanıcı bulunamadı.")
