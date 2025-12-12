resource "kubernetes_namespace_v1" "kasten_io" {
  provider = kubernetes.eks
  metadata {
    name = "kasten-io"
  }
  depends_on = [aws_eks_cluster.main]
}

resource "kubernetes_service_account_v1" "kasten_sa" {
  provider = kubernetes.eks
  metadata {
    name      = "kasten-sa"
    namespace = kubernetes_namespace_v1.kasten_io.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.kasten_role.arn
    }
  }
  depends_on = [kubernetes_namespace_v1.kasten_io]
}