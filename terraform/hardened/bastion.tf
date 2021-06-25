resource "aws_key_pair" "bastion" {
  key_name   = var.bastion_admin_key_name
  public_key = var.bastion_admin_public_key
}

module "ec2_bastion" {
  source  = "cloudposse/ec2-bastion-server/aws"
  version = "0.28.0"

  enabled = true

  name                        = "bastion"
  instance_type               = var.bastion_instance_type
  security_groups             = [module.cluster.cluster_primary_security_group_id]
  subnets                     = module.vpc.private_subnets
  user_data                   = var.bastion_user_data
  vpc_id                      = module.vpc.vpc_id
  associate_public_ip_address = var.bastion_associate_public_ip_address
  key_name                    = var.bastion_admin_key_name
  security_group_enabled      = var.bastion_enabled_external_sg
}
