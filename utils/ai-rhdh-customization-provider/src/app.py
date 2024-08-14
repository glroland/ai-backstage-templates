"""Web Server for Customization Provider Content

Customization Provider for Red Hat Developer Hub that customizes backstage
to reflect as an AI Developer Portal.
"""
import uvicorn
from starlette.applications import Starlette
from starlette.responses import FileResponse
from starlette.routing import Route

#async def app(scope, receive, send):
#    assert scope['type'] == 'http'
#    response = FileResponse('statics/favicon.ico')
#    await response(scope, receive, send)

async def home(request):
    """Respond with Home data file """
    return FileResponse("static/home/data.json")

async def learning_paths(request):
    """Respond with Learning Path data file """
    return FileResponse("static/learning-paths/data.json")

async def tech_radar(request):
    """Respond with the Tech Radar data file """
    return FileResponse("static/tech-radar/data.json")

# FastAPI Server Configuration
routes = [
    Route("/", endpoint=home),
    Route("/learning-paths", endpoint=learning_paths),
    Route("/tech-radar", endpoint=tech_radar),
]
app = Starlette(routes=routes)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)
