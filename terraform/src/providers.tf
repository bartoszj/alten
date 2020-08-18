data "google_client_config" "current" {}

provider "google" {
  project = "alten-app"
  region  = "europe-west1"
  version = "~> 3.34.0"
}

provider "kubernetes" {
  host                   = "https://${module.cluster.cluster.endpoint}"
  cluster_ca_certificate = base64decode(module.cluster.cluster.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token

  version = "~> 1.12.0"
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.cluster.cluster.endpoint}"
    cluster_ca_certificate = base64decode(module.cluster.cluster.master_auth.0.cluster_ca_certificate)
    token                  = data.google_client_config.current.access_token
  }

  version = "~> 1.2.4"
}
