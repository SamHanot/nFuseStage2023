include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../..//sonarqube"
}

inputs = {
  #vpc
region             = "eu-west-1"
project_name       = "sonarqube-dev"
vpc_cidr           = "10.0.0.0/16"
public_cidrs       = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
private_app_cidrs  = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
private_data_cidrs = ["10.0.6.0/24", "10.0.7.0/24", "10.0.8.0/24"]

#app load balancer
app_lb_name          = "dev-external"
app_lb_type          = "application"
app_lb_listener_port = 80
app_lb_target_port   = 9003
app_lb_protocol      = "HTTP"

#net load balancer
net_lb_name          = "dev-internal"
net_lb_type          = "network"
net_lb_listener_port = 9001
net_lb_target_port   = 9001
net_lb_protocol      = "TCP"

#app EC2
app_instance_type  = "t2.large"
app_instance_count = 2
app_file_path      = "../modules/EC2/sonarqube_compute_engine.sh"
app_name           = "app"

#search EC2
search_instance_type  = "t2.large"
search_instance_count = 3
search_file_path = "../modules/EC2/sonarqube_search_engine.sh"
search_name           = "search"

#aurora
postgres_username = "SonarQube"
postgres_password = "Password123"

}