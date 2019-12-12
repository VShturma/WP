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
6. Target AWS region should also be configured in the Ansible playbook file.
7. Download the repository content to the Terraform machine.
8. Generate a key pair that will be used to access your instances via SSH. The configuration expects to find your public key under the name `ec2_key.pub` in the working directory (default value, can be changed under `ec2_key_path` value in [variables.tf](https://github.com/VShturma/WP/blob/master/variables.tf)).
9. Register a domain name with either Route53 or a third-party service.

## Modules
### VPC module
https://github.com/VShturma/WP/blob/development/modules/vpc

This module creates the below set of resources:
* Amazon Virtual Private Cloud (VPC)
* Amazon VPC subnets (public, private and isolated) in all the involved AZs
* Internet Gateway (IGW)
* NAT Gateway (single instance per region or one for each involved Availability Zone (AZ))
* Routing tables for public subnets - routing through IGW
* Routing tables for private subnets - routing through NAT Gateway
* Routing tables for isolated subnets - local traffic only
* VPC Security Groups:
    - BastionSecurityGroup
    - PublicAlbSecurityGroup
    - WebSecurityGroup
    - DatabaseSecurityGroup
    - EfsSecurityGroup
* Network Access Lists (NACLs) for each network type (public, private and isolated)

### EC2 module
https://github.com/VShturma/WP/tree/development/modules/compute
This module creates the below set of resources:
* Amazon Elastic Load Balancing (ELB) Application Load Balancer (ALB) - in public subnets
* ALB Target Group with listener on port 80
* Bastion Auto Scaling Group (ASG) - in public subnets
* Web Auto Scaling Group (ASG) - in private subnets
* A Key Pair to access the instances via SSH (uploaded from your local filesystem)

### Main
The main configuration processes all the variable values and passes them to the corresponding modules. Two most important files involved are [main.tf](https://github.com/VShturma/WP/blob/master/main.tf) and [variables.tf](https://github.com/VShturma/WP/blob/master/variables.tf)

List of the parameteres passed to the [VPC Module](https://github.com/VShturma/WP/blob/development/modules/vpc):
* VPC name (default value - `WP`)
* VPC IPv4 CIDR block (default value - `10.100.0.0/16`)
* VPC tenancy (default value - `default`)
* Number of AZs for provisioning (default value - `2`)
* IPv4 CIDR blocks for subnets (default values:
    - `10.100.1.0/24, 10.100.2.0/24, 10.100.3.0/24, 10.100.4.0/24, 10.100.5.0/24, 10.100.6.0/24` for public subnets
    - `10.100.11.0/24, 10.100.12.0/24, 10.100.13.0/24, 10.100.14.0/24, 10.100.15.0/24, 10.100.16.0/24` for private subnets
    - `10.100.21.0/24, 10.100.22.0/24, 10.100.23.0/24, 10.100.24.0/24, 10.100.25.0/24, 10.100.26.0/24` for isolated subnets)
* Number of NAT Gateways - could be either 1 per AZ or 1 per region (default value - `1 per AZ`)
* SSH access IPs - a list of client IPs which are allowed to connect to Bastion Host via SSH (default value - `0.0.0.0/0`)
* Web access IPs - a list of client IPs which are allowed to connect to ALB via HTTP (default value - `0.0.0.0/0`)


List of the parameteres passed to the [EC2 Module](https://github.com/VShturma/WP/tree/development/modules/compute):
* Security Group for ALB (imported from VPC module)
* Subnets for ALB (imported from VPC module)
* ID of the target VPC (imported from VPC module)
* Path to a public key for SSH access (default value - `ec2_key.pub`)
* Minimum, maximum and desired number of instances in Bastion ASG (default values - `0`, `1` and `0` respectively)
* Security Group for instances in Bastion ASG (imported from VPC module)
* Subnets for instances in Bastion ASG (imported from VPC module)
* Type of instances in Bastion ASG (default value - `t2.micro`)
* Name tag for instances in Bastion ASG (default value - `Bastion`)
* Minimum and desired number of instances in Web ASG (default values - `0` and `2` respectively)
* Maximum number of instances in Web ASG which is equal to the number of AZs involved (imported from VPC module)
* Security Group for instances in Web ASG (imported from VPC module)
* Subnets for instances in Web ASG (imported from VPC module)
* Type of instances in Web ASG (default value - `t2.micro`)
* Instance profile for instances in Web ASG (imported from SSM module)
* Name tag for instances in Web ASG (default value - `Web`)

## Configuration

### AWS Resources Created
* Amazon Relational Database Service (Amazon RDS) MySQL instance - in isolated subnet
* Amazon Elastic File System (Amazon EFS) file system - with mount targets in private subnets
* Route53 Public Hosted Zone with a domain name registered earlier.
* Route53 Private Hosted Zone for RDF and EFS endpoints
* AWS Systems Manager (SSM) parameteres, which store sensitive information used during the WordPress installation
* AWS Identity and Access (IAM) role for SSM to be able to manage EC2 instances

### Variables

## Tests

## TO-DO
