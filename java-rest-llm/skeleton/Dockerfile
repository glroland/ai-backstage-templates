FROM registry.access.redhat.com/ubi9/openjdk-21-runtime:latest

# By default, listen on port 8080
EXPOSE 8080/tcp

# Set the working directory in the container
WORKDIR /projects

# Copy the content of the local src directory to the working directory
COPY ./target/${{values.artifact_id}}-0.0.1-SNAPSHOT.jar  .

# Specify the command to run on container start
CMD [ "java", "-jar", "${{values.artifact_id}}-0.0.1-SNAPSHOT.jar" ]
