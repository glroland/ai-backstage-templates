#!/bin/bash

ANACONDA_HOME=/opt/anaconda3
VENV_HOME=~/venv
CUDA_HOME=/usr/local/cuda

if test -d $ANACONDA_HOME; then
    echo "Using Anaconda Managed Python Environment..."

    source $ANACONDA_HOME/bin/activate base
    conda env remove -n ilab -y
    conda create -n ilab -y

    source $ANACONDA_HOME/bin/activate ilab
    source /opt/anaconda3/bin/activate ilab

    conda install python=3.11 -y

    PENV=$CONDA_DEFAULT_ENV

elif test -d $VENV_HOME; then
    echo "Using Python Virtutal Environment..."
    PENV=$VENV_HOME

else
    echo "ERROR: No virtual environment exists!"
    exit
fi

python --version
echo "Virtual Environment = $PENV"
echo

echo "Removing LLama.CPP from Cache"
pip cache remove llama_cpp_python
echo

echo "Installing InstructLab..."

if [ "$(uname)" == "Darwin" ]; then
    echo "Mac OSX Detected"
    pip install instructlab[mps]

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Linux Detected"

    if test -d $CUDA_HOME; then
        echo "CUDA Detected"
        pip install instructlab[cuda] \
            -C cmake.args="-DLLAMA_CUDA=on" \
            -C cmake.args="-DLLAMA_NATIVE=off"

    else
        echo "CUDA Not Found"
        pip install instructlab[cpu] \
            --extra-index-url=https://download.pytorch.org/whl/cpu \
            -C cmake.args="-DLLAMA_NATIVE=off"

    fi

else
    echo "ERROR: OS Not Recognized!"
    exit
fi

ilab --version
