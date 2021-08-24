#!/bin/bash

kubectl delete configmap -n kube-system aws-auth
kubectl delete clusterroles.rbac.authorization.k8s.io --all
kubectl -n kube-system delete roles --all
