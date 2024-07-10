provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "train_Server" {
  ami           = "ami-0604d81f2fd264c7b"
  instance_type = "t2.micro"

  tags = {
    Name = "train-instance"
  }
}
