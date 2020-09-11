provider "google" {
 # credentials               = ""
  project                   = var.project
  region                    = var.region
}

#---------------------------------------------------------------------------#
# Uncomment the required lines or override other variables of your choice.  #
#---------------------------------------------------------------------------#
module "network" {
  source                    = "./modules/network"
#  project                   = var.project
}

module "instance" {
  source                    = "./modules/instance"
#  project                   = var.project
#  ssh_user                  = var.ssh_user
#  ssh_key                   = var.ssh_key
#  service_account_email     = var.service_account_email
  depends_on                = [module.network]
}

