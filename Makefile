.PHONY: delete_alb_controller
delete_alb_controller:
	sed "s/# - --cluster-name=devCluster/- --cluster-name=${cluster_name}/g" kubernetes/alb/alb-ingress-controller.yaml | kubectl delete -f -
	sed "s#ALB_ROLE_ARN#${role_arn}#g" kubernetes/alb/service-account.yaml | kubectl delete -f -
	kubectl delete -f kubernetes/alb/rbac-role.yaml

.PHONY: install_alb_controller
install_alb_controller: 
	kubectl apply -f kubernetes/alb/rbac-role.yaml
	sed "s#ALB_ROLE_ARN#${role_arn}#g" kubernetes/alb/service-account.yaml | kubectl apply -f -
	sed "s/# - --cluster-name=devCluster/- --cluster-name=${cluster_name}/g" kubernetes/alb/alb-ingress-controller.yaml | kubectl apply -f -

.PHONY: install_os_cmd_injection_app
install_os_cmd_injection_app:
	cd helm && helm install os-cmd-injection ./os-cmd-injection

.PHONY: upgrade_os_cmd_injection_app
upgrade_os_cmd_injection_app:
	cd helm && helm upgrade os-cmd-injection ./os-cmd-injection


.PHONY: unistall_os_cmd_injection_app
uninstall_os_cmd_injection_app:
	cd helm && helm uninstall os-cmd-injection
