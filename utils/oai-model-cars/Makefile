container_registry := registry.home.glroland.com
container_tag := 1

install:
	pip install -r requirements.txt

all-mpnet-base-v2:
	podman build . -t modelcar-all-mpnet-base-v2:latest --platform linux/amd64 "--build-arg=MODEL_REPO=sentence-transformers/all-mpnet-base-v2"
	podman tag modelcar-all-mpnet-base-v2:latest $(container_registry)/ai/modelcar-all-mpnet-base-v2:$(container_tag)
	podman push $(container_registry)/ai/modelcar-all-mpnet-base-v2:$(container_tag)
