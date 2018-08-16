#!/bin/sh

#BASE_PRJ_NAME=$1
JENKINS_PRJ_NAME=cicd-tools
JENKINS_USER=jenkins
JENKINS_PWD=banestes

invalid() {
    echo "Error: Invalid parameters!"
    echo
}

usage() {
    echo "$ create-build.sh <base-project-name>"
    echo
    echo "Argumentos:"
    echo
    echo "   base-project-name:  Nome base do projeto a ser criado / atualizado"
    echo
}

if [ "$BASE_PRJ_NAME" == "" ]; then
    invalid
    usage
    exit 1
fi

echo "------------------------------------------------------------------------------------"
echo "- VERIFICANDO PROJETOS                                                             -"
echo "------------------------------------------------------------------------------------"

oc get project "${BASE_PRJ_NAME}-dev" > /dev/null

if [ "$?" == "1" ]; then
    echo "Criando projeto de DEV"
    oc new-project "${BASE_PRJ_NAME}-dev" > /dev/null
fi

oc get project "${BASE_PRJ_NAME}-uat" > /dev/null

if [ "$?" == "1" ]; then
    echo "Criando projeto de UAT"
    oc new-project "${BASE_PRJ_NAME}-uat" > /dev/null
fi

oc get project "${BASE_PRJ_NAME}" > /dev/null

if [ "$?" == "1" ]; then
    echo "Criando projeto de PRD"
    oc new-project "${BASE_PRJ_NAME}" > /dev/null
fi

echo "------------------------------------------------------------------------------------"
echo "- ADICIONANDO POLICIES AOS PROJETOS                                                -"
echo "------------------------------------------------------------------------------------"

oc adm policy add-role-to-user system:image-puller \
    system:serviceaccount:"${BASE_PRJ_NAME}:${APP_NAME}" -n "${BASE_PRJ_NAME}-uat" \
    --rolebinding-name uat-to-prd-role --dry-run \
    -o yaml | oc apply -n "${BASE_PRJ_NAME}-uat" -f -

oc adm policy add-role-to-user admin \
    system:serviceaccount:"${JENKINS_PRJ_NAME}:jenkins" -n "${BASE_PRJ_NAME}"-dev \
    --rolebinding-name jenkins-admin-role --dry-run \
    -o yaml | oc apply -n "${BASE_PRJ_NAME}"-dev -f -

oc adm policy add-role-to-user admin \
    system:serviceaccount:"${JENKINS_PRJ_NAME}:jenkins" -n "${BASE_PRJ_NAME}"-uat \
    --rolebinding-name jenkins-admin-role --dry-run \
    -o yaml | oc apply -n "${BASE_PRJ_NAME}"-uat -f -

oc adm policy add-role-to-user admin \
    system:serviceaccount:"${JENKINS_PRJ_NAME}:jenkins" -n "${BASE_PRJ_NAME}" \
    --rolebinding-name jenkins-admin-role --dry-run \
    -o yaml | oc apply -n "${BASE_PRJ_NAME}" -f -

oc adm policy add-role-to-group view P_IOC_DESENVOLVEDOR -n "${BASE_PRJ_NAME}-dev" \
    --rolebinding-name=role-view-to-dev --dry-run -o yaml | oc apply -n "${BASE_PRJ_NAME}-dev" -f -

oc adm policy add-role-to-group view P_IOC_DESENVOLVEDOR -n "${BASE_PRJ_NAME}-uat" \
    --rolebinding-name=role-view-to-dev --dry-run -o yaml | oc apply -n "${BASE_PRJ_NAME}-uat" -f -

oc adm policy add-role-to-group view P_IOC_DESENVOLVEDOR -n "${BASE_PRJ_NAME}" \
    --rolebinding-name=role-view-to-dev --dry-run -o yaml | oc apply -n "${BASE_PRJ_NAME}" -f -

echo "------------------------------------------------------------------------------------"
echo "- ANOTANDO PROJETOS                                                                -"
echo "------------------------------------------------------------------------------------"

oc annotate ns "${BASE_PRJ_NAME}-dev" openshift.io/node-selector='region=dev' \
    -o yaml --overwrite > /dev/null

oc annotate ns "${BASE_PRJ_NAME}-uat" openshift.io/node-selector='region=uat' \
    -o yaml --overwrite > /dev/null

oc annotate ns "${BASE_PRJ_NAME}" openshift.io/node-selector='region=prd' \
    -o yaml --overwrite > /dev/null

echo "------------------------------------------------------------------------------------"
echo "- CRIANDO SECRETS                                                                  -"
echo "------------------------------------------------------------------------------------"

oc create -o yaml secret generic gogs-secret \
    --from-literal=username=$JENKINS_USER \
    --from-literal=password=$JENKINS_PWD \
    --type=kubernetes.io/basic-auth \
    --dry-run \
    --save-config | oc apply -n "${BASE_PRJ_NAME}-dev" -f -

oc create -o yaml secret generic gogs-secret \
    --from-literal=username=$JENKINS_USER \
    --from-literal=password=$JENKINS_PWD \
    --type=kubernetes.io/basic-auth \
    --dry-run \
    --save-config | oc apply -n "${BASE_PRJ_NAME}-uat" -f -

oc create -o yaml secret generic gogs-secret \
    --from-literal=username=$JENKINS_USER \
    --from-literal=password=$JENKINS_PWD \
    --type=kubernetes.io/basic-auth \
    --dry-run \
    --save-config | oc apply -n "${BASE_PRJ_NAME}" -f -
