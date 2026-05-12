from fastapi import FastAPI, HTTPException # type: ignore
from pydantic import BaseModel # type: ignore
from utils import genrate_code
from db import save_url
import redis # type: ignore


app = FastAPI()


@app.get("/health")
def health():
    try:
        r.ping()
        return {"status": "OK..✅✅✅"}
    except Exception:
        raise HTTPException(status_code = 500, detail = "REDIS NOT REACHABLE...⚠️⚠️⚠️")



r = redis.Redis(host="redis", port=6379, decode_responses=True)

class URLRequest(BaseModel):
    long_url: str

@app.post("/shorten")
def shorten_url(request: URLRequest):
    code = genrate_code()
    save_url(code, request.long_url)
    r.set(code, request.long_url)
    return {"short_url": f"http://localhost:8001/{code}"}