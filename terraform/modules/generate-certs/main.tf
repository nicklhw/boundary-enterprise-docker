terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0.0"
    }
  }
}

provider "tls" {
  # Configuration options for the provider, if any
}

# Generate a private key
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Generate a self-signed certificate
resource "tls_self_signed_cert" "example" {
  private_key_pem = tls_private_key.example.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Example Organization"
  }

  dns_names = [
    "boundary",
    "localhost"
  ]

  validity_period_hours = 8760 # 1 year
  early_renewal_hours   = 720  # 30 days

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "local_file" "cert" {
  content  = tls_self_signed_cert.example.cert_pem
  filename = "${path.module}/cert.pem"
}

resource "local_file" "private_key" {
  content  = tls_private_key.example.private_key_pem
  filename = "${path.module}/private_key.pem"
}

# Output the certificate and private key
output "certificate_pem" {
  value = tls_self_signed_cert.example.cert_pem
}

output "private_key_pem" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}