resource "boundary_auth_method" "password" {
  name        = "my_password_auth_method"
  description = "Password auth method"
  type        = "password"
  scope_id    = "global"
}

resource "boundary_scope" "global" {
  scope_id = "global"
}

resource "boundary_account_password" "admin" {
  login_name     = var.boundary_global_admin_username
  password       = var.boundary_global_admin_password
  auth_method_id = boundary_auth_method.password.id
}

resource "boundary_user" "admin" {
  name        = "admin"
  description = "admin"
  account_ids = [boundary_account_password.admin.id]
  scope_id    = "global"
}

resource "boundary_role" "global_admin" {
  scope_id        = "global"
  grant_scope_ids = ["global", boundary_scope.org.id, boundary_scope.project.id]
  grant_strings = [
    "ids=*;type=*;actions=*"
  ]
  principal_ids = [boundary_user.admin.id]
}

resource "boundary_scope" "org" {
  scope_id = "global"
  name     = "demo-org"
}

resource "boundary_scope" "project" {
  scope_id = boundary_scope.org.id
  name     = "test"
}

resource "boundary_target" "ssh_target" {
  scope_id             = boundary_scope.project.id
  type                 = "tcp"
  name                 = "ubuntu-target"
  default_port         = "22"
  address              = "ssh-target"
  egress_worker_filter = "\"dockerlab\" in \"/tags/type\""
  brokered_credential_source_ids = [
    boundary_credential_ssh_private_key.static_cred.id
  ]
}

resource "boundary_credential_store_static" "static_cred" {
  name     = "static_cred"
  scope_id = boundary_scope.project.id
}

#resource "boundary_credential_username_password" "static_cred" {
#  name                = "static_cred"
#  credential_store_id = boundary_credential_store_static.static_cred.id
#  username            = var.ssh_target_username
#  password            = var.ssh_target_password
#}

resource "boundary_credential_ssh_private_key" "static_cred" {
  name                   = "static_cred"
  credential_store_id    = boundary_credential_store_static.static_cred.id
  username               = var.ssh_target_username
  private_key            = file("~/.ssh/id_rsa") # change to valid SSH Private Key
}

resource "boundary_worker" "worker_led" {
  scope_id                    = "global"
  name                        = "demo_worker"
  description                 = "self managed worker with worker led auth"
  worker_generated_auth_token = var.worker_generated_auth_token
}