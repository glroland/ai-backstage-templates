#!/usr/bin/env bash

# Load bash libraries
SCRIPT_DIR=/opt/app-root/bin
source ${SCRIPT_DIR}/utils/process.sh

if [ -f "${SCRIPT_DIR}/utils/setup-elyra.sh" ]; then
  source ${SCRIPT_DIR}/utils/setup-elyra.sh
fi

# Initialize notebooks arguments variable
NOTEBOOK_PROGRAM_ARGS=""

# Set default ServerApp.port value if NOTEBOOK_PORT variable is defined
if [ -n "${NOTEBOOK_PORT}" ]; then
    NOTEBOOK_PROGRAM_ARGS+="--ServerApp.port=${NOTEBOOK_PORT} "
fi

# Set default ServerApp.base_url value if NOTEBOOK_BASE_URL variable is defined
if [ -n "${NOTEBOOK_BASE_URL}" ]; then
    NOTEBOOK_PROGRAM_ARGS+="--ServerApp.base_url=${NOTEBOOK_BASE_URL} "
fi

# Set default ServerApp.root_dir value if NOTEBOOK_ROOT_DIR variable is defined
if [ -n "${NOTEBOOK_ROOT_DIR}" ]; then
    NOTEBOOK_PROGRAM_ARGS+="--ServerApp.root_dir=${NOTEBOOK_ROOT_DIR} "
else
    NOTEBOOK_PROGRAM_ARGS+="--ServerApp.root_dir=${HOME} "
fi

# Add additional arguments if NOTEBOOK_ARGS variable is defined
if [ -n "${NOTEBOOK_ARGS}" ]; then
    NOTEBOOK_PROGRAM_ARGS+=${NOTEBOOK_ARGS}
fi

# Ensure containers dir exists
if [ ! -d "$HOME/.config/containers" ]
then
  mkdir -p "$HOME/.config/containers"
fi
(echo 'unqualified-search-registries = [';echo '  "registry.home.glroland.com",';echo '  "registry.access.redhat.com",';echo '  "registry.redhat.io",';echo '  "docker.io"'; echo ']'; echo 'short-name-mode = "pe
rmissive"') > ${HOME}/.config/containers/registries.conf

# Path
echo "PATH=$PATH:." > ${HOME}/.zshrc

# Python virtual environment
if [ ! -f ${HOME}/venv/bin/activate ]
then
  python -m venv $HOME/venv
fi
echo "source $HOME/venv/bin/activate" >> $HOME/.zshrc

# Start the JupyterLab notebook
start_process jupyter lab ${NOTEBOOK_PROGRAM_ARGS} \
    --ServerApp.ip=0.0.0.0 \
    --ServerApp.allow_origin="*" \
    --ServerApp.open_browser=False
