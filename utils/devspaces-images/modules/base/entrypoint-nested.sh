#!/usr/bin/env bash

if [ ! -d "${HOME}" ]
then
  mkdir -p "${HOME}"
fi

mkdir -p ${HOME}/.config/containers
(echo 'unqualified-search-registries = [';echo '  "registry.access.redhat.com",';echo '  "registry.redhat.io",';echo '  "docker.io"'; echo ']'; echo 'short-name-mode = "permissive"') > ${HOME}/.config/containers/registries.conf

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

/usr/libexec/podman/catatonit -- "$@"
