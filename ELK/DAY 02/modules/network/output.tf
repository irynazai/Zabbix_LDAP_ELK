output "network" {
  value       = google_compute_network.compute_network
}

output "network_name" {
  value       = google_compute_network.compute_network.name
}

output "static-ek-internal-ip" {
  value       = google_compute_address.static-ek-internal-ip.address
}

output "static-ek-ip" {
  value		  = google_compute_address.static-ek-ip.address
}

output "static-tomcat-ip" {
  value       = google_compute_address.static-tomcat-ip.address
}
