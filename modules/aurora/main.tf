
resource "aws_rds_cluster" "cluster" {
  engine                 = "postgres"
  engine_mode            = "provisioned"
  engine_version         = "14.6"
  cluster_identifier     = var.project_name
  master_username        = var.postgres_username
  master_password        = var.postgres_password
  availability_zones     = var.availability_zones
  vpc_security_group_ids = var.security_groups

  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  backup_retention_period = 7
  preferred_backup_window = "03:00-04:00"

  #for multi-az:
  db_cluster_instance_class = "db.r6gd.large"
  storage_type              = "io1"
  allocated_storage         = 100
  iops                      = 1000
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.cluster_instances_count
  identifier         = "${var.project_name}-${count.index}"
  cluster_identifier = aws_rds_cluster.cluster.id
  instance_class     = aws_rds_cluster.cluster.instance_class
  engine             = aws_rds_cluster.cluster.engine
  engine_version     = aws_rds_cluster.cluster.engine_version

  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnets
}
