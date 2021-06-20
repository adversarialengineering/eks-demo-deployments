data "aws_eks_cluster" "cluster" {
  name = module.cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
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
      instance_type = var.wg_instance_type
      asg_max_size  = var.wg_asg_max_size
    }
  ]
}
