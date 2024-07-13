terraform {
  backend "s3" {
    bucket         = "empiretfstate"
    key            = "webserver/terraform.tfstate"
    dynamodb_table = "terraform-lock"
    region = "us-west-2"
  }
}