#!/bin/bash

REG=registry.home.glroland.com/paas
REG_V=latest

#NESTED_TAG=$REG/tools-nested-generic:$REG_V
#cekit --descriptor nested.yaml build podman --tag $NESTED_TAG
#podman push $NESTED_TAG --tls-verify=false

NOTEBOOK_TAG=$REG/tools-notebook:$REG_V
cekit --descriptor notebook.yaml build podman --tag $NOTEBOOK_TAG
#podman push $NOTEBOOK_TAG --tls-verify=false

