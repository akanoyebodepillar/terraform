# AWS ELB Configuration

This project demonstrates how to configure an AWS Elastic Load Balancer (ELB) to handle HTTP requests and route them to server instances in an Auto Scaling Group (ASG).

## Configuration Overview

In this setup, the ELB is configured to:
1. Receive HTTP requests on port 80 (the default port for HTTP).
2. Route these requests to the port used by the server instances in the ASG.

## Security Groups

By default, ELB doesn't allow any incoming or outgoing traffic. To enable this, a new security group is added to explicitly allow inbound requests on port 80 and all outbound requests.

We then specify the security group for the ELB by adding the `security_groups` parameter in the configuration.

## ELB Deployment

The ELB will be deployed across all Availability Zones (AZs) where our multiple server instances can run. AWS will automatically:
- Scale the number of load balancer servers up and down based on traffic.
- Handle failover if one of the servers goes down.

This ensures scalability and high availability.

## Listeners

The configuration tells the ELB how to route requests by adding listeners. These listeners specify:
- The port the ELB should listen on (port 80).
- The port to which it should route the requests.

## Health Checks

The ELB is configured to periodically check the health of our EC2 instances. An HTTP health check is set up where the ELB sends an HTTP request every 30 seconds to the root URL (`/`) of each EC2 instance. An instance is marked as healthy if it responds with a `200 OK`.

## DNS Output

Before deploying the load balancer, its DNS name is added as an output. This allows for easy access to the load balancer once it's deployed.

## Example Code

Below is an example of how the configuration might look in code:

```hcl
resource "aws_elb" "webserver" {
  name               = "webserver-elb-asg"
  security_groups    = [aws_security_group.elb-sg.id]
  availability_zones = ["us-east-1a", "us-east-1b"]

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

resource "aws_security_group" "elb-sg" {
  name = "elb-sg"
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.elb_port
    to_port     = var.elb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "elb_dns_name" {
  value       = aws_elb.webserver.dns_name
  description = "The domain name of the load balancer"
}
