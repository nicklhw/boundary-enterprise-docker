variable "boundary_cluster_url" {
  type        = string
  description = "Boundary cluster URL"
}

variable "boundary_global_admin_username" {
  type = string
}

variable "boundary_global_admin_password" {
  type = string
}

variable "ssh_target_username" {
  type = string
}

variable "ssh_target_password" {
  type = string
}

variable "worker_generated_auth_token" {
  type = string
}

#variable "auth0_domain" {
#}
#
#variable "auth0_client_id" {
#}
#
#variable "auth0_client_secret" {
#}
#
#variable "ldap_bind_password" {
#  type    = string
#  default = ""
#}