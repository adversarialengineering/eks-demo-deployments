#!/bin/bash

kubectl --kubeconfig .kubeconfig delete configmap -n kube-system aws-auth
kubectl --kubeconfig .kubeconfig delete clusterroles.rbac.authorization.k8s.io --all
kubectl --kubeconfig .kubeconfig -n kube-system delete roles --all
