# create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# use data source to get all avalablility zones in region => threw permission error, so we use default variable instead
#data "aws_availability_zones" "available_zones" {}

# create public subnet 
resource "aws_subnet" "public" {
  count                   = length(var.public_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  #availability_zone       = data.aws_availability_zones.available_zones.names[count.index]

  tags = {
    Name = "public subnet az${count.index + 1}"
  }
}
/*
# create public subnet az2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet az2"
  }
}
*/
# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public route table"
  }
}

# associate public subnets to "public route table"
resource "aws_route_table_association" "public_subnet_route_table_association" {
  count          = length(var.public_cidrs)
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public_route_table.id
}
/*
# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}
*/
# create private app subnet
resource "aws_subnet" "private_app_subnet" {
  count                   = length(var.private_app_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_app_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  #availability_zone       = data.aws_availability_zones.available_zones.names[count.index]

  tags = {
    Name = "private app subnet az${count.index + 1}"
  }
}
/*
# create private app subnet az2
resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_app_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "private app subnet az2"
  }
}
*/
# create private data subnet
resource "aws_subnet" "private_data_subnet" {
  count                   = length(var.private_data_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_data_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  #availability_zone       = data.aws_availability_zones.available_zones.names[count.index]

  tags = {
    Name = "private data subnet az${count.index + 1}"
  }
}
/*
# create private data subnet az2
resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_data_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "private data subnet az2"
  }
}
*/


