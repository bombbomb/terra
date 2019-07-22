variable "parent_dns" {}
variable "child_full_dns" {}
variable "ttl" { default = "30" }
data "aws_route53_zone" "main" {
    name = "${var.hosted_zone}"
}
resource "aws_route53_zone" "app_zone" {
    name = "${var.child_full_dns}"
}
resource "aws_route53_record" "cname" {
    zone_id = "${aws_route53_zone.main.zone_id}"
    name    = "${var.child_full_dns}"
    type    = "CNAME"
    ttl     = "${var.ttl}"
}
output "app_zone_id" {
    value = "${aws_rotue53_zone.app_zone.zone_id}"
}
