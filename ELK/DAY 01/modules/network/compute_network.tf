#---------------------------#
# Create compute network    #
#---------------------------#

resource "google_compute_network" "compute_network" {
    name                        = var.name_network
    description                 = var.description
    project                     = var.project
    auto_create_subnetworks     = var.auto_create_subnetworks
}

#-------------------------------------#
# Create compute subnetwork           #
#-------------------------------------#

resource "google_compute_subnetwork" "subnet" {
    name                        = var.subnet_name
    project                     = var.project
    region                      = var.region
    ip_cidr_range               = var.subnet_cidr
    network                     = google_compute_network.compute_network.id
}

#-------------------------------------#
# Create compute internal address     #
#-------------------------------------#

resource "google_compute_address" "address" {
  name         = var.address_name
  subnetwork   = google_compute_subnetwork.subnet.id
  address_type = "INTERNAL"
  region       = var.region
}

#---------------------------------------------#
# Create compute firewall rules               #
#---------------------------------------------#

resource "google_compute_firewall" "external" {
  name    						= var.external_name
  network 						= google_compute_network.compute_network.id
  allow {
    protocol 				  = "tcp"
    ports    					= [var.http_port, var.ssh_port, var.kibana_port, var.elastic_port, var.tomcat_port]
  }
  source_ranges 			= var.all_ip
}


resource "google_compute_firewall" "internal" {
  name    						= var.internal_name
  network 						= google_compute_network.compute_network.id
  allow {
    ports    					= var.all_ports
    protocol 					= "tcp"
  }
  allow {
    ports    					= var.all_ports
    protocol 					= "udp"
  }
  allow {
    protocol 					= "icmp"
  }
  source_ranges 			= [var.subnet_cidr]
}

