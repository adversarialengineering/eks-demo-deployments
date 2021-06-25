data "aws_ami" "default" {
  most_recent = "true"
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

data "template_file" "bastion_user_data" {
  count    = var.bastion_enabled ? 1 : 0
  template = file("${path.module}/${var.bastion_user_data_template}")

  vars = {
    user_data   = join("\n", var.bastion_user_data)
    ssm_enabled = var.bastion_ssm_enabled
  }
}

resource "aws_instance" "bastion" {
  count                       = var.bastion_enabled ? 1 : 0
  ami                         = data.aws_ami.default.id
  instance_type               = var.bastion_instance_type
  user_data                   = length(var.bastion_user_data_base64) > 0 ? var.bastion_user_data_base64 : data.template_file.bastion_user_data[0].rendered
  vpc_security_group_ids      = [aws_security_group.all_worker_mgmt.id]
  associate_public_ip_address = var.bastion_associate_public_ip_address
  subnet_id                   = module.vpc.private_subnets[0]
  monitoring                  = var.bastion_monitoring

  root_block_device {
    encrypted   = true
    volume_size = var.bastion_root_block_device_volume_size
  }
}
