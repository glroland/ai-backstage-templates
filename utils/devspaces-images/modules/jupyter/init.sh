#!/usr/bin/env bash
set -x

chown 0:0 /requirements.txt

python3.11 -m pip install setuptools
python3.11 -m pip install wheel
python3.11 -m pip install "cython<3.0.0" 
python3.11 -m pip install --no-build-isolation pyyaml==5.4.1
python3.11 -m pip install -r /requirements.txt


