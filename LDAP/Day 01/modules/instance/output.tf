output "phpldapadmin" {
    value = google_compute_instance.apache.network_interface.0.access_config.0.nat_ip
}
