#!/bin/bash

SECRET_NAME=$(kubectl get serviceaccount github-integration -o jsonpath={.secrets[0].name})
CLUSTER=$(kubectl config view -o jsonpath={.clusters[0].name})
kubectl config set-credentials sa-user --token=$(kubectl get secret $SECRET_NAME -o jsonpath={.data.token} | base64 -d)
kubectl config set-context disclosed/eks-demo --cluster=$CLUSTER --user=sa-user
kubectl config use-context disclosed/eks-demo
