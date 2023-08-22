remote_state {
  backend = "s3"
  config = {
    bucket  = "sonarquberemotestate"
    key     = "sonarqube/${path_relative_to_include()}/terraform.tfstate"
    region  = "eu-west-1"
    encrypt        = true
  }
}
#kijken wat algemeen is 