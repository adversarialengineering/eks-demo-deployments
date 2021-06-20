provider "aws" {
  assume_role {
    role_arn         = var.provider_role
    duration_seconds = var.sts_duration
  }
}
