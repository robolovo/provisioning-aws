module "eks" {
  source = "../modules/eks"

  name       = "tf-eks"
  subnet_ids = data.terraform_remote_state.this.outputs.private_subnets
  security_group_ids = [
    module.eks-sg.security_group_id
  ]

  tags = {
    Name  = "tf-prod"
    Owner = "robolovo"
    Env   = "prod"
  }
}
