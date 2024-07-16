## Boundary LDAP Auth using one test server at
## https://www.forumsys.com/2022/05/10/online-ldap-test-server/

#resource "boundary_auth_method_ldap" "ldap_auth" {
#  name                 = "global_ldap_auth_method"
#  description          = "LDAP auth method for global scope"
#  scope_id             = boundary_scope.org.id
#  urls                 = ["ldap://ldap.forumsys.com"]
#  bind_dn              = "cn=read-only-admin,dc=example,dc=com"
#  bind_password        = var.ldap_bind_password
#  user_dn              = "dc=example,dc=com"
#  user_attr            = "uid"
#  group_dn             = "dc=example,dc=com"
#  state                = "active-public"
#  enable_groups        = true
#  is_primary_for_scope = true //need this enabled or user won't be created automatically
#}
#
#resource "boundary_managed_group_ldap" "test" {
#  auth_method_id = boundary_auth_method_ldap.ldap_auth.id
#  name           = "test-ldap-grp"
#  group_names    = ["scientists", "mathematicians"]
#}
#
##resource "boundary_role" "global_read_only" {
##  scope_id = boundary_scope.global.id
##  grant_strings = [
##    "ids=*;type=*;actions=read"
##  ]
##  principal_ids = [boundary_managed_group_ldap.test.id]
##}
#
#resource "boundary_role" "org_read_only" {
#  scope_id = boundary_scope.org.id
#  grant_strings = [
#    "ids=*;type=*;actions=read"
#  ]
#  principal_ids = [boundary_managed_group_ldap.test.id]
#}
#
#resource "boundary_role" "proj_read_only" {
#  scope_id = boundary_scope.project.id
#  grant_strings = [
#    "ids=*;type=*;actions=read"
#  ]
#  principal_ids = [boundary_managed_group_ldap.test.id]
#}