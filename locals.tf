locals {
  aws_region   = "eu-north-1"
  cluster_name = "petclinic-automode"
  vpc_name     = "petclinic-vpc"
  vpc_cidr     = "10.20.0.0/19"

  availability_zones = [
    "eu-north-1a",
    "eu-north-1b",
    "eu-north-1c"
  ]

  private_subnets = [
    "10.20.0.0/21",
    "10.20.8.0/21",
    "10.20.16.0/21"
  ]

  public_subnets = [
    "10.20.24.0/23",
    "10.20.26.0/23",
    "10.20.28.0/23"
  ]

  tags = {
    Environment = "demo"
    Project     = "eks-petclinic"
  }
}
