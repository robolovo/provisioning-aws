module "ec2-instance-sg" {
  source = "../modules/security-group"

  name        = "tf-ec2-sg"
  description = "Security group for EC2"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name  = "tf-dev"
    Owner = "robolovo"
    Env   = "dev"
  }
}