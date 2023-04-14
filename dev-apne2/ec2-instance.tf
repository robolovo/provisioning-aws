module "ec2-instance" {
  source = "../modules/ec2-instance"

  count = 4
  name  = "tf-instance-${count.index}"

  ami           = "ami-058165de3b7202099" # CentOS-7
  instance_type = "t3.medium"
  key_name      = "tf-key"

  subnet_id     = module.vpc.public_subnets[0]
  vpc_security_group_ids = [
    module.ec2-instance-sg.security_group_id
  ]

  associate_public_ip_address = true

  tags = {
    Name  = "tf-dev"
    Owner = "robolovo"
    Env   = "dev"
  }
}