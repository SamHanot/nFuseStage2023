variable "load_balancer_name" {}
variable "subnet_ids" {}
variable "lb_type" {}
variable "vpc_id" {}
variable "security_groups_id" {}
variable "listener_port" {}
variable "target_ids" {
  type = list(string)
}
variable "target_port" {}
variable "protocol" {}
