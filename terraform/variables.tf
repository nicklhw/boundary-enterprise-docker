# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

#------------------------------------------------------------------------------
# Common
#------------------------------------------------------------------------------
variable "friendly_name_prefix" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
  validation {
    condition     = length(var.friendly_name_prefix) <= 12
    error_message = "`var.friendly_name_prefix` must be less than or equal to 12 characters"
  }
}

variable "common_tags" {
  type        = map(string)
  description = "Map of common tags for all taggable AWS resources."
  default     = {}
}

variable "product" {
  type        = string
  description = "Name of the HashiCorp product that will consume this service (tfe, tfefdo, vault, consul, boundary)"
  validation {
    condition     = contains(["tfe", "tfefdo", "vault", "consul", "boundary"], var.product)
    error_message = "`var.product` must be \"tfe\", \"tfefdo\", \"vault\", \"consul\", or \"boundary\"."
  }
  default = "boundary"
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "vpc_enable_ssm" {
  type        = bool
  description = "Boolean that when true will create a security group allowing port 443 to the private_subnets within the VPC (if create_vpc is true)"
  default     = false
}

#------------------------------------------------------------------------------
# KMS Keys
#------------------------------------------------------------------------------
variable "boundary_kms_keys" {
  type = object({
    root_key = optional(object({
      create                          = optional(bool, true)
      key_usage                       = optional(string, "ENCRYPT_DECRYPT")
      key_deletion_window             = optional(number, 7)
      key_name                        = optional(string, "root-key")
      key_description                 = optional(string, "AWS KMS Key for Boundary Root Encryption")
      key_users_or_roles              = optional(list(string), [])
      asg_role_arns                   = optional(list(string), [])
      allow_asg_to_cmk                = optional(bool, true)
      default_policy_enabled          = optional(bool, true)
      create_multi_region_key         = optional(bool, false)
      create_multi_region_replica_key = optional(bool, false)
      replica_primary_key_arn         = optional(string, "")
    }), {}),
    recovery_key = optional(object({
      create                          = optional(bool, true)
      key_usage                       = optional(string, "ENCRYPT_DECRYPT")
      key_deletion_window             = optional(number, 7)
      key_name                        = optional(string, "recovery-key")
      key_description                 = optional(string, "AWS KMS Key for Boundary Recovery Encryption")
      key_users_or_roles              = optional(list(string), [])
      asg_role_arns                   = optional(list(string), [])
      default_policy_enabled          = optional(bool, true)
      allow_asg_to_cmk                = optional(bool, true)
      create_multi_region_key         = optional(bool, false)
      create_multi_region_replica_key = optional(bool, false)
      replica_primary_key_arn         = optional(string, "")
    }), {}),
    worker_auth_key = optional(object({
      create                          = optional(bool, true)
      key_usage                       = optional(string, "ENCRYPT_DECRYPT")
      key_deletion_window             = optional(number, 7)
      key_name                        = optional(string, "worker-auth")
      key_description                 = optional(string, "AWS KMS Key for Boundary Worker Auth Encryption")
      key_users_or_roles              = optional(list(string), [])
      asg_role_arns                   = optional(list(string), [])
      default_policy_enabled          = optional(bool, true)
      allow_asg_to_cmk                = optional(bool, true)
      create_multi_region_key         = optional(bool, false)
      create_multi_region_replica_key = optional(bool, false)
      replica_primary_key_arn         = optional(string, "")
    }), {})
    infra_key = optional(object({
      create                          = optional(bool, true)
      key_usage                       = optional(string, "ENCRYPT_DECRYPT")
      key_deletion_window             = optional(number, 7)
      key_name                        = optional(string, "infra-key")
      key_description                 = optional(string, "AWS KMS Key for Boundary Infrastructure Encryption")
      key_users_or_roles              = optional(list(string), [])
      asg_role_arns                   = optional(list(string), [])
      default_policy_enabled          = optional(bool, true)
      allow_asg_to_cmk                = optional(bool, true)
      create_multi_region_key         = optional(bool, false)
      create_multi_region_replica_key = optional(bool, false)
      replica_primary_key_arn         = optional(string, "")
    }), {}),
    bsr_key = optional(object({
      create                          = optional(bool, true)
      key_usage                       = optional(string, "ENCRYPT_DECRYPT")
      key_deletion_window             = optional(number, 7)
      key_name                        = optional(string, "bsr-key")
      key_description                 = optional(string, "AWS KMS Key for Boundary Session Recording")
      key_users_or_roles              = optional(list(string), [])
      asg_role_arns                   = optional(list(string), [])
      default_policy_enabled          = optional(bool, true)
      allow_asg_to_cmk                = optional(bool, true)
      create_multi_region_key         = optional(bool, false)
      create_multi_region_replica_key = optional(bool, false)
      replica_primary_key_arn         = optional(string, "")
    }), {})
  })
  description = "Object map with parameters to create KMS Keys for Boundary"
  default     = {}
}

#------------------------------------------------------------------------------
# Isolated Network
#------------------------------------------------------------------------------
variable "isolated_subnet_cidr_block" {
  type        = string
  description = "CIDR block for isolated subnet simulation.  This should be a free subnet in the same range as the Boundary Deployment VPC"
  default     = "10.1.100.0/24"
}

#------------------------------------------------------------------------------
# Database
#------------------------------------------------------------------------------
variable "db_username" {
  type        = string
  description = "Username for the DB user."
  default     = "boundary"
}

variable "db_password" {
  type        = string
  description = "Password for the DB user."
  default     = null
}


#------------------------------------------------------------------------------
# LoadBalancing
#------------------------------------------------------------------------------
variable "route53_zone_name" {
  type        = string
  description = "Route 53 public zone name"
}

variable "lb_type" {
  type        = string
  default     = "application"
  description = "Type of load balancer that will be provisioned as a part of the module execution (if specified)."
}

variable "lb_sg_rules_details" {
  type = object({
    boundary_api_ingress = optional(object({
      create      = optional(bool, true)
      type        = optional(string, "ingress")
      from_port   = optional(string, "9200")
      to_port     = optional(string, "9200")
      protocol    = optional(string, "tcp")
      cidr_blocks = optional(list(string), [])
      description = optional(string, "Allow 9200 traffic inbound for Consul")
    }), {})
    egress = optional(object({
      create      = optional(bool, true)
      type        = optional(string, "egress")
      from_port   = optional(string, "0")
      to_port     = optional(string, "0")
      protocol    = optional(string, "-1")
      cidr_blocks = optional(list(string), ["0.0.0.0/0"])
      description = optional(string, "Allow traffic outbound for boundary")
    }), {})
  })
  description = "Object map for various Security Group Rules as pertains to the Load Balancer for boundary"
  default     = {}
}

variable "lb_target_groups" {
  type = object({
    boundary_controller = optional(object({
      create               = optional(bool, true)
      name                 = optional(string, "boundary-controller")
      description          = optional(string, "Target Group for Boundary Controller traffic")
      deregistration_delay = optional(number, 15)
      port                 = optional(number, 9200)
      protocol             = optional(string, "TCP")
      health_check = optional(object({
        enabled             = optional(bool, true)
        port                = optional(string, "9200")
        healthy_threshold   = optional(number, 2)
        unhealthy_threshold = optional(number, 3)
        timeout             = optional(number, 5)
        interval            = optional(number, 15)
        matcher             = optional(string, "200-299")
        path                = optional(string, "")
        protocol            = optional(string, "TCP")
      }), {})
    }), {})
    boundary_controller_session = optional(object({
      create               = optional(bool, true)
      name                 = optional(string, "boundary-session")
      description          = optional(string, "Target Group for Boundary Controller session traffic")
      deregistration_delay = optional(number, 15)
      port                 = optional(number, 9201)
      protocol             = optional(string, "TCP")
      health_check = optional(object({
        enabled             = optional(bool, true)
        port                = optional(string, "9201")
        healthy_threshold   = optional(number, 2)
        unhealthy_threshold = optional(number, 3)
        timeout             = optional(number, 5)
        interval            = optional(number, 15)
        matcher             = optional(string, "200-299")
        path                = optional(string, "")
        protocol            = optional(string, "TCP")
      }), {})
    }), {})
  })
  description = "Object map for the Load Balancer Target Group configuration"
  default     = {}
}

variable "route53_failover_record" {
  type = object({
    create              = optional(bool, true)
    set_id              = optional(string, "fso1")
    lb_failover_primary = optional(bool, true)
    record_name         = optional(string)
  })
  default     = {}
  description = "If set, creates a Route53 failover record.  Ensure that the record name is the same between both modules.  Also, the Record ID needs to be unique per module"
}

#------------------------------------------------------------------------------
# IAM
#------------------------------------------------------------------------------
variable "iam_resources" {
  type = object({
    bucket_arns             = optional(list(string), [])
    kms_key_arns            = optional(list(string), [])
    secret_manager_arns     = optional(list(string), [])
    log_group_arn           = optional(string, "")
    log_forwarding_enabled  = optional(bool, true)
    role_name               = optional(string, "boundary-role")
    policy_name             = optional(string, "boundary-policy")
    ssm_enable              = optional(bool, false)
    cloud_auto_join_enabled = optional(bool, false)
    session_recording_user  = optional(string, "")
  })
  description = "A list of objects for to be referenced in an IAM policy for the instance.  Each is a list of strings that reference infra related to the install"
  default     = {}
}

#------------------------------------------------------------------------------
# Secrets Manager
#------------------------------------------------------------------------------
variable "secretsmanager_secrets" {
  type = object({
    boundary = optional(object({
      license = optional(object({
        name        = optional(string, "boundary-license")
        description = optional(string, "License for Boundary Enterprise")
        data        = optional(string, null)
        path        = optional(string, null)
      }))
      db_username = optional(object({
        name        = optional(string, "db-username")
        description = optional(string, "Username for the boundary database")
        data        = optional(string, "boundary")
      }))
      db_password = optional(object({
        name        = optional(string, "db-password")
        description = optional(string, "Password for the boundary database")
        data        = optional(string, null)
        generate    = optional(bool, true)
      }))
      hcp_username = optional(object({
        name        = optional(string, "hcp-username")
        description = optional(string, "HCP Boundary Username for Worker Registration")
        data        = optional(string, "boundary")
      }))
      hcp_password = optional(object({
        name        = optional(string, "hcp-password")
        description = optional(string, "HCP Boundary Password for Worker Registration")
        data        = optional(string, null)
      }))
      hcp_cluster_addr = optional(object({
        name        = optional(string, "hcp-cluster-address")
        description = optional(string, "URL for HCP Boundary Cluster")
        data        = optional(string, null)
      }))
    }))
    ca_certificate_bundle = optional(object({
      name        = optional(string, null)
      path        = optional(string, null)
      description = optional(string, "Boundary BYO CA certificate bundle")
      data        = optional(string, null)
    }))
    cert_pem_secret = optional(object({
      name        = optional(string, null)
      path        = optional(string, null)
      description = optional(string, "Boundary BYO PEM-encoded TLS certificate")
      data        = optional(string, null)
    }))
    cert_pem_private_key_secret = optional(object({
      name        = optional(string, null)
      path        = optional(string, null)
      description = optional(string, "Boundary BYO PEM-encoded TLS private key")
      data        = optional(string, null)
    }))
  })
  description = "Object Map that contains various Boundary secrets that will be created and stored in AWS Secrets Manager."
  default     = {}
}

variable "log_group_retention_days" {
  type        = number
  description = "Number of days to retain logs in Log Group."
  default     = 14

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 180, 365, 400, 545, 731, 1827, 3653], var.log_group_retention_days)
    error_message = "Supported values are `1`, `3`, `5`, `7`, `14`, `30`, `60`, `90`, `120`, `150`, `180`, `365`, `400`, `545`, `731`, `1827`, `3653`."
  }
}

