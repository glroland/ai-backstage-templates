clean:
	rm -rf target

package:
	mvn package

run:
	mvn spring-boot:run

build:
	podman build -t ${{values.artifact_id}}-image:latest . --platform linux/amd64

push:
	podman tag ${{values.artifact_id}}-image:latest registry.home.glroland.com/ai/${{values.artifact_id}}:latest
	podman push registry.home.glroland.com/ai/${{values.artifact_id}}:latest --tls-verify=false

deploy:
	oc apply -f kubernetes/deploy.yaml

dev:
	odo dev
