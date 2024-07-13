resource "aws_autoscaling_group" "asg-webserver" {
  launch_template {
    id      = aws_launch_template.asg_webserver.id
    version = "$Latest"
  }

  availability_zones = ["us-west-2a", "us-west-2b"]
  min_size             = 2
  max_size             = 5

  load_balancers       = [aws_elb.webserver.name]
  health_check_type    = "ELB"

  tag {
    key                 = "Name"
    value               = "webserver-asg"
    propagate_at_launch = true
  }
}
