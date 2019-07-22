resource "aws_iam_role_policy" "app_deployment_policy" {
  name = "${var.prefix}-AppDeploymentPolicy"
  role = "${aws_iam_role.app_deployment_role.id}"

   policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "elasticloadbalancing:CreateTargetGroup",
            "elasticloadbalancing:ModifyTargetGroup",
            "elasticloadbalancing:ModifyTargetGroupAttributes",
            "elasticloadbalancing:DeleteTargetGroup",
            "elasticloadbalancing:CreateLoadBalancer",
            "elasticloadbalancing:DeleteLoadBalancer",
            "elasticloadbalancing:ModifyLoadBalancerAttributes",
            "elasticloadbalancing:CreateListener",
            "elasticloadbalancing:ModifyListener",
            "elasticloadbalancing:DeleteListener",
            "elasticloadbalancing:SetSecurityGroups",
            "elasticloadbalancing:SetSubnets"
        ],
        "Resource": [
            "*"
        ]
    },
    {
        "Sid": "CreateDestroyLaunchConfigurations",
        "Effect": "Allow",
        "Action": [
            "autoscaling:CreateLaunchConfiguration",
            "autoscaling:DeleteLaunchConfiguration"
        ],
        "Resource": [
            "arn:aws:autoscaling:us-east-1:${var.app_account_id}:launchConfiguration:*:launchConfigurationName/${var.prefix}-*"
        ]
    },
    {
        "Sid": "CreateLaunchTemplates",
        "Effect": "Allow",
        "Action": [
            "ec2:CreateLaunchTemplateVersion"
        ],
        "Resource": "*",
        "Condition": {
            "StringEquals": {
                "aws:RequestTag/AppPrefix": "${var.prefix}"
            }
        }
    },
    {
        "Sid": "ManageLaunchTemplates",
        "Effect": "Allow",
        "Action": "*",
        "Resource": [
            "arn:aws:ec2:*:*:launch-template",
            "arn:aws:ec2:*:*:launch-template/*"
        ],
        "Condition": {
            "StringEquals": {
                "aws:ResourceTag/AppPrefix": "${var.prefix}"
            }
        }
    },
    {
        "Sid": "LaunchInstancesGeneralStuff",
        "Effect": "Allow",
        "Action": "ec2:RunInstances",
        "Resource": [
            "arn:aws:ec2:*:*:key-pair/*",
            "arn:aws:ec2:*::snapshot/*",
            "arn:aws:ec2:*:*:security-group/*",
            "arn:aws:ec2:*:*:placement-group/*",
            "arn:aws:ec2:*:*:network-interface/*",
            "arn:aws:ec2:*::image/*"
        ]
    },
    {
        "Sid": "LaunchInstancesOnlyInstancesTagged",
        "Effect": "Allow",
        "Action": [
            "ec2:RunInstances"
        ],
        "Resource": [
            "arn:aws:ec2:*:*:instance/*",
            "arn:aws:ec2:*:*:volume/*"
        ],
        "Condition": {
            "StringEquals": {
                "aws:RequestTag/AppPrefix": "${var.prefix}"
            }
        }
    },
    {
        "Sid": "ControlTaggedInstancesOnly",
        "Effect": "Allow",
        "Action": [
            "ec2:RebootInstances",
            "ec2:StartInstances",
            "ec2:StopInstances",
            "ec2:TerminateInstances"
        ],
        "Resource": [
            "arn:aws:ec2:*:*:instance/*"
        ],
        "Condition": {
            "StringEquals": {
                "ec2:ResourceTag/AppPrefix": "${var.prefix}"
            }
        }
    },
    {
        "Sid": "ControlTaggedSGOnly",
        "Effect": "Allow",
        "Action": [
            "ec2:AuthorizeSecurityGroupEgress",
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:RevokeSecurityGroupEgress",
            "ec2:RevokeSecurityGroupIngress",
            "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
            "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
            "ec2:DeleteSecurityGroup"
        ],
        "Resource": [
            "*"
        ],
        "Condition": {
            "StringEquals": {
                "ec2:ResourceTag/AppPrefix": "${var.prefix}"
            }
        }
    },
    {
        "Sid": "CreateTaggedSGOnly",
        "Effect": "Allow",
        "Action": [
            "ec2:CreateSecurityGroup"
        ],
        "Resource": "*"
    },
    {
        "Sid": "CreateTaggedASG",
        "Effect": "Allow",
        "Action": [
            "autoscaling:CreateAutoScalingGroup"
        ],
        "Resource": "*",
        "Condition": {
            "StringEquals": {
                "aws:RequestTag/AppPrefix": "${var.prefix}"
            }
        }
    },
    {
        "Sid": "ManageTaggedASG",
        "Effect": "Allow",
        "Action": [
            "autoscaling:CreateAutoScalingGroup",
            "autoscaling:UpdateAutoScalingGroup",
            "autoscaling:DeleteAutoScalingGroup"
        ],
        "Resource": "*",
        "Condition": {
            "StringEquals": {
                "autoscaling:ResourceTag/AppPrefix": "${var.prefix}"
            }
        }
    },
    {
        "Effect": "Allow",
        "Action": [
            "ec2:CreateTags"
        ],
        "Resource": [
            "arn:aws:ec2:*:*:instance/*",
            "arn:aws:ec2:*:*:volume/*",
            "arn:aws:ec2:*:*:security-group/*"
        ]
    },
    {
        "Sid": "LaunchInDevSubnets",
        "Effect": "Allow",
        "Action": "ec2:RunInstances",
        "Resource": [
            "arn:aws:ec2:*:*:subnet/*"
        ]
    },
    {
        "Sid": "DescribeOnlyResources",
        "Effect": "Allow",
        "Action": [
            "ec2:Describe*",
            "autoscaling:Describe*",
            "elasticloadbalancing:Describe*"
        ],
        "Resource": [
            "*"
        ]
    },
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
        "arn:aws:route53:::hostedzone/${var.route53_app_zone_id}"
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
