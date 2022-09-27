FROM python:3.9-slim

MAINTAINER PorePy Development Team

# Set porepy directories
ENV PP_HOME /home/porepy
ENV PP_SRC=${PP_HOME}/pp
ENV PP_TST=${POREPY_SRC}/tests

# Set porepy-tests directories
ENV PPTESTS_HOME /home/porepy-tests
ENV PPTESTS_SRC=${PPTESTS_HOME}/pp-tests
ENV PPTESTS_TST=${PPTESTS_SRC}/tests
ENV PPTESTS_FUNCTIONAL=${PPTESTS_TST}/functional

# Step 1: Install git, wget, and bzip2
RUN apt-get update
RUN apt-get install -y wget vim bzip2 git gcc libglu1-mesa libxrender1 libxcursor1 libxft2 libxinerama1 ffmpeg libgl1-mesa-glx libsm6 libxext6

# Step 2: Install porepy requirements (development version)
# Get the PorePy requirements-dev file (we'll install the full development version, the
# overhead in doing so compared to just the run requirements is not too big)
ENV TMP_DIR /tmp
WORKDIR ${TMP_DIR}
RUN wget https://raw.githubusercontent.com/pmgbergen/porepy/develop/requirements-dev.txt
RUN pip install --upgrade pip
RUN pip install -r requirements-dev.txt

# Step 3: Clone the porepy repo (the develop branch by default)
WORKDIR ${PP_HOME}
RUN git clone https://github.com/pmgbergen/porepy.git ${PP_SRC}

# STEP 4: Install porepy
WORKDIR ${PP_SRC}
RUN git checkout develop
RUN pip install --user -e .

# Add porepy home to the pythonpath. This may or may not be necessary.
ENV PYTHONPATH $PP_HOME:$PYTHONPATH

# STEP 5: Clone the porepy-tests repo
WORKDIR ${PPTESTS_HOME}
RUN git clone https://github.com/pmgbergen/porepy-tests.git ${PPTESTS_SRC}
WORKDIR ${PPTESTS_SRC}
RUN git checkout experimental

# Add porepy-tests to the pythonpath. This may or may not be necessary.
ENV PYTHONPATH $PPTESTS_HOME:$PYTHONPATH

# Step 6: Run tests in porepy-tests
# Note that this will run all tests available under the tests folder
WORKDIR ${PPTESTS_FUNCTIONAL}
RUN ls 
RUN pytest -v --cov-report term-missing --cache-clear --disable-warnings --junitxml=reports/results.xml || true

# Step 7: Keep the container running after so that we are allowed to copy the resutls
CMD tail -f /dev/null