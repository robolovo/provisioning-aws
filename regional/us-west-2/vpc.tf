module "vpc_usw2" {
  source = "../../modules/vpc"

  name = "tf-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["us-west-2a"]
  public_subnets = ["10.0.1.0/24"]

  enable_dns_hostnames = true

  tags = {
    Name  = "tf-test"
    Owner = "robolovo"
    Env   = "test"
  }
}
