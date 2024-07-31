#!/bin/bash

ANACONDA_HOME=/opt/anaconda3

source $ANACONDA_HOME/bin/activate base
conda env remove -n ilab -y
conda create -n ilab -y

source $ANACONDA_HOME/bin/activate ilab
source /opt/anaconda3/bin/activate ilab
echo "Current Anaconda Environment = $CONDA_DEFAULT_ENV"

conda install python -y
pip cache remove llama_cpp_python
pip install instructlab

ilab --version
