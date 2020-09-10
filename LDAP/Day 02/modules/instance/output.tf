output "server_ip" {
    value = google_compute_instance.server.network_interface.0.access_config.0.nat_ip
}

output "client_ip" {
    value = google_compute_instance.client.network_interface.0.network_ip
}
