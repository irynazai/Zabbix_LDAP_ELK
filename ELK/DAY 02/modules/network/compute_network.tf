#---------------------------#
# Create compute network    #
#---------------------------#

resource "google_compute_network" "compute_network" {
    name                        = var.name_network
    description                 = var.description
    project                     = var.project
    auto_create_subnetworks     = var.auto_create_subnetworks
    routing_mode                = var.routing_mode
}

#-------------------------------------#
# Create compute public subnetwork    #
#-------------------------------------#

resource "google_compute_subnetwork" "public_subnet" {
    name                        = var.public_subnet_name
    project                     = var.project
    region                      = var.region
    ip_cidr_range               = var.public_subnet_cidr
    private_ip_google_access    = var.public_ip_google_access
    network                     = google_compute_network.compute_network.id
}

#-------------------------------------#
# Create compute private subnetwork   #
#-------------------------------------#

resource "google_compute_subnetwork" "private_subnet" {
    name                        = var.private_subnet_name
    project                     = var.project
    region                      = var.region
    ip_cidr_range               = var.private_subnet_cidr
    private_ip_google_access    = var.private_ip_google_access
    network                     = google_compute_network.compute_network.id
}

#-------------------------------------#
# Create compute static ip addresses  #
#-------------------------------------#

resource "google_compute_address" "static-tomcat-ip" {
    name                        = "static-tomcat-ip"
    address_type                = "EXTERNAL"
}

resource "google_compute_address" "static-ek-ip" {
    name                        = "static-ek-ip"
    address_type                = "EXTERNAL"
}

resource "google_compute_address" "static-ek-internal-ip" {
    name                        = "static-ek-internal-ip"
    address_type                = "INTERNAL"
    subnetwork                  = google_compute_subnetwork.private_subnet.id
    region                      = var.region
}

#---------------------------------------------#
# Create compute firewall bastion rules       #
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
    target_tags             	= var.deny_tags
    source_ranges             	= ["0.0.0.0/0"]
}

#--------------------------------------------------#
# Create compute firewall elastic-kibana rules     #
#--------------------------------------------------#

resource "google_compute_firewall" "allow-ek" {
    name                    	= var.ek_rule
    project                 	= var.project
    network                 	= google_compute_network.compute_network.name
    priority                	= var.priority_ek
    description             	= var.description_ek_rule
    direction               	= var.direction
    allow {
        protocol            	= var.ek_protocol
        ports               	= [var.http_port, var.ssh_port, var.kibana_port, var.elastic_port, var.tomcat_port]
    }
    source_ranges 				= var.all_ip
    target_tags             	= [var.ek_tag, var.logstash_tag] 
}

#----------------------------------------------------#
# Create compute firewall health-check rules         #
#----------------------------------------------------#

#resource "google_compute_firewall" "allow-public-health-check" {
#    name                    	= var.public_health_check_rule
#    project                 	= var.project
#    network                 	= google_compute_network.compute_network.name
#    priority                	= var.priority_public_health_check
#    description             	= var.description_health_public_check_rule
#    direction               	= var.direction
#    allow {
#        protocol            	= var.public_health_check_protocol
#        ports               	= var.public_health_check_port
#    }
#    source_ranges           	= var.public_health_check_ip
#    target_tags             	= var.logstash_tag
#}

#resource "google_compute_firewall" "allow-private-health-check" {
#    name                    	= var.private_health_check_rule
#    project                 	= var.project
#    network                 	= google_compute_network.compute_network.name
#    priority                	= var.priority_private_health_check
#    description             	= var.description_health_private_check_rule
#    direction               	= var.direction
#    allow {
#        protocol            	= var.private_health_check_protocol
#        ports               	= var.private_health_check_port
#    }
#    source_ranges           	= var.health_private_check_ip
#    target_tags             	= var.ek_tag
#}
