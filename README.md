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
7. Generate a key pair that will be used to access your instances via SSH. The configuration expects to find your public key under the name `ec2_key.pub` in the working directory (default value, can be changed under `ec2_key_path` value in [variables.tf](https://github.com/VShturma/WP/blob/master/variables.tf)).
8. Register a domain name with either Route53 or a third-party service.

## Configuration

The main configuration processes all the variable values and passes them to the corresponding modules. Two most important files involved are [main.tf](https://github.com/VShturma/WP/blob/master/main.tf) and [variables.tf](https://github.com/VShturma/WP/blob/master/variables.tf)

### AWS Resources Created
* Amazon Virtual Private Cloud (VPC)
* Internet Gateway (IGW)
* NAT Gateway (single instance per region or one for each involved Availability Zone (AZ))
* Amazon VPC subnets (public, private and isolated) in all the involved AZs
* Routing tables for public subnets - routing through IGW
* Routing tables for private subnets - routing through NAT Gateway
* VPC Security Groups:
    - BastionSecurityGroup
    - PublicAlbSecurityGroup
    - WebSecurityGroup
    - DatabaseSecurityGroup
    - EfsSecurityGroup
* Network Access Lists (NACLs) for each network
* Bastion Auto Scaling Group (no instances launched by default) - in public subnets
* Web Auto Scaling Group (2 instances launched by default) - in private subnets
* A Key Pair to access the instances via SSH (uploaded from your local filesystem)
* Amazon Elastic Load Balancing (ELB) Application Load Balancer (ALB) - in public subnets
* ALB Target Group with listener on port 80
* Amazon Relational Database Service (Amazon RDS) MySQL instance - in isolated subnet
* Amazon Elastic File System (Amazon EFS) file system - with mount targets in private subnets
* Route53 Public Hosted Zone with a domain name registered earlier.
* Route53 Private Hosted Zone for RDF and EFS endpoints
* AWS Systems Manager (SSM) parameteres, which store sensitive information used during the WordPress installation
* AWS Identity and Access (IAM) role for SSM to be able to manage EC2 instances

### Variables

## Tests

##TO-DO
