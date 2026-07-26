# ---------------------------------------------
# VPC
# ---------------------------------------------

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  
  tags = {
    Name = "Main-VPC"
  }
}

# ---------------------------------------------
# SUBNETS
# ---------------------------------------------

# Create a subnet for monitoring script(s)
resource "aws_subnet" "monitoring_sub" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.monitoring_sub_cidr
  availability_zone = var.monitoring_az
  map_public_ip_on_launch = true

  tags = {
    Name = "monitor-public-subnet"
  }
}

# Create a subnet for webapp
resource "aws_subnet" "webapp_sub" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.webapp_sub_cidr
  availability_zone = var.webapp_az
  map_public_ip_on_launch = true

  tags = {
    Name = "webapp-sub"
  }
}

# ---------------------------------------------
# INTERNET GATEWAY
# ---------------------------------------------

resource "aws_internet_gateway" "gateway_1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Primary-Gateway"
  }
}

# ---------------------------------------------
# ROUTE TABLES
# ---------------------------------------------

resource "aws_route_table" "igw_route" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway_1.id
  }

  tags = {
    Name = "IGW-Route"
  }
}


# ---------------------------------------------
# ROUTE TABLE ASSOCIATIONS
# ---------------------------------------------

resource "aws_route_table_association" "monitoring_association" {
  subnet_id = aws_subnet.monitoring_sub.id
  route_table_id = aws_route_table.igw_route.id
}

resource "aws_route_table_association" "webapp_association" {
  subnet_id = aws_subnet.webapp_sub.id
  route_table_id = aws_route_table.igw_route.id

}


# ---------------------------------------------
# SECURITY GROUPS
# ---------------------------------------------

# create ssh security group
resource "aws_security_group" "sec_group_ssh" {
  vpc_id = aws_vpc.main.id
  name = "allow-ssh"

    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [var.ssh_allowed_cidr]
    }

    egress{
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "Security-Group-SSH"
    }
}

# create http security group
resource "aws_security_group" "sec_group_http" {
  vpc_id = aws_vpc.main.id
  name = "allow-HTTP"

    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "Security-Group-HTTP"
    }
}


# ---------------------------------------------
# EC2 INSTANCES
# ---------------------------------------------

# Define default ami (most recent) for instance resources 
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"]  # Canonical's official AWS account ID
}

# create security VM
resource "aws_instance" "security_vm" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.monitoring_sub.id
  vpc_security_group_ids = [aws_security_group.sec_group_ssh.id]
  key_name = "AWS-network-provisioning-key"

  user_data = <<-EOF
    #!/bin/bash
    apt update
    apt install -y git
    git clone https://github.com/pruettyler/ssh-and-server-health-monitors /home/ubuntu/monitoring-scripts
    chown -R ubuntu:ubuntu /home/ubuntu/monitoring-scripts
  EOF

  tags = {
    Name = "Security-VM"
  }
}


# create webapp VM
resource "aws_instance" "webapp_vm" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.webapp_sub.id
  vpc_security_group_ids = [aws_security_group.sec_group_ssh.id, aws_security_group.sec_group_http.id]
  key_name = "AWS-network-provisioning-key"

  user_data = <<-EOF
    #!/bin/bash
    apt update
    apt install -y nginx
  EOF

  tags = {
    Name = "Webapp-VM"
  }
}