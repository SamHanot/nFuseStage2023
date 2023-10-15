variable "security_group_name" {}
variable "vpc_id" {}
variable "rules" {
  type = list(object({
    type            = string
    port            = number,
    cidr_blocks     = list(string)
    security_groups = string

  }))
}
