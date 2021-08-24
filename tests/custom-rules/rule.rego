package main
violation[msg] {
    module := input.module[name]
    module.source == "terraform-aws-modules/eks/aws"
    not module.cluster_endpoint_public_access == false
    msg := {
        "publicId": "CUSTOM-123",
        "title": "Public endpoint enabled on the terraform eks module",
        "type": "custom",
        "severity": "high",
        "msg": sprintf("module[%s].cluster_endpoint_public_access", [name]),
    }
}

