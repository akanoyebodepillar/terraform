variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["BodePillar", "MatthewOdunjo", "AkinTinubu"]
}

# Creating IAM Users
# Create IAM users, a group named "devops", and attach an S3 access policy to the group. Add the users to the group using a loop.
resource "aws_iam_user" "devops_users" {
  count = length(var.user_names)
  name  = element(var.user_names, count.index)
}

# Creating IAM Group
resource "aws_iam_group" "devops_group" {
  name = "devops"
}

# Attaching Policy to Group
resource "aws_iam_group_policy" "devops_group_policy" {
  group = aws_iam_group.devops_group.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

# Adding Users to Group
resource "aws_iam_user_group_membership" "devops_user_group_membership" {
  count  = length(var.user_names)
  user   = element(aws_iam_user.devops_users[*].name, count.index)
  groups = [aws_iam_group.devops_group.name]
}


#Create an IAM role with an assume role policy for Lambda and attach an S3 access policy to the role
# Creating IAM Role
resource "aws_iam_role" "s3_access_role" {
  name = "LambdaS3"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attaching Policy to Role
resource "aws_iam_role_policy" "s3_access_role_policy" {
  role = aws_iam_role.s3_access_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}
