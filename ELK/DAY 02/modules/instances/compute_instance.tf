
#-----------------------------------#
# Create compute bastion instance   #
#-----------------------------------#

resource "google_compute_instance" "bastion" {
    name                        = var.name_bastion
    description                 = var.description_bastion
    project                     = var.project
    machine_type                = var.machine_type
    zone                        = var.zone_bastion
    metadata = {
        ssh-keys = "var.ssh_user:${file("key.pub")}"
    }

    
    boot_disk {
        initialize_params {
            type                = var.boot_disk_type
            size                = var.boot_disk_size
            image               = "${var.image_project}/${var.image_family}"
        }
    }

    network_interface {
        network                 = var.network
        subnetwork              = var.public_subnet
        access_config {
        }
    }
    tags                        = var.bastion_tags

    service_account {
        email                   = var.service_account_email
        scopes                  = var.service_account_scopes
    }
}


