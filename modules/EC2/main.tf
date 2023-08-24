data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
#EC2
resource "aws_instance" "ec2_instance" {
  count           = var.instance_count
  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = var.instance_type
  subnet_id       = var.subnet_ids[count.index]
  security_groups = var.security_group_id
  key_name        = "EC2sonarqubeKeyPair"
  user_data       = file(var.file_path)
  tags = {
    Name = "${var.instance_name}-${count.index + 1}"
  }
  # user_data            = base64encode(templatefile(var.file_path, { db_endpoint = var.db_write_endpoint }))
}

