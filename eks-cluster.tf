resource "aws_eks_cluster" "main" {
  name = "main"


  role_arn = aws_iam_role.cluster.arn
  version  = local.k8s_version

  vpc_config {
    subnet_ids = aws_subnet.public[*].id

    endpoint_private_access = true
    endpoint_public_access  = true
  }
  # access_config {
  #   authentication_mode                         = "API_AND_CONFIG_MAP"
  #   bootstrap_cluster_creator_admin_permissions = true
  # }
}

# # 1. Create the base access entry (Remove the kubernetes_groups line)
# resource "aws_eks_access_entry" "magarcia" {
#   cluster_name      = aws_eks_cluster.main.name
#   principal_arn     = "arn:aws:iam::528775625753:user/magarcia"
#   type              = "STANDARD"
# }

# # 2. Grant Admin rights via an EKS Access Policy
# resource "aws_eks_access_policy_association" "magarcia_admin" {
#   cluster_name  = aws_eks_cluster.main.name
#   policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#   principal_arn = aws_eks_access_entry.magarcia.principal_arn

#   access_scope {
#     type = "cluster"
#   }
# }