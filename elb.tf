resource "aws_elb" "webserver" {
  name               = "webserver-elb-asg"
  security_groups    = [aws_security_group.elb-sg.id]
  availability_zones = ["us-west-2a", "us-west-2b"]

  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  # Adding a listener for incoming HTTP requests.
  listener {
    lb_port           = var.elb_port
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }
}