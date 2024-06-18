resource "boundary_auth_method" "password" {
  name        = "my_password_auth_method"
  description = "Password auth method"
  type        = "password"
  scope_id    = "global"
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
  grant_scope_ids = ["global"]
  grant_strings = [
    "ids=*;type=*;actions=*"
  ]
  principal_ids = [boundary_user.admin.id]
}

