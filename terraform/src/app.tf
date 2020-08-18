module "app" {
  source = "../modules/app"

  app_depends_on = [module.nodepool.node_pool]
}
