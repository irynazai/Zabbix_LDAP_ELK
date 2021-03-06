
variable "project" {
    description 		= "The project in which the resource belongs. If it is not provided, the provider project is used."
    default     		= "exit-task1"
}

variable "region" {
    description 		= "URL of the GCP region for this subnetwork."
    default     		= "us-central1"
}

variable "zone" {
    description 		= "URL of the GCP zone for bastion instance."
    default     		= "us-central1-b"
}

variable "name_network" {
    description 		= "Custom network."
    default 		    = "vpc-network"    
}

variable "auto_create_subnetworks" {
    description 		= "(Optional) If set to true, this network will be created in auto subnet mode, and Google will create a subnet for each region automatically. If set to false, a custom subnetted network will be created that can support google_compute_subnetwork resources. Defaults to true."
    default     		= "true"
}

variable "routing_mode" {
    description 		= "Sets the network-wide routing mode for Cloud Routers to use. Accepted values are 'GLOBAL' or 'REGIONAL'. Defaults to 'REGIONAL'. Refer to the Cloud Router documentation for more details."
    default     		= "REGIONAL"
}

variable "description" {
    description 		= "(Optional) A brief description of this resource."
    default     		= "Custom network."
}


variable "apache_subnet_name" {
    description 		= "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
    default     		= "apache-subnet"
}


variable "apache_subnet_cidr" {
    description 		= "(Required) The range of internal addresses that are owned by this subnetwork. Provide this property when you create the subnetwork. For example, 10.0.0.0/8 or 192.168.0.0/16. Ranges must be unique and non-overlapping within a network. Only IPv4 is supported."
    default     		= "10.0.0.0/24"
}

variable "enable_flow_logs" {
    description 		= "(Optional) Whether to enable flow logging for this subnetwork."
    default     		= "false"
}

variable "apache_ip_google_access" {
    description 		= "(Optional) Whether the VMs in this subnet can access Google services without assigned external IP addresses."
    default     		= "false"
}


variable "router_name" {
    description         = "A name of router for jump host."
    default             = "nat-router"

}

variable "nat_name" {
    description         = "A name of nat network for jump host."
    default             = "nat-net"

}

variable "timeouts_create" {
    description = "Time to create redis node. Default is 6 minutes. Valid units of time are s, m, h."
    default     = "1s"
}

variable "timeouts_update" {
    description = "Time to update redis node. Default is 6 minutes. Valid units of time are s, m, h."
    default     = "1s"
}

variable "timeouts_delete" {
    description = "Time to delete redis node. Default is 6 minutes. Valid units of time are s, m, h."
    default     = "1s"
}

variable "ssh_rule" {
    description = "The firewall rules for ssh connection."
    default = "ssh-rule"   
}

variable "priority_ssh" {
    description = "The priority of this rule."
    default = "1000"    
}

variable "description_ssh_rule" {
    default = "It's create ssh access throuht bastion-host to apache network."    
}

variable "direction" {
    description = "This direction is allowed for all rules."
    default = "INGRESS"    
}

variable "ssh_protocol" {
    description = "Ssh protocol."
    default = "tcp"    
}

variable "ssh_ports" {
    description = "Ssh port."
    default = ["22"]   
}

variable "allow_ssh_tags" {
    description = "The destination of ssh connection."
    default = ["apache-tag"]    
}

variable "ssh_tags" {
    description = "The source of ssh connrction."
    default = ["jump-tag"]    
}

variable "http_rule" {
    description = "A name of rule for connection with apache web server."
    default = "http-rule"    
}

variable "priority_http" {
    description = "The priority of this rule."
    default = "1000"    
}

variable "description_http_rule" {
    default = "It's create access to apache web server from any host."   
}

variable "http_protocol" {
    description = "Http protocol."
    default = "tcp"    
}

variable "http_port" {
     description = "Http port."
    default = ["80","443"]   
}

variable "apache_tag" {
    description = "Apache tag."
    default = ["apache-tag"]    
} 


variable "apache_health_check_rule" {
    description = "A name of health check apache subnet."
    default = "apache-health-check-rule"    
}

variable "priority_apache_health_check" {
    description = "The priority of this rule."
    default = "1000"   
}

variable "description_health_apache_check_rule" {
    default = "It's check health of apache subnetwork."    
}

variable "apache_health_check_protocol" {
    description = "Protocol of health check."
    default = "tcp"   
}

variable "apache_health_check_port" {
    description = "Port of health check."
    default = ["80"]    
}

variable "health_apache_check_ip" {
    description = "IP range of health check apache subnet."
    default = ["35.191.0.0/16", "130.211.0.0/22"]   
}


variable "jump_rules" {
    description = "A name of rule."
    default = "jump-rules"    
}

variable "priority_jump" {
    description = "The priority of this rule."
    default = "1000"    
}

variable "description_jump_rule" {
    default = "It's create access to bastion host from any host."    
}

variable "jump_protocol" {
    description = "Bastionprotocol."
    default = "tcp"    
}
variable "jump_port" {
    description = "Bastion port."
    default = ["22"]  
}

variable "jump_tag" {
    description = "Bastion tag."
    default = ["jump-tag"]   
}

variable "jump_ip" {
    description = "IP range which can access to bastion host."
    default = ["0.0.0.0/0"]    
}

variable "deny_rule" {
    description = "A name of rule."
    default = "deny-rule"    
}

variable "priority_deny" {
    description = "The priority of this rule."
    default = "1001"    
}

variable "description_deny_rule" {
    default = "It's make apache access (deny all connection) throuht ssh connection if you try to access not throuht bastion host."    
}

variable "deny_protocol" {
    description = "Deny protocol."
    default = "tcp"    
}

variable "deny_port" {
    description = "SSH port."
    default = ["22"]    
}

variable "deny_tags" {
    description = "Instanses with this tags has no access not throuht bastion host."
    default = ["apache-tag"]    
}

