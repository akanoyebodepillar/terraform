terraform {
  backend "s3" {
    bucket         = "empiretfstate"
    key            = "s3-cloudfront/terraform.tfstate"
#    dynamodb_table = "terraform-lock"
    region = "us-west-2"
  }
}