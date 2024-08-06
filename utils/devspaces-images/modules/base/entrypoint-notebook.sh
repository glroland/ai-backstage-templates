#!/usr/bin/env bash
set -x

if [ ! -d "${HOME}" ]
then
  mkdir -p "${HOME}"
fi

mkdir -p ${HOME}/.config/containers
(echo 'unqualified-search-registries = [';echo '  "registry.access.redhat.com",';echo '  "registry.redhat.io",';echo '  "docker.io"'; echo ']'; echo 'short-name-mode = "pe
rmissive"') > ${HOME}/.config/containers/registries.conf

if ! whoami &> /dev/null
then
  if [ -w /etc/passwd ]
  then
    echo "${USER_NAME:-user}:x:$(id -u):0:${USER_NAME:-user} user:${HOME}:/bin/bash" >> /etc/passwd
    echo "${USER_NAME:-user}:x:$(id -u):" >> /etc/group
  fi
fi
USER=$(whoami)
START_ID=$(( $(id -u)+1 ))
echo "${USER}:${START_ID}:2147483646" > /etc/subuid
echo "${USER}:${START_ID}:2147483646" > /etc/subgid

if [ ! -f ${HOME}/.zshrc ]
then
  (echo "HISTFILE=${HOME}/.zsh_history"; echo "HISTSIZE=1000"; echo "SAVEHIST=1000"; echo "PATH=$PATH:.") > ${HOME}/.zshrc
fi

echo "PS1='%B%F{red}[%F{yellow}%n%F{green}@%F{blue}%~%F{red}]%(?.%F{green}.%F{red})>%b%f '" >> ${HOME}/.zshrc

if [ ! -f ${HOME}/venv/bin/activate ]
then
  python3.11 -m venv ${HOME}/venv
fi
echo "source ${HOME}/venv/bin/activate" >> ${HOME}/.zshrc

source ${HOME}/.zshrc



function start_process() {
    trap stop_process TERM INT

    echo "Running command: $@"
    "$@" &

    PID=$!
    wait $PID
    trap - TERM INT
    wait $PID
    STATUS=$?
    exit $STATUS
}

function stop_process() {
    kill -TERM $PID
}

# Set the elyra config on the right path
jupyter elyra --generate-config
cp /opt/app-root/bin/utils/jupyter_elyra_config.py /opt/app-root/src/.jupyter/

# create the elyra runtime directory if not present
if [ ! -d $(jupyter --data-dir)/metadata/runtimes/ ]; then
  mkdir -p $(jupyter --data-dir)/metadata/runtimes/
fi
# Set elyra runtime config from volume mount
if [ "$(ls -A /opt/app-root/runtimes/)" ]; then
  cp -r /opt/app-root/runtimes/..data/*.json $(jupyter --data-dir)/metadata/runtimes/
fi

# Environment vars set for accessing ssl_sa_certs and sa_token
# export PIPELINES_SSL_SA_CERTS="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
export KF_PIPELINES_SA_TOKEN_ENV="/var/run/secrets/kubernetes.io/serviceaccount/token"
export KF_PIPELINES_SA_TOKEN_PATH="/var/run/secrets/kubernetes.io/serviceaccount/token"
# Environment vars set for accessing following dependencies for air-gapped enviroment
export ELYRA_BOOTSTRAP_SCRIPT_URL="file:///opt/app-root/bin/utils/bootstrapper.py"
export ELYRA_PIP_CONFIG_URL="file:///opt/app-root/bin/utils/pip.conf"
export ELYRA_REQUIREMENTS_URL="file:///opt/app-root/bin/utils/requirements-elyra.txt"



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

# Start the JupyterLab notebook
start_process jupyter lab ${NOTEBOOK_PROGRAM_ARGS} \
    --ServerApp.ip=0.0.0.0 \
    --ServerApp.allow_origin="*" \
    --ServerApp.open_browser=False \
    --allow-root

/usr/libexec/podman/catatonit -- "$@"

