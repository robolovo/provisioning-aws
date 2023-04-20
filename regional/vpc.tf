module "vpc_apne2" {
  source = "../modules/vpc"

  name = "tf-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-2b"]
  public_subnets  = ["10.0.1.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_dns_hostnames = true
  #  enable_nat_gateway   = true
  #  single_nat_gateway   = true

  tags = {
    Name  = "tf-dev"
    Owner = "robolovo"
    Env   = "dev"
  }
}
