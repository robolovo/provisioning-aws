resource "aws_eks_cluster" "this" {
  name     = var.name
  role_arn = aws_iam_role.cluster.arn

  # https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
  vpc_config {
    # https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html
    endpoint_private_access = true
    endpoint_public_access  = false

    subnet_ids = var.subnet_ids

    # https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html
    security_group_ids = var.security_group_ids
  }

  depends_on = [
    aws_iam_role.cluster,
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy,
    aws_iam_role_policy_attachment.amazon_eks_vpc_resource_controller,
  ]

  tags = merge(
    var.tags
  )
}