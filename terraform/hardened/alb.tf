module "load_balancer_controller_irsa_role" {
  source = "terraform-aws-modules/iam/aws///modules/iam-role-for-service-accounts-eks"

  create_role = var.load_balancer_controller_irsa_role_arn == "" ? true : false

  role_name                              = "${var.cluster_name}-load-balancer-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.cluster.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "local_file" "alb-service-account" {
  content  = templatefile("${path.module}/templates/aws-load-balancer-controller-service-account.yaml.tpl", { role_arn = var.load_balancer_controller_irsa_role_arn == "" ? module.load_balancer_controller_irsa_role.iam_role_arn : var.load_balancer_controller_irsa_role_arn })
  filename = "${path.module}/aws-load-balancer-controller-service-account.yaml"
}
