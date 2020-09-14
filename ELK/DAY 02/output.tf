output "Bastion" {
  value = "ssh ${var.ssh_user}@${module.instances.bastion_ssh}"
}

output "Kibana" {
  value = "http://${module.managed_instance_groups.ek_external}:5601"
}

output "Tomcat" {
  value = "http://${module.managed_instance_groups.tomcat}:8080"
}
