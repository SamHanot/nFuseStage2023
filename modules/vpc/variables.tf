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
variable "availability_zones" {
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}
#variable "public_subnet_az1_cidr" {}
#variable "public_subnet_az2_cidr" {}
#variable "private_app_subnet_az1_cidr" {}
#variable "private_app_subnet_az2_cidr" {}
#variable "private_data_subnet_az1_cidr" {}
#variable "private_data_subnet_az2_cidr" {}



