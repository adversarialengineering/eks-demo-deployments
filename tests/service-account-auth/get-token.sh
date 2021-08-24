#!/bin/bash

kubectl config set-credentials sa-user --token=$(kubectl get secret $1 -o jsonpath={.data.token} | base64 -d)
