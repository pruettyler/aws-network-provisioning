variable "aws_region" {
  description = "AWS region for all resources"
  type = string
  default = "us-west-2"
}

variable "vpc_cidr" {
    description = "CIDR block for vpc"
    type = string
    default = "10.0.0.0/16"
}


variable "monitoring_sub_cidr" {
    description = "CIDR for monitoring subnet"
    type = string 
    default = "10.0.1.0/24"
}


variable "webapp_sub_cidr" {
    description = "CIDR block for webbapp subnet"
    type = string
    default = "10.0.2.0/24"
}

variable "monitoring_az" {
    description = "availability zone"
    type = string
    default = "us-west-2a"
}

variable "webapp_az" {
    description = "availability zone"
    type = string
    default = "us-west-2a"
}

variable "instance_type" {
    description = "EC2 Instance type"
    type = string
    default = "t3.micro"
}

variable "ssh_allowed_cidr" {
    description = "CIDR block for ssh access"
    type = string
    default = "0.0.0.0/0"
}
