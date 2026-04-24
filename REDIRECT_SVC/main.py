from fastapi import FastAPI, HTTPException # type: ignore
from fastapi.responses import RedirectResponse # type: ignore
from db import get_url

app = FastAPI()

@app.get("/{code}")
def redirect(code: str):
    long_url = get_url(code)
    if not long_url:
        raise HTTPException(status_code=404, detail="URL NOT FOUND")
    return RedirectResponse(long_url)