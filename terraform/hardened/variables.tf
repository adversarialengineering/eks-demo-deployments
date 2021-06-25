variable "unique_suffix" {}

variable "provider_role" {
  default = ""
}

variable "sts_duration" {
  default = 3600
}

variable "region" {
  default = "eu-west-1"
}

variable "cluster_name" {
  default = "eks-threat-modelling"
}

variable "cluster_version" {
  default = "1.19"
}

variable "env" {
  default = "dev"
}

variable "wg_instance_type" {
  default = "m4.large"
}

variable "wg_asg_max_size" {
  default = 5
}

variable "wg_asg_desired_capacity" {
  default = 2
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_azs" {
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  type    = list(string)
}

variable "private_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  type    = list(string)
}

variable "public_subnet_cidrs" {
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  type    = list(string)
}

variable "enable_nat_gateway" {
  default = true
}

variable "single_nat_gateway" {
  default = true
}

variable "one_nat_gateway_per_az" {
  default = true
}

variable "enable_vpn_gateway" {
  default = false
}

variable "map_public_ips" {
  default = false
}

variable "enable_private_endpoint" {
  default = true
}

variable "enable_public_endpoint" {
  default = false
}

variable "manage_aws_auth" {
  default = false
}

variable "metadata_http_tokens" {
  default = "required"
}

variable "metadata_http_hop_limit" {
  default = 1
}

variable "cluster_enabled_log_types" {
  type    = list(string)
  default = ["audit", "authenticator"]
}

variable "bastion_enabled" {
  default = true
}

variable "bastion_ssm_enabled" {
  default = true
}

variable "bastion_instance_type" {
  default = "t2.micro"
}

variable "bastion_user_data_base64" {
  default = ""
}

variable "bastion_user_data" {
  default = []
}

variable "bastion_user_data_template" {
  default = "user_data.tpl"
}

variable "bastion_associate_public_ip_address" {
  default = false
}

variable "bastion_monitoring" {
  default = false
}

variable "bastion_root_block_device_volume_size" {
  default = 20
}


variable "bastion_admin_public_key" {
}

variable "bastion_admin_key_name" {
  default = "bastion-admin-key"
}

variable "bastion_enabled_external_sg" {
  default = false
}
