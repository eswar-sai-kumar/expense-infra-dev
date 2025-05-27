# 01-VPC

### provider.tf

##### terraform.tfstate file → file that tracks actual infrastructure

If I delete resources manually in AWS, but it exists in terraform.tfstate file

Whenever we perform terraform apply, it checks .tfstate file, if resources are also present in AWS 

then it gives, infra you want to apply are already present in AWS 

###### .lock file → if someone creating infra, others are not allowed to create infra until completion

If 2 persons applying infra, then there is a chance for duplicate infra

##### Remote state (.lockfile + .tfstate)

##### S3 and locking

We use S3 for remote state, dynamoDB for locking

S3 → Create bucket → name(unique like DNS) → create bucket

dynamoDB → tables → cerate table → name → Partition key (LockID) → create table

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
    key    = "expense-dev-vpc"
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

variable "public_subnet_cidrs" {
    default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
    default = ["10.0.11.0/24","10.0.12.0/24"]
}

variable "database_subnet_cidrs" {
    default = ["10.0.21.0/24","10.0.22.0/24"]
}

variable "is_peering_required" {
  default = true
}
```

### vpc.tf

```
module "vpc" {
    #source = "../terraform-aws-vpc"
    source = "git::https://github.com/eswar-sai-kumar/terraform-aws-vpc.git"
    project_name = var.project_name
    common_tags = var.common_tags
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    database_subnet_cidrs = var.database_subnet_cidrs
    is_peering_required = var.is_peering_required
}
```

### parameters.tf

AWS SSM Parameter Store is like a key-value storage in AWS where you can safely keep:

🔑 Passwords

🛠️ Configuration values

📦 Version info

🔐 Secrets (encrypted)

apps/servers can securely read values from AWS SSM Parameter Store, in Terraform via a data source.

```
resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/public_subnet_ids"
  type  = "StringList"
  value = join("," ,module.vpc.public_subnet_ids) # converting list to string list
}

#["id1","id2"] terraform format
# id1, id2 -> AWS SSM format
resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/private_subnet_ids"
  type  = "StringList"
  value = join(",",module.vpc.private_subnet_ids) # converting list to string list
}

resource "aws_ssm_parameter" "db_subnet_group_name" {
  name  = "/${var.project_name}/${var.environment}/db_subnet_group_name"
  type  = "String"
  value = module.vpc.database_subnet_group_name
}
```
