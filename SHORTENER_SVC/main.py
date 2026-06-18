from fastapi import FastAPI, Request # type: ignore
from pydantic import BaseModel # type: ignore
from utils import genrate_code
from db import save_url
import redis # type: ignore



app = FastAPI()


@app.get("/health")
def health():
    return {"status": "healthy"}



r = redis.Redis(host="redis", port=6379, decode_responses=True)

class URLRequest(BaseModel):
    long_url: str

@app.post("/shorten")
def shorten_url(url_request: URLRequest,request: Request):
    code = genrate_code()
    save_url(code, url_request.long_url)
    base_url = str(request.base_url).rstrip("/")
    r.set(code, url_request.long_url)
    return {"short_url": f"{base_url}/{code}"}