data "aws_availability_zones" "available" {
}

locals {
  cluster_name = "${var.cluster_name}-${var.unique_suffix}"
}
