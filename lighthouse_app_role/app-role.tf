resource "aws_iam_role" "app_role" {
    name = "${var.prefix}-AppRole"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "${concat([
                    "ec2.amazonaws.com",
                    "ecs-tasks.amazonaws.com",
                    "lambda.amazonaws.com",
                ],"${var.trust_relationship_roles}")}",
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
