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

# create public subnet 
resource "aws_subnet" "public" {
  count                   = length(var.public_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet az${count.index + 1}"
  }
}

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

# create private app subnet
resource "aws_subnet" "private_app_subnet" {
  count                   = length(var.private_app_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_app_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private app subnet az${count.index + 1}"
  }
}

# create private data subnet
resource "aws_subnet" "private_data_subnet" {
  count                   = length(var.private_data_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_data_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private data subnet az${count.index + 1}"
  }
}



