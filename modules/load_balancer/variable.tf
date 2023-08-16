variable "load_balancer_name" {}
variable "public_subnet_ids" {}
variable "vpc_id" {}
variable "security_groups_id" {}
variable "target_ids" {
  type = list(string)
}
variable "target_port" {}
