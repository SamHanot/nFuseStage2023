module "vpc" {
  source             = "../modules/vpc"
  region             = var.region
  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_cidrs       = var.public_cidrs
  private_app_cidrs  = var.private_app_cidrs
  private_data_cidrs = var.private_data_cidrs
}

module "nat_gateway" {
  source                  = "../modules/nat_gateway"
  internet_gateway        = module.vpc.internet_gateway
  vpc_id                  = module.vpc.vpc_id
  public_subnet_ids       = module.vpc.public_subnet_ids
  private_app_subnet_ids  = module.vpc.private_app_subnet_ids
  private_data_subnet_ids = module.vpc.private_data_subnet_ids
}

module "app_load_balancer_security_group" {
  source              = "../modules/security_group"
  security_group_name = "app-load-balancer"
  vpc_id              = module.vpc.vpc_id
  rules               = [{ type = "ingress", port = 80, cidr_blocks = ["0.0.0.0/0"], security_groups = null }]
}

module "network_load_balancer_security_group" {
  source              = "../modules/security_group"
  security_group_name = "net-load-balancer"
  vpc_id              = module.vpc.vpc_id
  rules               = [{ type = "ingress", port = 9001, cidr_blocks = null, security_groups = module.app_security_group.security_group_id }]
}

module "app_security_group" {
  source              = "../modules/security_group"
  security_group_name = "application"
  vpc_id              = module.vpc.vpc_id
  rules = [{ type = "ingress", port = 9000, cidr_blocks = null, security_groups = module.app_load_balancer_security_group.security_group_id },
    { type = "ingress", port = 9001, cidr_blocks = null, security_groups = module.search_security_group.security_group_id },
    { type = "ingress", port = 9003, cidr_blocks = null, security_groups = module.app_security_group.security_group_id }
  ]
}

module "search_security_group" {
  source              = "../modules/security_group"
  security_group_name = "search"
  vpc_id              = module.vpc.vpc_id
  rules = [
    { type = "ingress", port = 9001, cidr_blocks = null, security_groups = module.network_load_balancer_security_group.security_group_id },
    { type = "ingress", port = 9002, cidr_blocks = null, security_groups = module.search_security_group.security_group_id },
  ]
}

module "data_security_group" {
  source              = "../modules/security_group"
  security_group_name = "data"
  vpc_id              = module.vpc.vpc_id
  rules = [
    { type = "ingress", port = 5432, cidr_blocks = null, security_groups = module.app_security_group.security_group_id },
    { type = "ingress", port = 5432, cidr_blocks = null, security_groups = module.search_security_group.security_group_id }
  ]

}

module "app_load_balancer" {
  source             = "../modules/load_balancer"
  load_balancer_name = var.app_lb_name
  lb_type            = var.app_lb_type
  subnet_ids         = module.vpc.public_subnet_ids
  vpc_id             = module.vpc.vpc_id
  security_groups_id = [module.app_load_balancer_security_group.security_group_id]
  listener_port      = var.app_lb_listener_port
  target_ids         = module.app_EC2.instance_ids
  target_port        = var.app_lb_target_port
  protocol           = var.app_lb_protocol
}

module "network_load_balancer" {
  source             = "../modules/load_balancer"
  load_balancer_name = var.net_lb_name
  lb_type            = var.net_lb_type
  subnet_ids         = module.vpc.private_app_subnet_ids
  vpc_id             = module.vpc.vpc_id
  security_groups_id = [module.network_load_balancer_security_group.security_group_id]
  listener_port      = var.net_lb_listener_port
  target_ids         = module.search_EC2.instance_ids
  target_port        = var.net_lb_target_port
  protocol           = var.net_lb_protocol
}

module "app_EC2" {
  source            = "../modules/EC2"
  instance_type     = var.app_instance_type
  security_group_id = [module.app_security_group.security_group_id]
  subnet_ids        = module.vpc.private_app_subnet_ids
  instance_count    = var.app_instance_count
  file_path         = var.app_file_path
  #db_write_endpoint = module.aurora.rds_writer_endpoint
}


module "aurora" {
  source                  = "../modules/aurora"
  project_name            = var.project_name
  postgres_username       = var.postgres_username
  postgres_password       = var.postgres_password
  cluster_instances_count = length(module.vpc.private_data_subnet_ids)
  private_subnets         = module.vpc.private_data_subnet_ids
  security_groups         = [module.data_security_group.security_group_id]
}

module "search_EC2" {
  source            = "../modules/EC2"
  instance_type     = var.search_instance_type
  security_group_id = [module.search_security_group.security_group_id]
  subnet_ids        = module.vpc.private_app_subnet_ids
  instance_count    = var.search_instance_count
  file_path         = var.search_file_path
  #db_write_endpoint = module.aurora.rds_writer_endpoint
}
