#!/bin/bash

TAG=registry.home.glroland.com/paas/tools-python311:latest

cekit --descriptor nested.yaml build podman --tag $TAG

podman push $TAG --tls-verify=false

