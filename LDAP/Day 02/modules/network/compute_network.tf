#---------------------------#
# Create compute network    #
#---------------------------#

resource "google_compute_network" "compute_network" {
    name                        = var.name_network
    description                 = var.description
    project                     = var.project
    auto_create_subnetworks     = var. auto_create_subnetworks
}

#-------------------------------------#
# Create compute server subnetwork    #
#-------------------------------------#

resource "google_compute_subnetwork" "subnet" {
    name                        = var.subnet_name
    project                     = var.project
    region                      = var.region
    ip_cidr_range               = var.subnet_cidr
    network                     = google_compute_network.compute_network.id
}


#---------------------------------------------#
# Create compute firewall ssh rules           #
#---------------------------------------------#

resource "google_compute_firewall" "allow-ssh" {
    name                    	= var.ssh_rule
    project                 	= var.project
    network                 	= google_compute_network.compute_network.name
    priority                	= var.priority_ssh
    description             	= var.description_ssh_rule
    direction               	= var.direction
    allow {
        protocol              	= var.ssh_protocol
        ports                 	= var.ssh_ports
    }
    target_tags             	= var.allow_ssh_tags
    source_tags             	= var.ssh_tags
}

resource "google_compute_firewall" "allow-jump" {
    name                    	= var.jump_rules
    project                 	= var.project
    network                 	= google_compute_network.compute_network.name
    priority                	= var.priority_jump
    description             	= var.description_jump_rule
    direction               	= var.direction   
    allow {
        protocol            	= var.jump_protocol
        ports               	= var.jump_port
     }
    target_tags             	= var.jump_tag
    source_ranges           	= var.jump_ip    
}


resource "google_compute_firewall" "deny-internal" {
    name                    	= var.deny_rule
    project                 	= var.project
    network                 	= google_compute_network.compute_network.name
    priority                	= var.priority_deny
    description             	= var.description_deny_rule
    direction               	= var.direction 
    deny {
        protocol            	= var.deny_protocol
        ports               	= var.deny_port
    }
    target_tags             	= var.server_tag
    source_ranges             	= var.jump_ip 
}


#------------------------------------------------------#
# Create compute firewall internal server rules        #
#------------------------------------------------------#

resource "google_compute_firewall" "allow-internal" {
    name                    	= var.internal_rule
    project                 	= var.project
    network                 	= google_compute_network.compute_network.name
    priority                	= var.priority_http
    description             	= var.description_internal_rule
    direction               	= var.direction
    allow {
        protocol                = "tcp"
        ports                   = var.server_ip
    }
    allow {
        protocol                = "udp"
        ports                   = var.server_ip
    }
    allow {
        protocol                = "icmp"
    }
    target_tags                 = var.server_tag
    source_tags             	= var.client_tags
} 


#------------------------------------------------------#
# Create compute firewall external server rules        #
#------------------------------------------------------#

resource "google_compute_firewall" "allow-http" {
    name                    	= var.http_rule
    project                 	= var.project
    network                 	= google_compute_network.compute_network.name
    priority                	= var.priority_http
    description             	= var.description_http_rule
    direction               	= var.direction
    allow {
        protocol                = var.http_protocol
        ports                   = var.http_port
    }
    target_tags                 = var.server_tag
    source_ranges             	= var.jump_ip 
} 
