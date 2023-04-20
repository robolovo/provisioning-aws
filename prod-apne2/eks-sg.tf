module "eks-sg" {
  source = "../modules/security-group"

  name        = "tf-eks-sg"
  description = "Security group for EKS"
  vpc_id      = data.terraform_remote_state.this.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "10.0.0.0/16"
    }
  ]

  tags = {
    Name  = "tf-prod"
    Owner = "robolovo"
    Env   = "prod"
  }
}