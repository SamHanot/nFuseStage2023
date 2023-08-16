#vpc
region             = "eu-west-1"
project_name       = "sonarqube"
vpc_cidr           = "10.0.0.0/16"
public_cidrs       = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
private_app_cidrs  = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
private_data_cidrs = ["10.0.6.0/24", "10.0.7.0/24", "10.0.8.0/24"]


#load balancer
load_balancer_name = "external"
target_port = 9000

#EC2
instance_type = "t2.large"

#aurora
postgres_username = "SonarQube"
postgres_password = "Password123"
