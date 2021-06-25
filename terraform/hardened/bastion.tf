module "ec2_bastion" {
  source  = "cloudposse/ec2-bastion-server/aws"
  version = "0.28.0"

  enabled = true

  name                        = "bastion"
  instance_type               = var.bastion_instance_type
  security_groups             = [aws_security_group.all_worker_mgmt.id]
  subnets                     = module.vpc.public_subnets
  user_data                   = var.bastion_user_data
  vpc_id                      = module.vpc.vpc_id
  associate_public_ip_address = var.bastion_associate_public_ip_address
}
