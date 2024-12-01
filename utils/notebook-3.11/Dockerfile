FROM registry.redhat.io/ubi9/python-311:9.5-1731639064

LABEL name="ai-backstage-templates-notebook-3.11" \
    summary="glroland notebook for openshift ai development work" \
    description="Jupyter data science notebook image" \
    io.k8s.display-name="Jupyter data science notebook image for ODH notebooks" \
    io.k8s.description="Jupyter data science notebook image with base Python 3.11 builder image based on UBI9 for ODH notebooks" \
    authoritative-source-url="https://github.com/opendatahub-io/notebooks" \
    io.openshift.build.commit.ref="main" \
    io.openshift.build.source-location="https://github.com/glroland/ai-backstage-templates/tree/main/utils/notebook-3.11" \
    io.openshift.build.image="registry.home.glroland.com/paas/notebook-3.11"

WORKDIR /opt/app-root/bin

# Install Python packages and Jupyterlab extensions
COPY requirements.txt ./
COPY start-notebook.sh ./

RUN echo "Installing softwares and packages" && \
    pip install -r requirements.txt && \
    # Fix permissions to support pip in Openshift environments \
    chmod -R g+w /opt/app-root/lib/python3.11/site-packages && \
    fix-permissions /opt/app-root -P

COPY utils ./utils/

# OS Packages needs to be installed as root
USER root

# Install usefull OS packages
RUN dnf install -y jq postgresql zsh git-lfs libsndfile && dnf clean all && rm -rf /var/cache/yum

# Disable announcement plugin of jupyterlab
RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

# Other apps and tools installed as default user
USER 1001

ENV HOME /opt/app-root/src
ENV SHELL /bin/zsh
ENV HISTFILE /opt/app-root/src/.zsh_history
ENV HISTSIZE 1000
ENV SAVEHIST 1000

# Install kubernetes clients
RUN curl -o /tmp/oc.tgz https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable-4.17/openshift-client-linux.tar.gz && \
    tar -zxf /tmp/oc.tgz --directory /tmp && \
    rm -f /tmp/oc.tgz && \
    mv /tmp/oc /usr/local/bin/oc && \
    chmod 755 /usr/local/bin/oc && \
    rm -f /tmp/oc.tgz && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    mv kubectl /usr/local/bin/kubectl && \
    chmod 755 /usr/local/bin/kubectl && \
    curl -o /tmp/helm.tgz https://get.helm.sh/helm-v3.15.3-linux-amd64.tar.gz && \
    tar -zxf /tmp/helm.tgz --directory /tmp && \
    rm -f /tmp/helm.tgz && \
    mv /tmp/linux-amd64/helm /usr/local/bin/helm && \
    rm -rf /tmp/linux-amd64 && \
    chmod 755 /usr/local/bin/helm && \
    curl -L -o /usr/local/bin/odo https://developers.redhat.com/content-gateway/file/pub/openshift-v4/clients/odo/v3.16.1/odo-linux-amd64 && \
    chmod 755 /usr/local/bin/odo

# setup path for runtime configuration
RUN mkdir /opt/app-root/runtimes && \
    # switch to Data Science Pipeline \
    cp utils/pipeline-flow.svg /opt/app-root/lib/python3.11/site-packages/elyra/static/icons/kubeflow.svg && \
    sed -i "s/Kubeflow Pipelines/Data Science/g" /opt/app-root/lib/python3.11/site-packages/elyra/pipeline/runtime_type.py && \
    sed -i "s/Kubeflow Pipelines/Data Science Pipelines/g" /opt/app-root/lib/python3.11/site-packages/elyra/metadata/schemas/kfp.json && \
    sed -i "s/kubeflow-service/data-science-pipeline-service/g" /opt/app-root/lib/python3.11/site-packages/elyra/metadata/schemas/kfp.json && \
    # switch to Data Science Pipeline in component catalog \
    DIR_COMPONENT="/opt/app-root/lib/python3.11/site-packages/elyra/metadata/schemas/local-directory-catalog.json" && \
    FILE_COMPONENT="/opt/app-root/lib/python3.11/site-packages/elyra/metadata/schemas/local-file-catalog.json" && \
    URL_COMPONENT="/opt/app-root/lib/python3.11/site-packages/elyra/metadata/schemas/url-catalog.json" && \
    tmp=$(mktemp) && \
    jq '.properties.metadata.properties.runtime_type = input' $DIR_COMPONENT utils/component_runtime.json > "$tmp" && mv "$tmp" $DIR_COMPONENT && \
    jq '.properties.metadata.properties.runtime_type = input' $FILE_COMPONENT utils/component_runtime.json > "$tmp" && mv "$tmp" $FILE_COMPONENT && \
    jq '.properties.metadata.properties.runtime_type = input' $URL_COMPONENT utils/component_runtime.json > "$tmp" && mv "$tmp" $URL_COMPONENT && \
    #ERRORING sed -i "s/metadata.metadata.runtime_type/\"DATA_SCIENCE_PIPELINES\"/g" /opt/app-root/share/jupyter/labextensions/@elyra/pipeline-editor-extension/static/lib_index_js.*.js && \
    # Remove Elyra logo from JupyterLab because this is not a pure Elyra image \
    #ERRORING sed -i 's/widget\.id === \x27jp-MainLogo\x27/widget\.id === \x27jp-MainLogo\x27 \&\& false/' /opt/app-root/share/jupyter/labextensions/@elyra/theme-extension/static/lib_index_js.*.js && \
    # Replace Notebook's launcher, "(ipykernel)" with Python's version 3.x.y \
    sed -i -e "s/Python.*/$(python --version | cut -d '.' -f-2)\",/" /opt/app-root/share/jupyter/kernels/python3/kernel.json && \
    # Remove default Elyra runtime-images \
    rm /opt/app-root/share/jupyter/metadata/runtime-images/*.json && \
    # Fix permissions to support pip in Openshift environments \
    chmod -R g+w /opt/app-root/lib/python3.11/site-packages && \
    fix-permissions /opt/app-root -P

# Copy Elyra runtime-images definitions and set the version
COPY runtime-images/ /opt/app-root/share/jupyter/metadata/runtime-images/

# Configure Kernels
COPY kernels/ /opt/app-root/src/.local/share/jupyter/kernels/
# Replace Notebook's launcher, "(ipykernel)" with Python's version 3.x.y
RUN sed -i -e "s/Python.*/$(python --version | cut -d '.' -f-2)\",/" /opt/app-root/share/jupyter/kernels/python3/kernel.json

WORKDIR /opt/app-root/src

ENTRYPOINT ["start-notebook.sh"]
