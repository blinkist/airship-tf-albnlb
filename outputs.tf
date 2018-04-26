output "lb_arn" {
  value = "${aws_lb.main.arn}"
}

output "lb_default_target_group" {
  value = "${var.lb_type == "network" ? join("",aws_lb_target_group.tcp.*.id) : join("",aws_lb_target_group.http.*.id)}"
}

output "lb_listener_arn" {
  value = "${aws_lb_listener.http.id}"
}

output "lb_listener_arn_https" {
  value = "${join("", aws_lb_listener.https.*.id)}"
}
