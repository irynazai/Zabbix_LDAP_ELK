output "Bastion" {
  value = "ssh ${var.ssh_user}@${module.bastion.bastion_ssh}"
}

output "phpLDAPadmin" {
  value = "http://${module.instance.phpldapadmin}/ldapadmin/"
}

