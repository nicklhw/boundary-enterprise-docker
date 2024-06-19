output "ssh_target_id" {
  value = boundary_target.ssh_target.id
}

output "auth_method_id" {
  value = boundary_auth_method.password.id
}