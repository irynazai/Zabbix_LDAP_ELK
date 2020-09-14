variable "instance_group_name_public" {
    description 			= "A unique name for the public group of resources."
    default     			= "logstash-group"
}

variable "region" {
  description           = "Optional) A reference to the region where the regional forwarding rule resides. This field is not applicable to global forwarding rules."
  default               = "us-central1"
}

variable "port_range" {
	description        = "(Optional) This field is used along with the target field for TargetHttpProxy, TargetHttpsProxy, TargetSslProxy, TargetTcpProxy, TargetVpnGateway, TargetPool, TargetInstance. Applicable only when IPProtocol is TCP, UDP, or SCTP, only packets addressed to ports in the specified range will be forwarded to target. Forwarding rules with the same [IPAddress, IPProtocol] pair must have disjoint port ranges. Some types of forwarding target have constraints on the acceptable ports: TargetHttpProxy: 80, 8080; TargetHttpsProxy: 443; TargetTcpProxy: 25, 43, 110, 143, 195, 443, 465, 587, 700, 993, 995, 1883, 5222; TargetSslProxy: 25, 43, 110, 143, 195, 443, 465, 587, 700, 993, 995, 883, 5222; TargetVpnGateway: 500, 4500"
	default             = "80"
}

variable "project" {
    description         = "(Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
    default             = ""
}

variable "forwarding_rule" {
    description         = "A name of forwarding rule."
    default             = "logstash-forwarding-rule"
}

variable "target_proxy" {
    description         = "A name of the resource that reference to the UrlMap resource that defines the mapping from URL to the BackendService."
    default             = "logstash-target-proxy"
}

variable "proxy_url_map" {
    description         = "A name of reference to the UrlMap resource that defines the mapping from URL to the BackendService."
    default             = "logstash-url-map"
}

variable "name_backend" {
    description         = "Name of the backend Service defines a group of virtual machines that will serve traffic for load balancing. "
    default             = "logstash-backend-service"
}

