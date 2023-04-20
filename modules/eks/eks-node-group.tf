resource "aws_eks_node_group" "this" {
  cluster_name = aws_eks_cluster.this.name

  node_group_name = "tf-dev-eks-node-group"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = var.subnet_ids

  remote_access {
    ec2_ssh_key               = "tf-key"
    source_security_group_ids = var.security_group_ids
  }

  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]
  disk_size      = 20

  scaling_config {
    desired_size = 3
    min_size     = 2
    max_size     = 10
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role.node_group,
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_readonly,
  ]

  tags = merge(
    var.tags
  )
}

