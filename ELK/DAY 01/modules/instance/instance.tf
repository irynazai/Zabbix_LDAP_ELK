#----------------------------------------#
# Create compute ELK instance   		 #
#----------------------------------------#

resource "google_compute_instance" "elk" {
    name                        = var.name_elk
    project                     = var.project
    machine_type                = var.machine_type
    zone                        = var.zone
    
    metadata = {
        ssh-keys                = "${var.ssh_user}:${var.ssh_key}"
    }
    
    metadata_startup_script     = file("elk.sh")
    
    boot_disk {
        initialize_params {
            type                = var.boot_disk_type
            size                = var.boot_disk_size
            image               = "${var.image_project}/${var.image_family}"
        }
    }

    network_interface {
        network                 = var.network
        subnetwork              = var.subnet
        access_config {
        }
    }
    tags                        = var.elk_tags
    
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

    

#----------------------------------------#
# Create compute tomcat instance         #
#----------------------------------------#

resource "google_compute_instance" "tomcat" {
    name                        = var.name_tomcat
    project                     = var.project
    machine_type                = var.machine_type
    zone                        = var.zone
    
    metadata = {
        ssh-keys                = "${var.ssh_user}:${var.ssh_key}"
    }
    
    metadata_startup_script     = file("tomcat.sh")
    
    boot_disk {
        initialize_params {
            type                = var.boot_disk_type
            size                = var.boot_disk_size
            image               = "${var.image_project}/${var.image_family}"
        }
    }

    network_interface {
        network                 = var.network
        subnetwork              = var.subnet
        access_config {
        }
    }
    tags                        = var.tomcat_tags
    
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



