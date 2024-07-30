#!/usr/bin/env bash

microdnf update -y
microdnf clean all
mkdir -p ${HOME}
mkdir -p /usr/local/bin
chgrp -R 0 /home
chmod -R g=u /home
cp /tmp/artifacts/entrypoint.sh /entrypoint.sh
cp /tmp/artifacts/entrypoint-nested.sh /entrypoint-nested.sh
cp /tmp/artifacts/entrypoint-userns.sh /entrypoint-userns.sh
chown 0:0 /entrypoint.sh
chmod +x /entrypoint.sh
chown 0:0 /entrypoint-nested.sh
chmod +x /entrypoint-nested.sh
chown 0:0 /entrypoint-userns.sh
chmod +x /entrypoint-userns.sh
chown 0:0 /etc/passwd
chown 0:0 /etc/group
chmod g=u /etc/passwd /etc/group
# Setup for rootless podman
setcap cap_setuid+ep /usr/bin/newuidmap
setcap cap_setgid+ep /usr/bin/newgidmap
touch /etc/subgid /etc/subuid
chown 0:0 /etc/subgid
chown 0:0 /etc/subuid
chmod -R g=u /etc/subuid /etc/subgid
curl -o /tmp/oc.tgz https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable-4.16/openshift-client-linux.tar.gz
tar -zxf /tmp/oc.tgz --directory /tmp
rm -f /tmp/oc.tgz
mv /tmp/oc /usr/local/bin/oc
chmod 755 /usr/local/bin/oc
rm -f /tmp/oc.tgz
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
mv kubectl /usr/local/bin/kubectl
chmod 755 /usr/local/bin/kubectl
curl -o /tmp/helm.tgz https://get.helm.sh/helm-v3.15.3-linux-amd64.tar.gz
tar -zxf /tmp/helm.tgz --directory /tmp
rm -f /tmp/helm.tgz
mv /tmp/linux-amd64/helm /usr/local/bin/helm
rm -rf /tmp/linux-amd64
chmod 755 /usr/local/bin/helm

