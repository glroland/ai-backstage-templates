install:
	pip install -r requirements.txt

lint:
	pylint src/*.py

run: #lint
	cd src && python app.py

build:
	podman build -t ai-rhdh-customization-provider-image:latest . --platform linux/amd64

push:
	podman tag ai-rhdh-customization-provider-image:latest registry.home.glroland.com/paas/ai-rhdh-customization-provider:latest
	podman push registry.home.glroland.com/paas/ai-rhdh-customization-provider:latest --tls-verify=false

deploy:
	cd helm/ai-rhdh-customization-provider && helm install ai-rhdh-customization-provider .

undeploy:
	helm uninstall ai-rhdh-customization-provider

dev: lint
	odo dev