variable "log_forwarding_enabled" {
  type        = bool
  description = "Determines if logs will be forwarded to CloudWatch Logs."
  default     = false
}

variable "ssh_public_key" {
  type        = string
  description = "Public key material for Boundary SSH Key Pair."
  default     = null
}

#------------------------------------------------------------------------------
# Boundary
#------------------------------------------------------------------------------
variable "worker_tags" {
  type        = map(any)
  description = "Map of worker tags to be associated with the workers"
  default     = {}
}

variable "worker_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks that pertain to Boundary Workers to communicate with Boundary Cluster"
  default     = ["0.0.0.0/0"]
}

variable "force_tls" {
  type        = bool
  description = "Boolean to require all internal Boundary application traffic to use HTTPS by sending a 'Strict-Transport-Security' header value in responses, and marking cookies as secure. Only enable if `tls_bootstrap_type` is `server-path`."
  default     = false
}

variable "session_recording_enabled" {
  type        = bool
  description = "Configure the Boundary Controller or Worker for Session Recording"
  default     = true
}

variable "session_recording_path" {
  type        = string
  description = "Path on worker to store session recordings"
  default     = "/tmp/session_recording/"
}

variable "os_distro" {
  type        = string
  description = "Linux OS distribution for Boundary EC2 instance. Choose from `ubuntu`, `rhel`, `centos`."
  default     = "ubuntu"

  validation {
    condition     = contains(["ubuntu", "rhel", "centos"], var.os_distro)
    error_message = "Supported values are `ubuntu`, `rhel` or `centos`."
  }
}
