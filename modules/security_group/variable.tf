variable "security_group_name" {}
variable "vpc_id" {}
#variable "ingress_cidr" {}
# variable "ingress_security_groups" {
#   default = []
# }
#variable "ingress_port" {}
# variable "egress_port" {
#   default = 0
# }
# variable "egress_cidr" {
#   default = ["0.0.0.0/0"]
# }
# variable "egress_security_groups" {
#     default = []
# }
variable "rules" {
  type = list(object({
    type            = string
    port            = number,
    cidr_blocks     = list(string)
    security_groups = string

  }))
}
