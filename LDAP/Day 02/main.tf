provider "google" {
  "credentials               = ""
  project                   = var.project
  region                    = var.region
}

#-----------------------#
# Add and init modules  #
#-----------------------#
module "network" {
  source                    = "./modules/network"
  project                   = var.project
}

module "instance" {
  source                    = "./modules/instance"
  project                   = var.project
  #service_account_email     = var.service_account_email
  ssh_user                  = var.ssh_user
  depends_on                = [module.network]
}

module "bastion" {
  source                    = "./modules/bastion"
  #service_account_email     = var.service_account_email
  ssh_user                  = var.ssh_user
  project                   = var.project
  depends_on                = [module.network]  
}
