module "mha_node" {
  source = "../modules/ec2-instance"

  count = 3
  name  = "tf-instance-${count.index}"

  ami           = "ami-0f8aef1783704ebc9" # Amazon Linux 2 AMI (HVM)
  instance_type = "t3.medium"
  key_name      = "tf-key"

  subnet_id = data.terraform_remote_state.this.outputs.public_subnets[0]
  vpc_security_group_ids = [
    module.mha_node_sg.security_group_id
  ]

  associate_public_ip_address = true

  tags = {
    Name  = "tf-test"
    Owner = "robolovo"
    Env   = "test"
  }
}

module "mha_manager" {
  source = "../modules/ec2-instance"

  count = 1
  name  = "tf-instance-mha-manager"

  ami           = "ami-0f8aef1783704ebc9" # Amazon Linux 2 AMI (HVM)
  instance_type = "t3.medium"
  key_name      = "tf-key"

  subnet_id = data.terraform_remote_state.this.outputs.public_subnets[0]
  vpc_security_group_ids = [
    module.mha_manager_sg.security_group_id
  ]

  associate_public_ip_address = true

  tags = {
    Name  = "tf-test"
    Owner = "robolovo"
    Env   = "test"
  }
}
