provider "aws" {
  region = "us-west-2"
}

resource "aws_launch_template" "asg_webserver" {
  name_prefix   = "webserver"
  image_id      = "ami-0aff18ec83b712f05"
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.webserver.id]
  key_name = "ec2_keypair"
  user_data              = base64encode(file("install_nginx.sh"))
  lifecycle {
    create_before_destroy = true
  }
}