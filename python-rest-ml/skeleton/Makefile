lint:
	pylint *.py

run: lint
	python app.py

build: lint
	podman build -t ${{values.artifact_id}}-image:latest docker/.

dev: lint
	odo dev
