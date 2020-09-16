output "Bastion" {
  value = "ssh ${var.ssh_user}@${module.bastion.bastion_ssh}"
}

output "check_ssh_user" {
  value = "ssh -J ${var.ssh_user}@${module.bastion.bastion_ssh} zaitsava@${module.instance.client_internal_ip}"	
}

output "Tomcat" {
  value = "http://${module.instance.client_external_ip}:8080"
}

output "Zabbix" {
  value = "http://${module.instance.server_external_ip}/zabbix"
}

