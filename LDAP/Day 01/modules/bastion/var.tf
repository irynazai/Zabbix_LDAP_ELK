variable "region" {
  description               = "A region for all instances in this project."
  default                   = "us-central1"
}


variable "project" {
    description             = "The name of the project."
    default                 = "test1"
}

variable "ssh_user" {
    description             = "User for connection to google machine"
    default                 = ""
}

variable "ssh_key" {
    description             = "The ssh apache key"
    default                 = ""
}

variable "network" {
    description             = "The name of the private network."
    default                 = "vpc-network"
}

variable "apache_subnet" {
    description             = "The name or self_link of the apache subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided."
    default                 = "apache-subnet"
}


variable "service_account_email" {
    description             = "The service account e-mail address. If not given, the default Google Compute Engine service account is used. Note: allow_stopping_for_update must be set to true in order to update this field."
    default                 = ""
}

variable "service_account_scopes" {
    description             = "A list of service scopes. Both OAuth2 URLs and gcloud short names are supported. To allow full access to all Cloud APIs, use the cloud-platform scope. Note: allow_stopping_for_update must be set to true in order to update this field."
    default                 = []
}

variable "machine_type" {
    description             = "The machine type to create.To create a machine with a custom type (such as extended memory), format the value like custom-VCPUS-MEM_IN_MB like custom-6-20480 for 6 vCPU and 20GB of RAM."
    default                 = "n1-standard-1"
}

variable "boot_disk_check" {
    description             = "(Optional) Indicates that this is a boot disk."
    default                 = "true"    
}

variable "boot_disk_auto_delete" {
    description             = "Whether or not the disk should be auto-deleted. This defaults to true."
    default                 = "true"
}

variable "boot_disk_device_name" {
    description             = "A unique device name that is reflected into the /dev/ tree of a Linux operating system running within the instance. If not specified, the server chooses a default device name to apply to this disk."
    default                 = ""
}

variable "image_project" {
    description             = "The project of image from which to initialize this disk. "
    default                 = "centos-cloud"
}

variable "image_family" {
    description             = "The family of image from which to initialize this disk."
    default                 = "centos-7"
}


variable "boot_disk_type" {
    description             = "The GCE disk type. Can be either 'pd-ssd', 'local-ssd', or 'pd-standard'."
    default                 = "pd-ssd"
}

variable "boot_disk_size" {
    description             = "The size of the image in gigabytes. If not specified, it will inherit the size of its base image."
    default                 = "35"
}

variable "name_bastion" {
    description             = "A unique name for the jump host."
    default                 = "bastion-host"
}

variable "description_bastion" {
    description             = "(Optional) A brief description of this resource."
    default                 = "Jump host for access to private network by ssh."
}

variable "bastion_tags" {
  description               = "A tags of jump host."
  default                   = ["jump-tag"]    
}

variable "zone_bastion" {
  description               = "A region for bastion instance in this project."
  default                   = "us-central1-a"
}
