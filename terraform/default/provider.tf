terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.44.0"
    }
  }
}

provider "aws" {
  assume_role {
    role_arn         = var.provider_role
    duration_seconds = var.sts_duration
  }
}
