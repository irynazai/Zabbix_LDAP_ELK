output "server_external_ip" {
    value = google_compute_instance.server.network_interface.0.access_config.0.nat_ip
}


output "client_external_ip" {
    value = google_compute_instance.client.network_interface.0.access_config.0.nat_ip
}

output "server_internal_ip" {
    value = google_compute_instance.server.network_interface.0.network_ip
}

output "ldap_internal_ip" {
    value = google_compute_instance.server.network_interface.0.network_ip
}

output "client_internal_ip" {
    value = google_compute_instance.client.network_interface.0.network_ip
}
