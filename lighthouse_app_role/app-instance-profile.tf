resource "aws_iam_instance_profile" "app_instance_profile" {
    name = "${var.prefix}-app-profile"
    role = "${var.prefix}-AppRole"
}