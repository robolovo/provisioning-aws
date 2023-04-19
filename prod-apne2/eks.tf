module "eks" {
  source = "../modules/eks"

  name       = "tf-eks"
  subnet_ids = module.vpc.private_subnets
  security_group_ids = [
    module.eks-sg.security_group_id
  ]

  tags = {
    Name  = "tf-prod"
    Owner = "robolovo"
    Env   = "prod"
  }
}
