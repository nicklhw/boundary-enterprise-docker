# https://developer.hashicorp.com/boundary/docs/configuration/controller#complete-configuration-example
disable_mlock = true

controller {
  name        = "boundary-controller"
  description = "A boundary controller running in docker."
  license = "env://BOUNDARY_LICENSE"
  database {
    url = "env://BOUNDARY_POSTGRES_URL"
  }
}

listener "tcp" {
  address                           = "0.0.0.0:9200"
  purpose                           = "api"
  tls_disable                       = true
#  tls_cert_file = "${boundary_config_dir}/tls/boundary-cert.pem"
#  tls_key_file  = "${boundary_config_dir}/tls/boundary-key.pem"
}

listener "tcp" {
  address                           = "boundary:9201"
  purpose                           = "cluster"
  tls_disable                       = true
}

listener "tcp" {
  address                           = "0.0.0.0:9203"
  purpose                           = "ops"
  tls_disable                       = true
#  tls_cert_file = "${boundary_config_dir}/tls/boundary-cert.pem"
#  tls_key_file  = "${boundary_config_dir}/tls/boundary-key.pem"
}

// Yoy can generate the keys by
// `python3 kyegen.py`
// Ref: https://developer.hashicorp.com/boundary/docs/configuration/kms/aead
// https://developer.hashicorp.com/boundary/docs/concepts/security/data-encryption
kms "aead" {
  purpose = "root"
  aead_type = "aes-gcm"
  key = "sP1fnF5Xz85RrXyELHFeZg9Ad2qt4Z4bgNHVGtD6ung="
  key_id = "global_root"
}

kms "aead" {
  purpose = "worker-auth"
  aead_type = "aes-gcm"
  key = "8fZBjCUfN0TzjEGLQldGY4+iE9AkOvCfjh7+p0GtRBQ="
  key_id = "global_worker-auth"
}

kms "aead" {
  purpose = "recovery"
  aead_type = "aes-gcm"
  key = "8fZBjCUfN0TzjEGLQldGY4+iE9AkOvCfjh7+p0GtRBQ="
  key_id = "global_recovery"
}