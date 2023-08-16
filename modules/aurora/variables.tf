variable "project_name" {}
variable "postgres_username" {}
variable "postgres_password" {}
variable "availability_zones" {
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}
variable "cluster_instances_count" {}
variable "private_subnets" {}
variable "security_groups" {

}
