
terraform {
  backend "s3" {
    bucket  = "sonarquberemotestate"
    key     = "sonarqube/dev/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}

