data "tls_certificate" "cluster" {
  url = module.cluster.cluster_oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = module.cluster.cluster_oidc_issuer_url
}

data "aws_iam_policy_document" "cluster_oidc_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.cluster.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "oidc_restricted" {
  assume_role_policy = data.aws_iam_policy_document.cluster_oidc_policy.json
  name               = "oidc_${local.cluster_name}"
}

resource "aws_iam_policy" "alb" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "load balancer policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = file("${path.module}/templates/iam_policy.json")
}

resource "aws_iam_policy" "alb_additional" {
  name        = "AWSLoadBalancerControllerAdditionalIAMPolicy"
  path        = "/"
  description = "load balancer policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = file("${path.module}/templates/iam_policy_v1_to_v2_additional.json")
}

locals {
  kubernetes_alb_service_account = "system:serviceaccount:kube-system:aws-load-balancer-controller"
}

resource "aws_iam_role" "alb" {
  name               = "AmazonEKSLoadBalancerControllerRole"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${aws_iam_openid_connect_provider.cluster.id}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${aws_iam_openid_connect_provider.cluster.url}:sub": "${local.kubernetes_alb_service_account}"
        }
      }
    }
  ]
}
POLICY
}

resource "local_file" "alb_service_account" {
  content  = templatefile("${path.module}/templates/aws-alb-controller.tpl", { role_arn = aws_iam_role.alb.arn })
  filename = "${path.module}/aws-load-balancer-controller-service-account.yaml"
}

resource "aws_iam_role_policy_attachment" "alb" {
  policy_arn = aws_iam_policy.alb.arn
  role       = aws_iam_role.alb.name
}

resource "aws_iam_role_policy_attachment" "alb_add" {
  policy_arn = aws_iam_policy.alb_additional.arn
  role       = aws_iam_role.alb.name
}
