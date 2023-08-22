terraform {
  backend "s3" {
    bucket  = "sonarquberemotestate"
    key     = "sonarqube/${path_relative_to_include()}/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}
#kijken wat algemeen is 