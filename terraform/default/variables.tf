variable "provider_role" {
  default = ""
}

variable "sts_duration" {
  default = "3600s"
}

variable "region" {
  default = "eu-west-1"
}

variable "cluster_name" {}

# https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html
variable "cluster_version" {
  default = "1.22"
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

variable "write_kubeconfig" {
  default = false
}

variable "wg_asg_desired_capacity" {
  default = 1
}
