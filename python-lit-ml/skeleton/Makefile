install:
	pip install -r requirements.txt

lint:
	pylint src/*.py

run: lint
	cd src && streamlit run app.py --server.port 8080 --server.address 0.0.0.0  --server.headless true --logger.level debug

build:
	podman build -t ${{values.artifact_id}}-image:latest . --platform linux/amd64

push:
	podman tag ${{values.artifact_id}}-image:latest registry.home.glroland.com/ai/${{values.artifact_id}}:latest
	podman push registry.home.glroland.com/ai/${{values.artifact_id}}:latest --tls-verify=false

deploy:
	oc apply -f kubernetes/deploy.yaml

dev: lint
	odo dev
