#
# Container Build Process
#
FROM registry.access.redhat.com/ubi9/python-311:9.5-1745330958 as base

# HuggingFace repo identifier should be passed into the build process (i.e. 'sentence-transformers/all-mpnet-base-v2')
ARG MODEL_REPO=""

USER root

# Install python dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Download model files from HuggingFace
COPY src/* .
RUN mkdir /models
RUN python download_model.py ${MODEL_REPO} --output_dir=/models


#
# Final Model Car Image
#
FROM registry.access.redhat.com/ubi9/ubi-micro:9.5-1745845480

COPY --from=base /models /models

USER 1001
