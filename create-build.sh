#!/bin/sh

oc process -f build-configs/build-pipeline.yml \
    -p NAMESPACE_BASE='rh-test' -p APP_NAME='api-client' \
    -p GIT_URL='https://gogs-cicd-tools.cloud.sfb/banestes/api-cliente.git' \
    -p JENKINS_FILE='pipelines/Jenkinsfile-Build' \
    | oc apply -n rh-test-dev -f -

oc process -f build-configs/build-pipeline.yml \
    -p NAMESPACE_BASE='rh-test' -p APP_NAME='api-client' \
    -p GIT_URL='https://gogs-cicd-tools.cloud.sfb/banestes/api-cliente.git' \
    -p JENKINS_FILE='pipelines/Jenkinsfile-Build' \
    | oc apply -n rh-test-hml -f -

oc process -f build-configs/build-pipeline.yml \
    -p NAMESPACE_BASE='rh-test' -p APP_NAME='api-client' \
    -p GIT_URL='https://gogs-cicd-tools.cloud.sfb/banestes/api-cliente.git' \
    -p JENKINS_FILE='pipelines/Jenkinsfile-Build' \
    | oc apply -n rh-test -f -