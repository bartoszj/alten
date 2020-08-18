resource "random_integer" "postgresql_app_password_length" {
  min = 32
  max = 48
}
resource "random_password" "postgresql_app_password" {
  length  = random_integer.postgresql_app_password_length.result
  special = false
}
resource "random_integer" "postgresql_postgres_password_length" {
  min = 32
  max = 48
}
resource "random_password" "postgresql_postgres_password" {
  length  = random_integer.postgresql_postgres_password_length.result
  special = false
}

locals {
  postgresql_values = {
    "pgpool.replicaCount" = 2
    "postgresql.database" = "app"
    "postgresql.username" = "app"
  }
  postgresql_secret_values = {
    "postgresql.password"         = random_password.postgresql_app_password.result
    "postgresql.postgresPassword" = random_password.postgresql_postgres_password.result
  }
}

resource "helm_release" "postgresql" {
  chart     = "bitnami/postgresql-ha"
  name      = "postgresql-ha"
  namespace = kubernetes_namespace.app.id
  version   = "3.5.4"

  dynamic "set" {
    for_each = local.postgresql_values
    content {
      name  = set.key
      value = set.value
    }
  }

  dynamic "set_sensitive" {
    for_each = local.postgresql_secret_values
    content {
      type  = "string"
      name  = set_sensitive.key
      value = set_sensitive.value
    }
  }
}
