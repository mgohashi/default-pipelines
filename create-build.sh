#!/bin/sh

oc process -f build-configs/build-pipeline.yml \
    -p NAMESPACE='test-dev' -p APP_NAME='api-client' \
    -p GIT_URL='http://gogs-banestes-cicd-tools.apps.rh-consulting-br.com/banestes/api-client' \
    -p JENKINS_FILE='pipelines/Jenkinsfile-Build-Dev' \
    | oc apply -n test-dev -f -

oc process -f build-configs/build-pipeline.yml \
    -p NAMESPACE='test-hml' -p APP_NAME='api-client' \
    -p GIT_URL='http://gogs-banestes-cicd-tools.apps.rh-consulting-br.com/banestes/api-client' \
    -p JENKINS_FILE='pipelines/Jenkinsfile-Build-Hml' \
    | oc apply -n test-hml -f -

oc process -f build-configs/build-pipeline.yml \
    -p NAMESPACE='test-hml' -p APP_NAME='api-client' \
    -p GIT_URL='http://gogs-banestes-cicd-tools.apps.rh-consulting-br.com/banestes/api-client' \
    -p JENKINS_FILE='pipelines/Jenkinsfile-Build-Hotfix' \
    -p SUFIX='-hotfix' | oc apply -n test-hml -f -

oc process -f build-configs/build-pipeline.yml \
    -p NAMESPACE='test-prd' -p APP_NAME='api-client' \
    -p GIT_URL='http://gogs-banestes-cicd-tools.apps.rh-consulting-br.com/banestes/api-client' \
    -p JENKINS_FILE='pipelines/Jenkinsfile-Prd' \
    | oc apply -n test-prd -f -