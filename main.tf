resource "aws_lb" "main" {
  subnets         = ["${var.subnets}"]
  security_groups = ["${compact(split(",",var.lb_sg_id))}"]

  internal	  = "${var.internal}"
  load_balancer_type = "${var.lb_type}"

  tags {
    workspace = "${terraform.workspace}"
  }
}

resource "aws_lb_target_group" "http" {
  count    = "${var.lb_type == "network" ? 0 : 1 }"
  port     = 80
  name     = "${var.cluster_name}-${var.shortname}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
 
  health_check {
     healthy_threshold   = 2
     interval            = 15
     path 		= "${var.health_uri}"
     timeout             = 10
     unhealthy_threshold = 2
     # 301 because nginx will redirect to https
     matcher             = "200,301"
  }
}

resource "aws_lb_target_group" "tcp" {
  count    = "${var.lb_type == "network" ? 1 : 0 }"
  port     = 80
  name     = "${var.cluster_name}-${var.shortname}"
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"
  target_type = "ip"
 
  health_check {
     interval            = 30
     protocol            = "TCP"
  }
}
 
resource "aws_lb_listener" "http" {

  load_balancer_arn = "${aws_lb.main.arn}"
  port              = "80"
  protocol          = "${var.lb_type == "network" ? "TCP" : "HTTP"}"

  depends_on        = [ "aws_lb.main"]
 
  default_action {
    target_group_arn = "${var.lb_type == "network" ? join("",aws_lb_target_group.tcp.*.id): join("",aws_lb_target_group.http.*.id) }"
    type             = "forward"
  }
 
}
 
resource "aws_lb_listener" "https" {
  count    = "${var.ssl_enabled == 1 ? 1 : 0}"

  load_balancer_arn = "${aws_lb.main.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.ssl_arn}"
  depends_on        = [ "aws_lb.main"]
 
  default_action {
    target_group_arn = "${aws_lb_target_group.http.id}"
    type             = "forward"
  }
} 
