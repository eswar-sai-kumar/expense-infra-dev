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
    Component = "web-alb"
  }
}

variable "zone_name" {
  default = "eswarsaikumar.site"
}