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
      identifiers = ["ec2.amazonaws.com"]
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

resource "aws_iam_policy" "ssm_send_comand_policy" {
  name = "SSMSendComandPolicy"
  
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ssm:SendCommand",
            "Effect": "Allow",
            "Resource": [
                "arn:aws:ec2:${var.aws_region}:*:instance/*"
            ],
            "Condition": {
                "StringEquals": {
                    "ec2:ResourceTag/*": [
                        "${var.web_instance_name_tag}"
                    ]
                }
            }
        },
        {
            "Action": "ssm:SendCommand",
            "Effect": "Allow",
            "Resource": [
                "arn:aws:ssm:${var.aws_region}:*:document/AWS-ApplyAnsiblePlaybooks"
            ]
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "events-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ssm_send_comand_role" {
  name = "SSMSendCommandRole"
  description = "Allows running Ansible Playbooks against EC2 instances"
  assume_role_policy = data.aws_iam_policy_document.events-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "ssm_send_command_attachment" {
  role = aws_iam_role.ssm_send_comand_role.name
  policy_arn = aws_iam_policy.ssm_send_comand_policy.arn
}

