#-----modules/iam/main.tf-----

data "aws_iam_policy" "ssm_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "cloudwatch" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

data "aws_iam_policy_document" "ec2-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ssm_role" {
  name = "SSMInstanceRole"
  description = "Allows EC2 instances to call AWS SSM and Cloudwatch services on your behalf"
  assume_role_policy = data.aws_iam_policy_document.ec2-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "ssm_attachment" {
  role = aws_iam_role.ssm_role.name
  policy_arn = data.aws_iam_policy.ssm_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm_cloudwatch_attachment" {
  role = aws_iam_role.ssm_role.name
  policy_arn = data.aws_iam_policy.cloudwatch.arn
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "SSMInstanceProfile"
  role = aws_iam_role.ssm_role.name
}

