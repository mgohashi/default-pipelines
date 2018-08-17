#!/bin/sh

IMAGE_STREAM='eap-custom-introscope:1.0'
TEMPLATE='openshift//eap-custom-secret'

invalid() {
    echo "Error: Invalid parameters!"
    echo
}

usage() {
    echo "$ create-app-secret.sh"
    echo
    echo "ENV"
    echo
    echo "   BASE_PRJ_NAME:        Nome base do projeto a ser criado / atualizado"
    echo "   APP_NAME:             Nome da aplicacao a ser criada"
    echo "   APP_GIT_URL:          Repositorio GIT"
    echo "   CONFIGMAP_URL_DEV:    (Opcional) URL do arquivo YAML do ConfigMap da aplicação"
    echo "   SECRET_URL_DEV:       (Opcional) URL do arquivo YAML do Secret da aplicação"
    echo "   TOKEN:                Token de autorização da aplicação"
    echo
}

if [ "$BASE_PRJ_NAME" == "" ]; then
    invalid
    usage
    exit 1
fi

if [ "$APP_NAME" == "" ]; then
    invalid
    usage
    exit 1
fi

echo "------------------------------------------------------------------------------------"
echo "- ADICIONANDO PIPELINES                                                            -"
echo "------------------------------------------------------------------------------------"

oc process -f build-configs/build-pipeline.yml \
    -p NAMESPACE_BASE=$BASE_PRJ_NAME -p APP_NAME=$APP_NAME \
    -p APP_GIT_URL=$APP_GIT_URL \
    -p JENKINS_FILE='pipelines/Jenkinsfile-Build' \
    -p CONFIGMAP_URL=$CONFIGMAP_URL_DEV \
    -p SECRET_URL=$SECRET_URL_DEV \
    -p BRANCH='develop/feature' \
    -p IMAGE_STREAM=$IMAGE_STREAM \
    -p TEMPLATE=$TEMPLATE \
    -p TOKEN=$TOKEN \
    | oc apply -n "${BASE_PRJ_NAME}-dev" -f -

oc process -f build-configs/build-pipeline.yml \
    -p NAMESPACE_BASE=$BASE_PRJ_NAME -p APP_NAME=$APP_NAME \
    -p APP_GIT_URL=$APP_GIT_URL \
    -p JENKINS_FILE='pipelines/Jenkinsfile-Build' \
    -p CONFIGMAP_URL=$CONFIGMAP_URL_HML \
    -p SECRET_URL=$SECRET_URL_HML \
    -p BRANCH='release/hotfix' \
    -p IMAGE_STREAM=$IMAGE_STREAM \
    -p TEMPLATE=$TEMPLATE \
    -p TOKEN=$TOKEN \
    -p REPLICAS=$REPLICAS_HML \
    | oc apply -n "${BASE_PRJ_NAME}-uat" -f -

oc process -f build-configs/build-pipeline.yml \
    -p NAMESPACE_BASE=$BASE_PRJ_NAME -p APP_NAME=$APP_NAME \
    -p APP_GIT_URL=$APP_GIT_URL \
    -p JENKINS_FILE='pipelines/Jenkinsfile-Build' \
    -p CONFIGMAP_URL=$CONFIGMAP_URL_PRD \
    -p SECRET_URL=$SECRET_URL_PRD \
    -p BRANCH='master' \
    -p IMAGE_STREAM=$IMAGE_STREAM \
    -p TEMPLATE=$TEMPLATE \
    -p TOKEN=$TOKEN \
    -p REPLICAS=$REPLICAS_PRD \
    | oc apply -n "$BASE_PRJ_NAME" -f -

