variable "parent_dns" {}
variable "child_full_dns" {}
variable "ingress_dns" {}
variable "ttl" { default = "30" }

data "aws_route53_zone" "main" {
    name = "${var.parent_dns}"
}
resource "aws_route53_zone" "app_zone" {
    name = "${var.child_full_dns}"
}
resource "aws_route53_record" "cname" {
    zone_id = "${data.aws_route53_zone.main.zone_id}"
    name    = "${var.child_full_dns}"
    type    = "CNAME"
    ttl     = "${var.ttl}"
    records = ["${var.ingress_dns}"]
}
output "app_zone_id" {
    value = "${aws_route53_zone.app_zone.zone_id}"
}
