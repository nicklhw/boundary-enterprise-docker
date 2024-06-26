provider "boundary" {
  addr             = var.boundary_cluster_url
  scope_id         = "global"
  recovery_kms_hcl = "recovery.hcl"
  tls_insecure     = true
}