#!/bin/bash

gradle clean build
podman build -t examples-bookinfo-reviews-v2:1.1.0 .
podman tag localhost/examples-bookinfo-reviews-v2:1.1.0 default-route-openshift-image-registry.apps.ocp4poc.example.com/bookinfo/examples-bookinfo-reviews-v2:1.1.0
podman login -u jblaine -p $(oc whoami -t) default-route-openshift-image-registry.apps.ocp4poc.example.com --tls-verify=false
podman push --tls-verify=false default-route-openshift-image-registry.apps.ocp4poc.example.com/bookinfo/examples-bookinfo-reviews-v2:1.1.0
