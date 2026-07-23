# Project Title

"aws-network-provisioning"

## Overview

Provisions a VPC network with two public subnets: one which hosts a webapp (in this version a static html page), and one
which hosts security and server-health monitoring scripts.


## Architecture / Design

Basic AWS infrastructure with VPC, two public subnets, two EC2 instances (one for each subnet), internet gateway, route
table, two security groups: one for http traffic and one for SSH traffic. Each EC2 instance is initialized from the current
version of the aws_ami. There exists separation of outputs, providers, and variables for future iterations and scalability.


## How to Run

Requirements: 
- Terraform version (v1.15.8) 
- AWS CLI installed + configured 
- AWS account with credentials, configured locally
- region: us-west-2 (see var.aws_region)


Setup:
- working AWS credentials
- terraform init (installs the AWS provider)
 
Running:
- terraform plan then terraform apply

Output:
- Running `terraform plan` shows `Plan: 11 to add` if the configuration is valid
- Running `terraform apply` and confirming with `yes` creates all 11 resources
- After apply completes, Terraform prints two public IP addresses:
  `security_vm_public_ip` — use this to SSH into the monitoring server,
  `webapp_vm_public_ip` — load this in a browser to view the static webpage


## Example Output 



## Known Limitations / Future Work
SSH capability is currently open to 0.0.0.0/0 (all IPs) rather than scoped to any specific, allowable range. Right now
this IP is defined as a variable "ssh_allowed_cidr" to enable further development and security scoping. Both EC2
instances are tied to the same availability zone. Thus, in more developed versions, these instances should be dispersed
across multiple AZs as a failsafe against the failure of any one AZ. In future versions, this project will be expanded to
include a private subnet for a database or other backend architecture.


## Author

Jacob Pruett. This script was created as part of a self-directed cloud/DevOps curriculum. 

