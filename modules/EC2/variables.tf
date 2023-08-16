variable "security_group_id" {
  type = list(string)
}
variable "subnet_ids" {
  type = list(string)
}
variable "instance_type" {}
variable "instance_count" {}
variable "file_path" {}
#variable "db_write_endpoint" {}
