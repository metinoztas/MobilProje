# Kullanım ;
# uvicorn main:app --reload

from fastapi import FastAPI
import google.generativeai as genai

# Gemini API anahtarı
genai.configure(api_key="AIzaSyBE043i3h6yMXqXwsqP632_4rQMH6HfLAc")

# AI modeli
model = genai.GenerativeModel("gemini-2.5-flash")

# FastAPI uygulaması
app = FastAPI()


# AI endpoint
@app.post("/ai")
async def ai(data: dict):

    mesaj = data["message"]

    cevap = model.generate_content(mesaj)

    return {
        "reply": cevap.text
    }