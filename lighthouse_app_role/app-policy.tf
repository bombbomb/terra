resource "aws_iam_role_policy" "app_policy" {
    name = "${var.prefix}-AppPolicy"
    role = "${aws_iam_role.app_role.id}"
    
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1468377977000",
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.fully_qualified_domain}",
        "arn:aws:s3:::${var.fully_qualified_domain}/*",
        "arn:aws:s3:::${var.prefix}-*",
        "arn:aws:glacier:*:*:vaults/${var.prefix}-*",
        "arn:aws:dynamodb:*:*:table/${var.prefix}-*",
        "arn:aws:rds:*:*:db:${var.prefix}-*",
        "arn:aws:rds:*:*:snapshot:${var.prefix}-*",
        "arn:aws:rds:*:*:cluster:${var.prefix}-*",
        "arn:aws:rds:*:*:cluster-snapshot:${var.prefix}-*",
        "arn:aws:rds:*:*:og:${var.prefix}-*",
        "arn:aws:rds:*:*:pg:${var.prefix}-*",
        "arn:aws:rds:*:*:cluster-pg:${var.prefix}-*",
        "arn:aws:rds:*:*:secgrp:${var.prefix}-*",
        "arn:aws:rds:*:*:subgrp:${var.prefix}-*",
        "arn:aws:rds:*:*:es:${var.prefix}-*",
        "arn:aws:es:*:*:domain/${var.prefix}-*",
        "arn:aws:lambda:*:*:function:${var.prefix}-*",
        "arn:aws:lambda:*:*:event-source-mappings:${var.prefix}-*",
        "arn:aws:apigateway:*::/*",
        "arn:aws:sqs:*:*:${var.prefix}-*",
        "arn:aws:sns:*:*:${var.prefix}-*",
        "arn:aws:logs:*:*:log-group:/apps/${var.prefix}-*",
        "arn:aws:events:*:*:rule/${var.prefix}-*",
        "arn:aws:route53:::hostedzone/${aws_route53_zone.app_zone.zone_id}"
      ]
    },
    {
        "Sid": "Stmt1468377977001",
        "Effect": "Allow",
        "Action": [
            "ecs:DeregisterContainerInstance",
            "ecs:DiscoverPollEndpoint",
            "ecs:Poll",
            "ecs:RegisterContainerInstance",
            "ecs:Submit*",
            "ecs:StartTelemetrySession",
            "ecr:GetAuthorizationToken",
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "acm:ListCertificates",
            "acm:DescribeCertificate",
            "route53:ListHostedZones",
            "route53:GetHostedZone",
            "route53:ListResourceRecordSets",
            "route53:ListHostedZonesByName",
            "route53:GetChange",
            "ec2:Describe*",
            "cloudfront:*",
            "sns:Subscribe",
            "sns:Unsubscribe",
            "sns:GetEndpointAttributes",
            "sns:GetPlatformApplicationAttributes",
            "sns:GetSMSAttributes",
            "sns:GetSubscriptionAttributes",
            "sns:GetTopicAttributes",
            "elasticache:*",
            "ec2:CreateNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface"
        ],
        "Resource": [
            "*"
        ]
    },
    {
        "Sid": "Stmt1468377977002",
        "Action": [
            "cloudwatch:PutMetricData"
        ],
        "Effect": "Allow",
        "Resource": "*"
    },
    {
        "Sid": "Stmt1468377977003",
        "Action": [
            "logs:Create*",
            "logs:PutLogEvents"
        ],
        "Effect": "Allow",
        "Resource": [
            "arn:aws:logs:*:*:log-group:/aws/ecs/${var.prefix}",
            "arn:aws:logs:*:*:log-group:/aws/ecs/${var.prefix}*",
            "arn:aws:logs:*:*:log-group:/aws/lambda/${var.prefix}",
            "arn:aws:logs:*:*:log-group:/aws/lambda/${var.prefix}-*"
        ]
    },
    {
        "Action": [
            "iam:GetRole",
            "iam:PassRole"
        ],
        "Effect": "Allow",
        "Resource": [
            "arn:aws:iam::${var.app_account_id}:role/${var.prefix}-AppRole",
            "arn:aws:iam::${var.app_account_id}:role/${var.prefix}-ECSRole",
            "arn:aws:iam::${var.app_account_id}:role/${var.prefix}-CustomRole"
        ]
    }
  ]
}
EOF
}
