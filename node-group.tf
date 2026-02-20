resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "node-group"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = aws_subnet.private[*].id

  scaling_config {
    desired_size = 0
    max_size     = 3
    min_size     = 0
  }

  instance_types = ["t3.medium"]
  ami_type       = "AL2023_x86_64_STANDARD"

  labels = {
    role = "worker"
    Cliente = "Claro"
    Servicio   = "Curso_Claro"
  }

}


resource "aws_eks_node_group" "spot_nodes" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "spot-node-group"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = aws_subnet.private[*].id

  capacity_type = "SPOT"

  scaling_config {
    desired_size = 3
    max_size     = 10 # Increase max to allow for room during Spot rebalancing
    min_size     = 1
  }

  # DIVERSIFIED LIST:
  instance_types = [
    "t3.medium", 
    "t3a.medium", 
    "t2.medium",
    "t2.large",
    "c5.large", 
    "c5a.large", 
    "c4.large"
  ]

  ami_type = "AL2023_x86_64_STANDARD"

  labels = {
    role         = "worker"
    capacityType = "SPOT"
    Cliente = "Claro"
    Servicio   = "Curso_Claro"
  }
}
