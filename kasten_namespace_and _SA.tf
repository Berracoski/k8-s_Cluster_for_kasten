resource "kubernetes_namespace" "kasten_io" {
  metadata {
    name = "kasten-io"
  }
}

resource "kubernetes_service_account" "kasten_sa" {
  metadata {
    name      = "kasten-sa"
    namespace = kubernetes_namespace.kasten_io.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.kasten_role.arn
    }
  }
}