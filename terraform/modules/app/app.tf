locals {
  app_values = {
    "db.hostname"                                  = "postgresql-ha-pgpool"
    "service.annotations.cloud\\.google\\.com/neg" = "\\{\"ingress\": true\\}"
    "ingress.hosts[0].paths[0]"                    = "/"
    "ingress.hosts[0].paths[1]"                    = "/*"
  }
}

resource "helm_release" "app" {
  repository = "${path.module}/../../.."
  chart      = "webapp"
  name       = "webapp"

  namespace = kubernetes_namespace.app.id

  dynamic "set" {
    for_each = local.app_values
    content {
      type  = "string"
      name  = set.key
      value = set.value
    }
  }

  set_sensitive {
    name  = "db.password"
    value = random_password.postgresql_app_password.result
  }

  depends_on = [helm_release.postgresql]
}
