#!/bin/sh

oc create -f templates/fis-app-template.yml -n openshift --dry-run --save-config -o yaml | oc apply -n openshift -f -