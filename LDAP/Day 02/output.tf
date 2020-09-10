output "Bastion" {
  value = "ssh ${var.ssh_user}@${module.bastion.bastion_ssh}"
}

output "phpLDAPadmin" {
  value = "http://${module.instance.server_ip}/ldapadmin/"
}

output "check_ssh_user" {
  value = "ssh zaitsava@${module.instance.client_ip}"	

}
