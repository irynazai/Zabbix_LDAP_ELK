variable "instance_group_name_public" {
    description 			= "A unique name for the public group of resources."
    default     			= "logstash-group"
}

variable "static-ek-internal-ip" {
    description 			= "The internal static ip of the instances in private network."
    default     			= ""
}

variable "static-ek-ip" {
    description 			= "The external static ip of the instances in private network."
    default     			= ""
}

variable "static-tomcat-ip"{
    description 			= "The external static ip of the instances in public network."
    default     			= ""
} 

variable "base_name_group_public" {
    description 			= "A unique base name for the public group of resources."
    default     			= "logstash"
}

variable "description_group_public" {
    description 			= "A brief description of the public group instances."
    default     			= "A group of instances in the public network."
}

variable "instance_group_name_private" {
    description 			= "A unique name for the private group of resources."
    default     			= "elastic-kibana-group"
}

variable "base_name_group_private" {
    description 			= "A unique base name for the private group of resources."
    default     			= "elastic-kibana"
}


variable "description_group_private" {
    description 			= "A brief description of the private group instances."
    default     			= "A group of instances in the private network."
}

variable "name_private_template" {
    description 			= "A unique name for the template in the private network."
    default     			= "elastic-kibana-host"
}

variable "name_public_template" {
    description 			= "A unique name for the template in the public network."
    default     			= "logstash-host"
}

variable "logstash_autoscalling" {
    description 			= "A name for the autoskelling policy."
    default     			= "logstash-autoscalling"
}

variable "address_name" {
    description             = "A name of private static address."
    default                 = "address-name"

}

variable "name_network" {
    description 		    = "Custom network."
    default 		        = "vpc-network"    
}

variable "static_ip" {
    description 			= "The internal ip of the instances in private network."
    default     			= ""
}

variable "network_ip" {
    description 			= "The internal ip of the instances in private network."
    default     			= ""
}

variable "region" {
  description 				= "A region for all instances in this project."
  default     				= "us-central1"
}

variable "zones" {
  description 				= "A region for all instances in this project."
  default     				= []
}

variable "project" {
    description 			= "The name of the project."
    default     			= ""
}

variable "startup_script" {
    description 			= "The startup script for instance in public subnetwork."
    default     			= ""
}


variable "can_ip_forward_private" {
    description 			= "Whether to allow sending and receiving of packets with non-matching source or destination IPs. This defaults to false."
    default     			= false
}

variable "can_ip_forward_public" {
    description 			= "Whether to allow sending and receiving of packets with non-matching source or destination IPs. This defaults to false."
    default     			= false
}


variable "auto_healing_policies_initial_delay_sec" {
    description 			= "The number of seconds that the managed instance group waits before it applies autohealing policies to new instances or recently recreated instances. Between 0 and 3600."
    default     			= "100"
}

variable "description_public_template" {
    default 			    = "A brief description of this resource in the public network."
}

variable "description_private_template" {
     default  			    = "A brief description of this resource in the private network."
}

variable "wait_for_instances" {
    description 			= "(Optional) Whether to wait for all instances to be created/updated before returning. Note that if this is set to true and the operation does not succeed, Terraform will continue trying until it times out."
    default     			= "true"
}

variable "named_port_name" {
    description 			= "(Required) The name of the port."
    default 				= "http"
}

variable "named_port_port" {
    description 			= "(Required) The port number."
    default 				= "80"
}

variable "ssh_user" {
    description 			= "User for connection to google machine"
    default     			= ""
}

variable "ssh_key" {
    description 			= "The ssh public key"
    default     			= ""
}

variable "network" {
    description 			= "The name of the private network."
    default     			= "vpc-network"
}

variable "public_subnet" {
    description 			= "The name or self_link of the public subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided."
    default     			= "public-subnet"
}

variable "private_subnet" {
    description 			= "The name or self_link of the privatesubnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided."
    default     			= "private-subnet"
}

variable "public_subnet_cidr" {
    description 			= "The public IP range od address to assign to the instance. If empty, the address will be automatically assigned."
    default     			= ""
}

variable "private_subnet_cidr" {
    description 			= "The private IP range od address to assign to the instance. If empty, the address will be automatically assigned."
    default     			= ""
}

variable "service_account_email" {
    description 			= "The service account e-mail address. If not given, the default Google Compute Engine service account is used. Note: allow_stopping_for_update must be set to true in order to update this field."
    default     			= ""
}

variable "service_account_scopes" {
    description 			= "A list of service scopes. Both OAuth2 URLs and gcloud short names are supported. To allow full access to all Cloud APIs, use the cloud-platform scope. Note: allow_stopping_for_update must be set to true in order to update this field."
    default     			= []
}

variable "scheduling_preemptible" {
    description 			= "Is the instance preemptible."
    default     			= "false"
}

variable "scheduling_on_host_maintenance" {
    description 			= "Describes maintenance behavior for the instance. Can be MIGRATE or TERMINATE"
    default     			= "MIGRATE"
}

variable "scheduling_automatic_restart" {
    description 			= "Specifies if the instance should be restarted if it was terminated by Compute Engine (not a user)."
    default     			= "true"
}

variable "machine_type" {
    description 			= "The machine type to create.To create a machine with a custom type (such as extended memory), format the value like custom-VCPUS-MEM_IN_MB like custom-6-20480 for 6 vCPU and 20GB of RAM."
    default     			= "n1-standard-1"
}

variable "boot_disk_check" {
    description 			= "(Optional) Indicates that this is a boot disk."
    default 				= "true"    
}

variable "boot_disk_auto_delete" {
    description 			= "Whether or not the disk should be auto-deleted. This defaults to true."
    default     			= "true"
}

variable "boot_disk_device_name" {
    description 			= "A unique device name that is reflected into the /dev/ tree of a Linux operating system running within the instance. If not specified, the server chooses a default device name to apply to this disk."
    default     			= ""
}

variable "image_project" {
    description 			= "The project of image from which to initialize this disk. "
    default     			= "centos-cloud"
}

variable "image_family" {
    description 			= "The family of image from which to initialize this disk."
    default     			= "centos-7"
}


variable "boot_disk_type" {
    description 			= "The GCE disk type. Can be either 'pd-ssd', 'local-ssd', or 'pd-standard'."
    default     			= "pd-ssd"
}

variable "boot_disk_size" {
    description 			= "The size of the image in gigabytes. If not specified, it will inherit the size of its base image."
    default     			= "35"
}

variable "private_network_name_tags" {
  description 				= "A tags of ek host."
  default     				= ["ek-tag"]    
}


variable "public_network_name_tags" {
  description 				= "A tags of logstash host."
  default     				= ["logstash-tag"]    
}
