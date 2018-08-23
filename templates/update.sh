#!/bin/sh

# Atualizando o template do FIS
oc create -f templates/fis-app-template.yml -n openshift --dry-run --save-config \
    -o yaml | oc apply -n openshift -f -

# Atualizando o template do EAP
oc create -f templates/eap-app-template.yml -n openshift --dry-run --save-config \
    -o yaml | oc apply -n openshift -f -