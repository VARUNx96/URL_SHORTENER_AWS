from fastapi import FastAPI, HTTPException # type: ignore
from fastapi.responses import RedirectResponse # type: ignore
from db import get_url
import redis

app = FastAPI()

r = redis.Redis(host="redis", port=6379, decode_responses=True)

@app.get("/{code}")
def redirect(code: str):
    cached_url = r.get(code)

    if cached_url:
        return RedirectResponse(url = cached_url)
    long_url = get_url(code)
    if not long_url:
        raise HTTPException(status_code=404, detail = "URL NOT FOUND ⚠️")
    r.set(code, long_url)
    return RedirectResponse(url = long_url)