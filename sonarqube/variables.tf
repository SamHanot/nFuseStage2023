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

variable "app_lb_name" {}
variable "app_lb_type" {}
variable "app_lb_listener_port" {}
variable "app_lb_target_port" {}
variable "app_lb_protocol" {}

variable "net_lb_name" {}
variable "net_lb_type" {}
variable "net_lb_listener_port" {}
variable "net_lb_target_port" {}
variable "net_lb_protocol" {}

variable "app_instance_type" {}
variable "app_instance_count" {}
variable "app_file_path" {}
variable "app_name" {}

variable "search_instance_type" {}
variable "search_instance_count" {}
variable "search_file_path" {}
variable "search_name" {}

variable "postgres_username" {}
variable "postgres_password" {}

