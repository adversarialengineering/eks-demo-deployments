# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }

terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    # TODO: update with your own organization
    organization = "snyk-cloud-config"

    workspaces {
      name = "eks-demo-deployments"
    }
  }
}
