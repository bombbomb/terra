resource "aws_iam_role_policy" "app_deployment_policy_db" {
    name = "${var.prefix}-AppDeploymentPolicy-DB"
    role = "${aws_iam_role.app_deployment_role.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "rds:RestoreDBClusterFromSnapshot",
                "rds:DescribeDBSubnetGroups",
                "rds:CreateDBSubnetGroup",
                "rds:CreateDBInstance",
                "rds:DescribeDBInstances",
                "rds:ModifyDBClusterParameterGroup",
                "rds:ModifyDBClusterSnapshotAttribute",
                "rds:DeleteDBCluster",
                "rds:DeleteDBInstance",
                "rds:DescribeDBClusterSnapshotAttributes",
                "rds:AddTagsToResource",
                "rds:DescribeDBClusterParameters",
                "rds:DeleteDBSnapshot",
                "rds:DeleteDBSubnetGroup",
                "rds:DeleteDBClusterSnapshot",
                "rds:ListTagsForResource",
                "rds:CreateDBSecurityGroup",
                "rds:RestoreDBInstanceFromDBSnapshot",
                "rds:CreateDBCluster",
                "rds:DescribeDBClusterSnapshots",
                "rds:ModifyDBCluster",
                "rds:CreateDBClusterSnapshot",
                "rds:RemoveTagsFromResource",
                "rds:DescribeDBClusters",
                "rds:DescribeDBClusterParameterGroups",
                "rds:ModifyDBSubnetGroup"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
