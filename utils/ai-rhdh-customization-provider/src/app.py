"""Web Server for Customization Provider Content

Customization Provider for Red Hat Developer Hub that customizes backstage
to reflect as an AI Developer Portal.
"""
import os
import uvicorn
from starlette.applications import Starlette
from starlette.responses import FileResponse
from starlette.routing import Route

# pylint: disable=unused-argument

DEFAULT_DATA_FILE = "default_data.json"
OVERRIDE_DATA_FILE = "data.json"

async def home(request):
    """Respond with Home data file """
    data_dir = "static/home/"
    if os.path.exists(data_dir + OVERRIDE_DATA_FILE):
        file = OVERRIDE_DATA_FILE
    else:
        file = DEFAULT_DATA_FILE
    print ("Home - Using path:", data_dir + file)
    return FileResponse(data_dir + file)

async def learning_paths(request):
    """Respond with Learning Path data file """
    data_dir = "static/learning-paths/"
    if os.path.exists(data_dir + OVERRIDE_DATA_FILE):
        file = OVERRIDE_DATA_FILE
    else:
        file = DEFAULT_DATA_FILE
    print ("Learning Paths - Using path:", data_dir + file)
    return FileResponse(data_dir + file)

async def tech_radar(request):
    """Respond with the Tech Radar data file """
    data_dir = "static/tech-radar/"
    if os.path.exists(data_dir + OVERRIDE_DATA_FILE):
        file = OVERRIDE_DATA_FILE
    else:
        file = DEFAULT_DATA_FILE
    print ("Tech Radar - Using path:", data_dir + file)
    return FileResponse(data_dir + file)

# FastAPI Server Configuration
routes = [
    Route("/", endpoint=home),
    Route("/learning-paths", endpoint=learning_paths),
    Route("/tech-radar", endpoint=tech_radar),
]
app = Starlette(routes=routes)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)
