install:
	pip install -r requirements.txt

lint:
	pylint src/*.py

run: lint
	python src/app.py

build:
	podman build -t ${{values.artifact_id}}-image:latest .

dev: lint
	odo dev
