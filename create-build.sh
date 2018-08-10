#!/bin/sh

oc process -f build-configs/build-pipeline.yml \
    -p NAMESPACE_BASE='test' -p APP_NAME='api-client' \
    -p GIT_URL='http://gogs-banestes-cicd-tools.apps.rh-consulting-br.com/banestes/api-client' \
    -p JENKINS_FILE='pipelines/Jenkinsfile-Build' \
    | oc apply -n test-img -f -