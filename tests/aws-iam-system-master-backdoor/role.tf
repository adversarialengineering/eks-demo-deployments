resource "aws_iam_user" "james_smith" {
  name = "james.smith"
  path = "/users/"
}

resource "aws_iam_access_key" "james_smith" {
  user = aws_iam_user.james_smith.name
}

resource "aws_iam_user_policy_attachment" "test_attach_admin" {
  user       = aws_iam_user.james_smith.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# resource "aws_iam_user_policy_attachment" "test_attach_ro" {
#   user       = aws_iam_user.james_smith.name
#   policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
# }

resource "aws_iam_user_policy_attachment" "test_attach_ssm_access" {
  user       = aws_iam_user.james_smith.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}

resource "aws_iam_policy" "ssm_policy" {
  name        = "ssm_admin_access_policy"
  path        = "/"
  description = "Access to all SSM sessions"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode(
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ssm:StartSession",
                "ssm:TerminateSession",
                "ssm:ResumeSession",
                "ssm:DescribeSessions",
                "ssm:GetConnectionStatus"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        }
    ]
}
)
}

output "james_smith_key_id" {
	value = aws_iam_access_key.james_smith.id
}

output "james_smith_secret_key" {
	value = aws_iam_access_key.james_smith.secret
  sensitive = true
}
