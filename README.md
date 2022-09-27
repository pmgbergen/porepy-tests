# porepy-tests

This repository contains a collection of files that are necessary to run automated system-level tests for [porepy](https://github.com/pmgbergen/porepy). The tests are run using [Jenkins](https://www.jenkins.io) in a local server.

The repository contains two types of system-level tests:
* Functional tests
* Performance tests

Structure-wise, the repository is divided into three main directories
* **dockerfiles** containing the DockerFiles necessary to build the PorePy images.
* **jenkinsjobs** containing the Jenkins jobs stored as bash scripts.
* **tests** containing the functional and performance tests to be tested.
