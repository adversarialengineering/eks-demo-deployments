variable "iam_user_arn" {
  type = string
}

resource "aws_iam_role" "test_role" {
  name = "eks-demo-ci-deleteme"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "${var.iam_user_arn}"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test_attach" {
  role       = aws_iam_role.test_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
