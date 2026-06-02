from pydantic import BaseModel


class UserRegister(BaseModel):
    """Kayıt olma isteği modeli"""
    name: str
    email: str
    password: str


class UserLogin(BaseModel):
    """Giriş yapma isteği modeli"""
    email: str
    password: str


class UserResponse(BaseModel):
    """Kullanıcı bilgisi yanıt modeli"""
    id: str
    name: str
    email: str
