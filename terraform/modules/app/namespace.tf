resource "kubernetes_namespace" "app" {
  metadata {
    name = "app"
  }

  timeouts {
    delete = "15m"
  }

  depends_on = [var.app_depends_on]
}
