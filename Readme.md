# Folders:

## `app`

Application source code in Python. It is using `pipenv` as a dependency manager for local development.

Tests are included in the `tests` folder.

`Makefile` contains a short list of useful shortcuts to build, run or test application.

## `webapp`

Helm chart of the application

## `terraform`

Terraform modules and source codes:

- Create VCP for the application, `network` module
- Create Nat Box, `nat` module. CloudNAT was not used due to the costs of the infrastructure
- Setup Kubernetes cluster with custom node pool, `gke` and `nodepool` modules
- Create Kubernetes namespace and deploys PostgreSQL HA server together with the application, `app` module
