#!/bin/sh

BASE_PRJ_NAME=rh-test

source ./create-projects.sh

APP_NAME=api-cliente
APP_GIT_URL='https://gogs-cicd-tools.cloud.sfb/banestes/api-cliente.git'
CONFIGMAP_URL_DEV='https://${jenkins_user}:${jenkins_pwd}@gogs-cicd-tools.cloud.sfb/banestes/api-cliente/raw/master/configuration/configmap/api-cliente.yml'
CONFIGMAP_URL_HML=$CONFIGMAP_URL_DEV
CONFIGMAP_URL_PRD=$CONFIGMAP_URL_DEV
SECRET_URL_DEV='https://${jenkins_user}:${jenkins_pwd}@gogs-cicd-tools.cloud.sfb/banestes/api-cliente/raw/master/configuration/secret/api-cliente.yml'
SECRET_URL_HML=$SECRET_URL_DEV
SECRET_URL_PRD=$SECRET_URL_DEV
REPLICAS_HML=2
REPLICAS_PRD=2
TOKEN='TESTE'

source ./create-app-fis.sh

APP_NAME=eap-app-rest
APP_GIT_URL='https://gogs-cicd-tools.cloud.sfb/banestes/eap-app-rest.git'
CONFIGMAP_URL_DEV='https://${jenkins_user}:${jenkins_pwd}@gogs-cicd-tools.cloud.sfb/banestes/eap-app-rest/raw/master/configuration/configmap/eap-app-rest.yml  '
CONFIGMAP_URL_HML=$CONFIGMAP_URL_DEV
CONFIGMAP_URL_PRD=$CONFIGMAP_URL_DEV
SECRET_URL_DEV='https://${jenkins_user}:${jenkins_pwd}@gogs-cicd-tools.cloud.sfb/banestes/eap-app-rest/raw/master/configuration/secret/eap-app-rest.yml'
SECRET_URL_HML=$SECRET_URL_DEV
SECRET_URL_PRD=$SECRET_URL_DEV
REPLICAS_HML=2
REPLICAS_PRD=2
TOKEN='TESTE'

source ./create-app-eap.sh