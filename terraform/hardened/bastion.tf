data "aws_iam_policy_document" "ec2_service_assume" {
  version = "2012-10-17"

  statement {
    sid = "1"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_service_assume" {
  count              = var.create_ssm_profile ? 1 : 0
  name_prefix        = "ec2-service-assume"
  assume_role_policy = data.aws_iam_policy_document.ec2_service_assume.json
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  count      = var.create_ssm_profile ? 1 : 0
  role       = aws_iam_role.ec2_service_assume[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_core" {
  count      = var.create_ssm_profile ? 1 : 0
  role       = aws_iam_role.ec2_service_assume[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_core" {
  count       = var.create_ssm_profile ? 1 : 0
  name_prefix = "ec2-ssm-core"
  role        = aws_iam_role.ec2_service_assume[0].name
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t2.micro"
  iam_instance_profile        = var.create_ssm_profile ? aws_iam_instance_profile.ec2_ssm_core[0].name : var.iam_instance_profile
  associate_public_ip_address = false
  vpc_security_group_ids      = [module.cluster.node_security_group_id]
  subnet_id                   = module.vpc.private_subnets[0]

  depends_on = [module.cluster, module.vpc]
}

output "bastion_host" {
  value = aws_instance.this.arn
}
