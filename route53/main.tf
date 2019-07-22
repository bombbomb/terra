variable "parent_dns" {}
variable "child_full_dns" {}
variable "ttl" { default = "30" }

data "aws_route53_zone" "main" {
    name = "${var.parent_dns}"
}

resource "aws_route53_zone" "app_zone" {
    name = "${var.child_full_dns}"
}

resource "aws_route53_record" "app_ns" {
    zone_id = "${data.aws_route53_zone.main.zone_id}"
    name    = "${var.child_full_dns}"
    type    = "NS"
    ttl     = "${var.ttl}"

    records = [
        "${aws_route53_zone.app_zone.name_servers.0}",
        "${aws_route53_zone.app_zone.name_servers.1}",
        "${aws_route53_zone.app_zone.name_servers.2}",
        "${aws_route53_zone.app_zone.name_servers.3}",
    ]
}

output "app_zone_id" {
    value = "${aws_route53_zone.app_zone.zone_id}"
}
