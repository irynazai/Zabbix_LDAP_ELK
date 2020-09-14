#---------------------------------------------------------------#
# Create terraform backend to use remote storage                #
#---------------------------------------------------------------#
#terraform {
#  backend "gcs" {
#    bucket      			= ""
#    credentials       		= ""
#    prefix      			= "terraform/"
#  }
#}

#---------------------------------------------------------------------------#
# Uncomment the required lines or override other variables of your choice.  #
#---------------------------------------------------------------------------#

provider "google" {
#  credentials       		= ""
  project           		= var.project
  region            		= var.region
}

provider "null" {
   version                  = "~> 2.1"
}

#------------------------------------------#
# Upload files for tomcat into the bucket  #
#------------------------------------------#

resource "null_resource" "upload_folder_content" {
 triggers                   = {
   file_hashes = jsonencode({
   for fn in fileset(var.folder_path, "**") :
   fn => filesha256("${var.folder_path}/${fn}")
   })
 }

 provisioner "local-exec" {
   command                  = "gsutil cp -r ${var.folder_path}/* gs://${var.gcs_bucket}/terraform/"
 }
}

#-----------------------#
# Add and init modules  #
#-----------------------#

module "network" {
  source            		= "./modules/network"
  project           		= var.project
}

module "managed_instance_groups" {
  source            		= "./modules/managed_instance_groups"
  ssh_user          		= var.ssh_user
  zones             		= var.zones
  project           		= var.project
  service_account_email 	= var.service_account_email
  static-ek-internal-ip     = module.network.static-ek-internal-ip 
  static-ek-ip              = module.network.static-ek-ip 
  static-tomcat-ip          = module.network.static-tomcat-ip
  depends_on        		= [module.network, module.instances]
}

module "instances" {
  source            		= "./modules/instances"
  project           		= var.project
  service_account_email 	= var.service_account_email
  ssh_user          		= var.ssh_user
  depends_on        		= [module.network]  
}
