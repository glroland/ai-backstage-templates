timestamp := $(shell date +"%Y%m%d-%H%M%S")

build-notebook:
	cd ai-notebook && podman build . -t registry.home.glroland.com/paas/ai-notebook-3.11:$(timestamp)
	podman push registry.home.glroland.com/paas/ai-notebook-3.11:$(timestamp)

build-runtime:
	cd ai-runtime && podman build . -t registry.home.glroland.com/paas/ai-runtime-3.11:$(timestamp)
	podman push registry.home.glroland.com/paas/ai-runtime-3.11:$(timestamp)

build: build-notebook build-runtime


build-hadoop-spark-notebook:
	cd oai-hadoop-spark-notebook && podman build . --platform linux/linux/amd64 -t registry.home.glroland.com/paas/oai-hadoop-spark-notebook:$(timestamp)
#	podman push registry.home.glroland.com/paas/oai-hadoop-spark-notebook:$(timestamp)
