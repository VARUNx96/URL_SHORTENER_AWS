from fastapi import FastAPI # type: ignore
from pydantic import BaseModel # type: ignore
from utils import generate_code
from db import save_url

app = FastAPI()

class URLRequest(BaseModel):
    long_url: str

@app.post("/shorten")
def shorten_url(request: URLRequest):
    code = generate_code()
    save_url(code, request.long_url)
    return {"short_url": f"http://localhost:8001/{code}"}