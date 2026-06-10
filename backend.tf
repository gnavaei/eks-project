terraform {
  backend "s3" {
    bucket = "eks-project-tfstate-gi"
    key    = "eks-project/terraform.tfstate"
    region = "eu-west-2"
  }
}