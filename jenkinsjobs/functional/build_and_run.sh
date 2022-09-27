#!/bin/bash

# This bash script was adapted from:
# https://medium.com/swlh/build-your-first-automated-test-integration-with-pytest-jenkins-and-docker-ec738ec43955
# by Varun Kumar G, 2020.

REPOSITORY_NAME="jenkins-testing"
JOB_NAME="functional_tests"
IMAGE_NAME="${JOB_NAME}-image"
CONTAINER_NAME="${JOB_NAME}-container"

REPOSITORY_PATH=$WORKSPACE/$REPOSITORY_NAME/
DOCKERFILE_PATH=$REPOSITORY_PATH/dockerfiles/functional/

echo "Checking current Jenkins workspace directory"
pwd

# Remove the container $CONTAINER_NAME if exists (even if it's running!)
# https://stackoverflow.com/questions/62465835/docker-run-command-create-container-if-not-exists
docker ps -a
if [[ $(docker ps -a --filter="name=$CONTAINER_NAME" | grep -w "$CONTAINER_NAME") ]]; then
	 echo "Found existing container: '$CONTAINER_NAME'. I will remove it."
     docker rm --force $CONTAINER_NAME
fi
	 echo "Container name: '$CONTAINER_NAME' is available."

# Remove the image $IMAGE_NAME if exists
docker images
if [[ $(docker images | grep -w "$IMAGE_NAME") ]]; then
    echo "Found existing image: '$IMAGE_NAME'. I will remove it."
    docker rmi $IMAGE_NAME
fi
    echo "Image name: '$IMAGE_NAME' is available."

# Build the image and run the container
echo "Building $IMAGE_NAME and running $CONTAINER_NAME"
cd $REPOSITORY_PATH  || exit # move to the folder where the Dockerfile lives
docker build --no-cache -f $DOCKERFILE_PATH/Dockerfile -t $IMAGE_NAME .  # Build image with no caching
echo "$IMAGE_NAME succesfully build."
docker run -d --name $CONTAINER_NAME $IMAGE_NAME  # run in dettached mode
echo "$CONTAINER_NAME is running."
cd $WORKSPACE || exit; pwd

# Copy results
# For the moment, we will not store pytest results. However, this should be straigthforward.
# The basic idea would be to create a unique tag for each report, e.g.:
#     report_<year>_<month>_<day>_<job_number>
# The file report_22_09_16_68 will then correspond to a report obtained for a test,
# that was generated the 16th of September of 2022. 68 corresponds to the job number, which is
# also a unique identifier. The reports can then be easily stored inside the Jenkins workspace.
# There is also the possibility to store these tests on the cloud, e.g., one-drive or similar.
echo "Copy result.xml into Jenkins container"
rm -rf reports; mkdir reports;
docker cp $CONTAINER_NAME:/home/porepy-tests/pp-tests/tests/reports/results.xml reports/

# Clean-up
echo "Stopping $CONTAINER_NAME"
docker stop $CONTAINER_NAME
echo "Removing $CONTAINER_NAME"
docker rm $CONTAINER_NAME
echo "Removing $IMAGE_NAME"
docker rmi $IMAGE_NAME