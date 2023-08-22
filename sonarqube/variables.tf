variable "region" {}
variable "project_name" {}
variable "vpc_cidr" {}
variable "public_cidrs" {
  type = list(any)
}
variable "private_app_cidrs" {
  type = list(any)
}
variable "private_data_cidrs" {
  type = list(any)
}

variable "postgres_username" {}
variable "postgres_password" {}

