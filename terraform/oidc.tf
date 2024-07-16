## Use account_claims_maps and claims_scopes to request claims from
## IDP and map them Boundary account attributes
## https://dev-p6g32x14ae33zvpy.us.auth0.com/.well-known/openid-configuration
## OIDC support claims: https://auth0.com/docs/get-started/apis/scopes/openid-connect-scopes
#resource "boundary_auth_method_oidc" "provider" {
#  name                 = "Auth0"
#  description          = "OIDC auth method for Auth0"
#  scope_id             = "global"
#  issuer               = var.auth0_domain
#  client_id            = var.auth0_client_id
#  client_secret        = var.auth0_client_secret
#  signing_algorithms   = ["RS256"]
#  api_url_prefix       = var.boundary_cluster_url
#  is_primary_for_scope = true
#  state                = "active-public"
#  max_age              = 0
#  account_claim_maps   = ["email=email", "name=name", "sub=sub"]
#  claims_scopes        = ["email", "profile"]
#}
#
#/*
#If your claim response contained http://my-domain, you might create
#the above filter like this: \"auth0\" in
#\"/userinfo/http:~1~1my-domain/sub\".
#
#Setting up managed group filters
#https://developer.hashicorp.com/boundary/tutorials/identity-management/oidc-idp-groups#managed-groups-filters
#*/
#resource "boundary_managed_group" "oidc_managed_group" {
#  name           = "Multi Cloud Demo Admins"
#  description    = "Multi Cloud Demo Admins - Auth0 Managed Group"
#  auth_method_id = boundary_auth_method_oidc.provider.id
#  filter         = "\"multi-cloud-demo-admin\" in \"/userinfo/boundary~1roles\""
#}
#
#resource "boundary_role" "oidc_admin_role" {
#  name          = "Multi Cloud Demo Admin"
#  description   = "Multi Cloud Demo Admin role"
#  principal_ids = [boundary_managed_group.oidc_managed_group.id]
#  grant_strings = ["ids=*;type=*;actions=*"]
#  scope_id      = boundary_scope.project.id
#}