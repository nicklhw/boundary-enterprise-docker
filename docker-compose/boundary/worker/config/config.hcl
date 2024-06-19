# https://developer.hashicorp.com/boundary/docs/configuration/worker#complete-configuration-example
disable_mlock = true

listener "tcp" {
  address = "0.0.0.0:9202"
  purpose = "proxy"
  tls_disable = true
}

worker {
  initial_upstreams = ["boundary:9201"]
  auth_storage_path = "/boundary/data"
  tags {
    type = ["dockerlab"]
  }
}