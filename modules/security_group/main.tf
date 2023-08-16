# create security group for http/https access on port 80/443
resource "aws_security_group" "security_group" {
  name        = var.security_group_name
  description = "enable http/https access on port 80/443"
  vpc_id      = var.vpc_id

  # ingress {
  #   description     = "${var.ingress_port} access"
  #   from_port       = var.ingress_port
  #   to_port         = var.ingress_port
  #   protocol        = "tcp"
  #   cidr_blocks     = var.ingress_cidr
  #   security_groups = var.ingress_security_groups
  # }

  /*
  ingress {
    description     = "https access"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = var.https_cidr
    security_groups = var.https_security_groups
  }
*/

  # egress {
  #   count = length(var.egress)
  #   from_port       = var.egress[count.index].port
  #   to_port         = var.egress[count.index].port
  #   protocol        = "tcp"
  #   cidr_blocks     = var.egress[count.index].cidr
  #   security_groups = var.egress[count.index].security_groups
  # }

  tags = {
    Name = "${var.security_group_name} security group"
  }
}

resource "aws_security_group_rule" "rule" {
  count                    = length(var.rules)
  type                     = var.rules[count.index].type
  from_port                = var.rules[count.index].port
  to_port                  = var.rules[count.index].port
  protocol                 = "tcp"
  cidr_blocks              = var.rules[count.index].cidr_blocks
  security_group_id        = aws_security_group.security_group.id
  source_security_group_id = var.rules[count.index].security_groups
}
