resource "aws_eks_cluster" "main" {
  name = "main"


  role_arn = aws_iam_role.cluster.arn
  version  = local.k8s_version

  vpc_config {
    subnet_ids = aws_subnet.public[*].id

    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

