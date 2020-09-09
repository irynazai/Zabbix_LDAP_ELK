#----------------------------------------#
# Create compute phpldapadmin instance   #
#----------------------------------------#

resource "google_compute_instance" "apache" {
    name                        = var.name_apache
    project                     = var.project
    machine_type                = var.machine_type
    zone                        = var.zone
    
    metadata = {
        ssh-keys                = "var.ssh_user:${file("key.pub")}"
    }
    
    metadata_startup_script     = file("install_ldap.sh")
    
    boot_disk {
        initialize_params {
            type                = var.boot_disk_type
            size                = var.boot_disk_size
            image               = "${var.image_project}/${var.image_family}"
        }
    }

    network_interface {
        network                 = var.network
        subnetwork              = var.apache_subnet
        access_config {
        }
    }
    tags                        = var.apache_tags
    
    scheduling {
        on_host_maintenance     = var.scheduling_on_host_maintenance
        automatic_restart       = var.scheduling_automatic_restart
        preemptible             = var.scheduling_preemptible
    }
    
    service_account {
        email                   = var.service_account_email
        scopes                  = var.service_account_scopes
    }
}

    


