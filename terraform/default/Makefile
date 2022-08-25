CLUSTER_NAME=
ALB_SERVICE_ACCOUNT_CONFIG=aws-load-balancer-controller-service-account.yaml
EKS_HELM_CHARTS=https://aws.github.io/eks-charts

ifndef CLUSTER_NAME 
$(error CLUSTER_NAME is not set)
endif

.PHONY: deploy
deploy:
	terraform init
	terraform plan -out=tfplan -var="cluster_name=$(CLUSTER_NAME)"
	terraform apply tfplan

.PHONY: delete
delete:
	terraform init
	terraform plan -destroy -out=tfplan -var="cluster_name=$(CLUSTER_NAME)"
	terraform apply tfplan

.kubeconfig:
	aws eks update-kubeconfig --name $(CLUSTER_NAME) --kubeconfig .kubeconfig

export KUBECONFIG = .kubeconfig

# https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
.PHONY: configure
configure: .kubeconfig
	kubectl apply -f $(ALB_SERVICE_ACCOUNT_CONFIG)
	helm repo add eks $(EKS_HELM_CHARTS)
	helm repo update
	helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
		-n kube-system \
		--set clusterName=$(CLUSTER_NAME) \
		--set serviceAccount.create=false \
		--set serviceAccount.name=aws-load-balancer-controller


2048_full.yaml:
	curl -o 2048_full.yaml https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.3/docs/examples/2048/2048_full.yaml

.PHONY: test
test: .kubeconfig 2048_full.yaml
	kubectl apply -f 2048_full.yaml
	sleep 3
	kubectl get ingress ingress-2048 \
	    -n game-2048
	sleep 3
	aws elbv2 describe-load-balancers

.PHONY: clean_test
clean_test: .kubeconfig
	kubectl delete -f 2048_full.yaml

.PHONY: service_auth_token_disclosure
service_auth_token_disclosure: .kubeconfig
	kubectl apply -f ../../tests/service-account-auth/roleBinding.yaml
	kubectl apply -f ../../tests/service-account-auth/serviceAccount.yaml
	../../tests/service-account-auth/get-token.sh

