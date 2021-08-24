.PHONY: delete_alb_controller
delete_alb_controller:
	kubectl delete -f kubernetes/alb/alb-ingress-controller.yaml
	kubectl delete -f kubernetes/alb/service-account.yaml
	kubectl delete -f kubernetes/alb/rbac-role.yaml

# https://aws.amazon.com/blogs/opensource/kubernetes-ingress-aws-alb-ingress-controller/
.PHONY: install_alb_controller
install_alb_controller: 
	kubectl apply -f kubernetes/alb/rbac-role.yaml
	sed "s#ALB_ROLE_ARN#${role_arn}#g" kubernetes/alb/service-account.yaml | kubectl apply -f -
	sed "s/# - --cluster-name=devCluster/- --cluster-name=${cluster_name}/g" kubernetes/alb/alb-ingress-controller.yaml | kubectl apply -f -

ALB_POD="$(shell kubectl get po -n kube-system | egrep -o alb-ingress[a-zA-Z0-9-]+)"
.PHONY: alb_status
alb_status:
	kubectl logs -n kube-system $(ALB_POD)

# https://docs.aws.amazon.com/eks/latest/userguide/calico.html
.PHONY: install_calico
install_calico:
	kubectl apply -f kubernetes/calico/calico-operator.yaml
	kubectl apply -f kubernetes/calico/calico-crs.yaml

# https://github.com/aws/aws-eks-best-practices/tree/master/projects/enable-irsa/src
.PHONY: enable_aws_node_irsa
enable_aws_node_irsa:
	sed -i.bck "s#ROLE_ARN#${role_arn}#g" kubernetes/aws-node-irsa/service-account-patch.yaml
	kubectl patch serviceaccount aws-node -n kube-system --patch-file kubernetes/aws-node-irsa/service-account-patch.yaml
	mv kubernetes/aws-node-irsa/service-account-patch.yaml.bck kubernetes/aws-node-irsa/service-account-patch.yaml
	kubectl patch daemonset/aws-node -n kube-system --patch-file kubernetes/aws-node-irsa/daemonset-patch.yaml

.PHONY: install_os_cmd_injection_app
install_os_cmd_injection_app:
	cd helm && helm install os-cmd-injection ./os-cmd-injection

.PHONY: upgrade_os_cmd_injection_app
upgrade_os_cmd_injection_app:
	cd helm && helm upgrade os-cmd-injection ./os-cmd-injection


.PHONY: unistall_os_cmd_injection_app
uninstall_os_cmd_injection_app:
	cd helm && helm uninstall os-cmd-injection
