# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet az1 
resource "aws_eip" "eip_for_nat_gateway" {
  count  = length(var.public_subnet_ids)
  domain = "vpc"

  tags = {
    Name = "nat gateway az${count.index + 1} eip"
  }
}
# create nat gateway in public subnet az1
resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.public_subnet_ids)
  allocation_id = aws_eip.eip_for_nat_gateway.*.id[count.index]
  subnet_id     = var.public_subnet_ids[count.index]

  tags = {
    Name = "nat gateway az${count.index + 1}"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [var.internet_gateway]
}

# create private route table az1 and add route through nat gateway az1
resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id
  count  = length(var.public_subnet_ids)
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.*.id[count.index]
  }

  tags = {
    Name = "private route table az${count.index + 1}"
  }
}

# associate private app subnet az1 with private route table az1
resource "aws_route_table_association" "private_app_subnet_route_table_association" {
  count          = min(length(var.public_subnet_ids), length(var.private_app_subnet_ids))
  subnet_id      = var.private_app_subnet_ids[count.index]
  route_table_id = aws_route_table.private_route_table.*.id[count.index]
}

# associate private data subnet az1 with private route table az1
resource "aws_route_table_association" "private_data_subnet_route_table_association" {
  count          = min(length(var.public_subnet_ids), length(var.private_data_subnet_ids))
  subnet_id      = var.private_data_subnet_ids[count.index]
  route_table_id = aws_route_table.private_route_table.*.id[count.index]
}

