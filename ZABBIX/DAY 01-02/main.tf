provider "google" {
#  credentials               = ""
  project                   = var.project
  region                    = var.region
}

#---------------------------------------------------------------------------#
# Uncomment the required lines or override other variables of your choice.  #
#---------------------------------------------------------------------------#
module "network" {
  source                    = "./modules/network"
  project                   = var.project
}

module "instance" {
  source                    = "./modules/instance"
  project                   = var.project
#  service_account_email     = var.service_account_email
#  ssh_user                  = var.ssh_user
  static_server_ip          = module.network.static_server_ip
  depends_on                = [module.network]
}

module "bastion" {
  source                    = "./modules/bastion"
#  service_account_email     = var.service_account_email
#  ssh_user                  = var.ssh_user
  project                   = var.project
  depends_on                = [module.network]  
}
