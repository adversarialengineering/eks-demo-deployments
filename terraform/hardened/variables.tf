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
