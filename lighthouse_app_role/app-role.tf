data "aws_iam_policy_document" "app_role_policy_document" {
    statement {
        actions = ["sts.AssumeRole"]
        principals = {
            type = "Service"
            identifiers = ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com", "lambda.amazonaws.com"]
        }
        principals = {
            type = "AWS"
            identifiers = "${concat("${var.trust_relationship_roles}","${list("arn:aws:iam::${var.server_account_id}:root", "arn:aws:iam::${var.main_account_id}:root")}")}"
        }
    }
}

resource "aws_iam_role" "app_role" {
    name = "${var.prefix}-AppRole"
    assume_role_policy = "${data.aws_iam_policy_document.app_role_policy_document.json}"
}
