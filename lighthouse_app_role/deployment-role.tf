resource "aws_iam_role" "app_deployment_role" {
    name = "${var.prefix}-AppDeploymentRole"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${var.server_account_id}:root",
                    "arn:aws:iam::${var.main_account_id}:root"
                ]
            },
            "Effect": "Allow"
        }
    ]
}
EOF
}
