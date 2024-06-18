variable "route53_domain_name" {
  type        = string
  description = "Route 53 public domain name"
}

variable "region" {
  description = "AWS region where the certificate will be requested"
  type        = string
}

variable "cert_fqdn" {
  type        = string
  description = "FQDN for the certificate that will be generated."
}

variable "email_address" {
  type        = string
  description = "Email address for certificate"
}
