timestamp := $(shell date +"%Y%m%d-%H%M%S")

build-notebook:
	cd ai-notebook && podman build . -t registry.home.glroland.com/paas/ai-notebook-3.11:$(timestamp)
	podman push registry.home.glroland.com/paas/ai-notebook-3.11:$(timestamp)

build-runtime:
	cd ai-runtime && podman build . -t registry.home.glroland.com/paas/ai-runtime-3.11:$(timestamp)
	podman push registry.home.glroland.com/paas/ai-runtime-3.11:$(timestamp)

build: build-notebook build-runtime

