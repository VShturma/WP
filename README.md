# Overview
This is a [Terraform](https://www.terraform.io/)-based template that provisions a WordPress application in AWS. The  [Cloudformation template](https://github.com/aws-samples/aws-refarch-wordpress), as well as [AWS guide](https://d1.awsstatic.com/whitepapers/wordpress-best-practices-on-aws.pdf) were used as a reference.
Furthermore, this implementation is utilizing [Terratest](https://github.com/gruntwork-io/terratest) to perform the integration tests.

## Installation
1. Install Terraform according to the [guide](https://learn.hashicorp.com/terraform/getting-started/install.html)
2. An existing AWS account is required.
3. Inside your AWS account it is recommended to create a separate IAM user with Access keys only (no access to the console).
4. Assign below policies to the IAM user. Be advised though, that you are assigning these at your own risk and more granular permissions might be considered:
    - AmazonRDSFullAccess
    - AmazonEC2FullAccess
    - AWSMarketplaceImageBuildFullAccess
    - IAMFullAccess
    - ElasticLoadBalancingFullAccess
    - AmazonVPCFullAccess
    - AmazonElasticFileSystemFullAccess
    - AmazonRoute53FullAccess
    - CloudWatchEventsFullAccess
    - SSMTerraformPolicy. This is a custom policy which looks like this:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ssm:PutParameter",
                "ssm:LabelParameterVersion",
                "ssm:DeleteParameter",
                "ssm:DescribeParameters",
                "ssm:RemoveTagsFromResource",
                "ssm:AddTagsToResource",
                "ssm:ListTagsForResource",
                "ssm:GetParametersByPath",
                "ssm:GetParameters",
                "ssm:GetParameter",
                "ssm:DeleteParameters"
            ],
            "Resource": "*"
        }
    ]
}    
```
5. Configure your Terraform environment with the appropriate AWS access credentials. More on this could be found [here](https://www.terraform.io/docs/providers/aws/index.html)
6. Download the repository content to the Terraform machine.

