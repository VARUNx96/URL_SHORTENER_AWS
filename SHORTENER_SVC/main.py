from fastapi import FastAPI # type: ignore
from pydantic import BaseModel # type: ignore
from utils import genrate_code
from db import save_url
import redis

app = FastAPI()

r = redis.Redis(host="redis", port=6379, decode_responses=True)

class URLRequest(BaseModel):
    long_url: str

@app.post("/shorten")
def shorten_url(request: URLRequest):
    code = genrate_code()
    save_url(code, request.long_url)
    r.set(code, request.long_url)
    return {"short_url": f"http://localhost:8001/{code}"}