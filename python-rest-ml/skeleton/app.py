import uvicorn
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def default_response():
    return {"message": f"Hello!  Tell me who you are via /hello?name=NameGoesHere"}

@app.get("/hello")
def hello(name: str = ""):
    return {"message": f"Hello {name}"}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)
