
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
    default     		= "false"
}

variable "routing_mode" {
    description 		= "Sets the network-wide routing mode for Cloud Routers to use. Accepted values are 'GLOBAL' or 'REGIONAL'. Defaults to 'REGIONAL'. Refer to the Cloud Router documentation for more details."
    default     		= "REGIONAL"
}

variable "description" {
    description 		= "(Optional) A brief description of this resource."
    default     		= "Custom network."
}


variable "subnet_name" {
    description 		= "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
    default     		= "subnet"
}


variable "subnet_cidr" {
    description 		= "(Required) The range of internal addresses that are owned by this subnetwork. Provide this property when you create the subnetwork. For example, 10.0.0.0/8 or 192.168.0.0/16. Ranges must be unique and non-overlapping within a network. Only IPv4 is supported."
    default     		= "10.5.2.0/24"
}


variable "server_ip_google_access" {
    description 		= "(Optional) Whether the VMs in this subnet can access Google services without assigned external IP addresses."
    default     		= "false"
}

variable "client_ip_google_access" {
    description         = "(Optional) Whether the VMs in this subnet can access Google services without assigned external IP addresses."
    default             = "false"
}


variable "timeouts_create" {
    description         = "Time to create redis node. Default is 6 minutes. Valid units of time are s, m, h."
    default             = "1s"
}

variable "timeouts_update" {
    description         = "Time to update redis node. Default is 6 minutes. Valid units of time are s, m, h."
    default             = "1s"
}

variable "timeouts_delete" {
    description         = "Time to delete redis node. Default is 6 minutes. Valid units of time are s, m, h."
    default             = "1s"
}

variable "tcp" {
    description         = "The firewall rules for ssh connection."
    default             = "tcp"   
}

variable "all_ip" {
    description         = "The priority of this rule."
    default              = ["0.0.0.0/0"]    
}


variable "direction" {
    description         = "This direction is allowed for all rules."
    default = "INGRESS"    
}

variable "http_port" {
    default             = ["80"]  
}

variable "ssh_port" {
    default             = ["22"]  
}

variable "kibana_port" {
    default             = ["5601"]  
}

variable "elastic_port" {
    default             = ["9200"]   
}

variable "tomcat_port" {
    default             = ["8080"]   
}

variable "kibana_tag" {
    default             = ["kibana-tag"]    
}

variable "elastic_tag" {
    default             = ["elastic-tag"]    
}

variable "tomcat_tag" {
    default             = ["tomcat-tag"]    
}

variable "all_ports" {
    default             = ["0-65535"]  
}

variable "address_name" {
    default             = "address-name"   
}

variable "external_name" {
    default             = "external-name"   
}

variable "internal_name" {
    default             = "internal-name"   
}


