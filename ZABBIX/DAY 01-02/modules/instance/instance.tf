#-------------------------------------------#
# Create compute server with zabbix server  #
#-------------------------------------------#

resource "google_compute_instance" "server" {
    name                        = var.name_server
    project                     = var.project
    machine_type                = var.machine_type
    zone                        = var.zone    
    metadata = {
        ssh-keys                = "${var.ssh_user}:${var.ssh_key}"
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
        subnetwork              = var.subnet
        network_ip              = var.static_server_ip
        access_config {
        }
    }
    tags                        = var.server_tags  
    metadata_startup_script     = file("install_server.sh")   
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

#-------------------------------------------#
# Create compute server with ldap server  	#
#-------------------------------------------#

resource "google_compute_instance" "ldap" {
    name                        = var.name_ldap_server
    project                     = var.project
    machine_type                = var.machine_type
    zone                        = var.zone
    metadata = {
        ssh-keys                = "${var.ssh_user}:${var.ssh_key}"
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
        subnetwork              = var.subnet
        network_ip              = var.network_ip
    }
    tags                        = var.ldap_tags
    metadata_startup_script     = file("install_ldap.sh")
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
# Create compute client instance   		 #
#----------------------------------------#
   
resource "google_compute_instance" "client" {
    name                        = var.name_client
    project                     = var.project
    machine_type                = var.machine_type
    depends_on 					= [google_compute_instance.server]
    zone                        = var.zone
    metadata = {
        ssh-keys                = "${var.ssh_user}:${var.ssh_key}"
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
        subnetwork              = var.subnet
        access_config {
        }
    }
    tags                        = var.client_tags    
    metadata_startup_script     = templatefile("install_client.sh",{ IP = google_compute_instance.server.network_interface[0].network_ip})    
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

    

