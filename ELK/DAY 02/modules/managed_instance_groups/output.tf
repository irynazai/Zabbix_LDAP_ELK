output "ek_external" {
	value          = google_compute_instance_template.private.network_interface[0].access_config[0].nat_ip
}

output "tomcat" {
	value          = google_compute_instance_template.public.network_interface[0].access_config[0].nat_ip
}
