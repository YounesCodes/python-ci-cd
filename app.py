import requests
from fastapi import FastAPI
from fastapi.responses import HTMLResponse

app = FastAPI()
URL = "https://blog.youneslab.xyz"


def is_up() -> bool:
    try:
        return requests.get(URL, timeout=5).status_code == 200
    except requests.RequestException:
        return False


@app.get("/api/health")
def health():
    return {"up": is_up()}


@app.get("/", response_class=HTMLResponse)
def index():
    up = is_up()
    return f"<h1 style='font-family:sans-serif;text-align:center'>Blog is {'UP' if up else 'DOWN'}</h1>"
