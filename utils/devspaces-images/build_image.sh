#!/bin/bash

TAG=registry.home.glroland.com/paas/tools-nested-generic:latest

cekit --descriptor nested.yaml build podman --tag $TAG

podman push $TAG --tls-verify=false

