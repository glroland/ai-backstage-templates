container_registry := registry.home.glroland.com
container_tag := 1

install:
	pip install -r requirements.txt

all-mpnet-base-v2:
	podman build . -t modelcar-all-mpnet-base-v2:latest --platform linux/amd64 "--build-arg=MODEL_REPO=sentence-transformers/all-mpnet-base-v2"
	podman tag modelcar-all-mpnet-base-v2:latest $(container_registry)/ai/modelcar-all-mpnet-base-v2:$(container_tag)
	podman push $(container_registry)/ai/modelcar-all-mpnet-base-v2:$(container_tag)

all-MiniLM-L6-v2:
	podman build . -t modelcar-all-minilm-l6-v2:latest --platform linux/amd64 "--build-arg=MODEL_REPO=sentence-transformers/all-MiniLM-L6-v2"
	podman tag modelcar-all-minilm-l6-v2:latest $(container_registry)/ai/modelcar-all-minilm-l6-v2:$(container_tag)
	podman push $(container_registry)/ai/modelcar-all-minilm-l6-v2:$(container_tag)

all-roberta-base-squad2:
	podman build . -t modelcar-roberta-base-squad2:latest --platform linux/amd64 "--build-arg=MODEL_REPO=deepset/roberta-base-squad2"
	podman tag modelcar-roberta-base-squad2:latest $(container_registry)/ai/modelcar-roberta-base-squad2:$(container_tag)
	podman push $(container_registry)/ai/modelcar-roberta-base-squad2:$(container_tag)

distilbert-base-cased-distilled-squad:
	podman build . -t modelcar-distilbert-base-cased-distilled-squad:latest --platform linux/amd64 "--build-arg=MODEL_REPO=distilbert/distilbert-base-cased-distilled-squad"
	podman tag modelcar-distilbert-base-cased-distilled-squad:latest $(container_registry)/ai/modelcar-distilbert-base-cased-distilled-squad:$(container_tag)
	podman push $(container_registry)/ai/modelcar-distilbert-base-cased-distilled-squad:$(container_tag)
