terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    # TODO: update with your own organization
    organization = ""

    workspaces {
      name = "eks-demo-deployments"
    }
  }
}
