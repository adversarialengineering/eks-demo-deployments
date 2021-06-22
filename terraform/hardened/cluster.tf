data "aws_eks_cluster" "cluster" {
  name = module.cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.cluster.cluster_id
}

data "aws_caller_identity" "current" {}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

resource "aws_kms_key" "eks" {
  description             = "EKS secrets envolope key"
  policy                  = <<EOF
{
    "Version": "2012-10-17",
    "Id": "auto-eks",
    "Statement": [
        {
          "Sid": "Enable IAM policies",
          "Effect": "Allow",
          "Principal": {
            "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
           },
          "Action": "kms:*",
          "Resource": "*"
        },
        {
          "Sid": "Grant EKS service access to use the key",
          "Effect": "Allow",
          "Principal": {
            "AWS": "*"
          },
          "Action": [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:CreateGrant",
            "kms:DescribeKey"
          ],
          "Resource": "*",
          "Condition": {
            "StringLike": {
              "kms:ViaService": [
                  "eks.*.amazonaws.com"
              ]
            }
          }
        }
    ]
} 
EOF
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

module "cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  cluster_endpoint_private_access = var.enable_private_endpoint
  cluster_endpoint_public_access  = var.enable_public_endpoint
  manage_aws_auth                 = var.manage_aws_auth

  worker_groups = [
    {
      instance_type                        = var.wg_instance_type
      asg_desired_capacity                 = var.wg_asg_desired_capacity
      asg_max_size                         = var.wg_asg_max_size
      metadata_http_tokens                 = var.metadata_http_tokens
      metadata_http_put_response_hop_limit = var.metadata_http_hop_limit
    }
  ]

  cluster_enabled_log_types = var.cluster_enabled_log_types

  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks.arn
      resources        = ["secrets"]
    }
  ]
}
