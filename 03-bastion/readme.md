# 03-bastion

A Bastion Host is like a secure doorway to access private servers in a network.

##### Why use a Bastion Host?
Security: Instead of opening doors to all your private servers on the internet, you only open the door to the Bastion Host. From there, you can safely access the private servers.

One Point of Access: It’s a single entry point for admins or users to connect to private servers.

Monitoring: You can monitor and control who’s accessing the private servers since everyone goes through the Bastion Host.

##### How does it work?

You connect to the Bastion Host first (usually through SSH or RDP).

Once connected to the Bastion Host, you can access the private servers inside the network.

##### Example:
Public Network: The Bastion Host is in a public subnet, so you can access it from the internet.

Private Network: Your private servers (like databases or application servers) are in a private subnet and are not exposed to the internet.

Access Flow:

You first log in to the Bastion Host.

From the Bastion Host, you can then connect to the private servers inside the network.

##### In short:
A Bastion Host is like a guard at the gate of a secure building, allowing only authorized people to enter and access the rooms inside.

### provider.tf

```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
  backend "s3" {
    bucket = "s3bucket-project-devops"
    key    = "expense-dev-bastion"
    region = "us-east-1"
    dynamodb_table = "table-project-devops"
  }
}

#provide authentication here
provider "aws" {
  region = "us-east-1"
}
```

### variables.tf

```
variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project = "expense"
    Environment = "dev"
    Terraform = "true"
  }
}
```

### locals.tf

locals.tf → generally used for large expressions, can use variables in this file

variables.tf → You can define variables here, but you cannot use other variables inside these declarations 

```
locals {
  public_subnet_id = element(split(",", data.aws_ssm_parameter.public_subnet_ids.value), 0)
}
```

### data.tf

```
data "aws_ssm_parameter" "bastion_sg_id" {
  name = "/${var.project_name}/${var.environment}/bastion_sg_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}

data "aws_ami" "ami_info" {

    most_recent = true
    owners = ["973714476881"]

    filter {
        name   = "name"
        values = ["RHEL-9-DevOps-Practice"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}
```

### main.tf

```
module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-bastion"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  # convert StringList to list and get first element
  subnet_id = local.public_subnet_id
  ami = data.aws_ami.ami_info.id
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-bastion"
    }
  )
}
```
