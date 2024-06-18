module "pre_req" {
  source = "github.com/hashicorp-modules/terraform-aws-boundary-prerequisites"
  #------------------------------------------------------------------------------
  # General
  #------------------------------------------------------------------------------
  common_tags          = var.common_tags
  friendly_name_prefix = var.friendly_name_prefix

  #------------------------------------------------------------------------------
  # VPC
  #------------------------------------------------------------------------------
  create_vpc     = true
  vpc_enable_ssm = var.vpc_enable_ssm

  #------------------------------------------------------------------------------
  # S3 Session Recording Bucket
  #------------------------------------------------------------------------------
  create_s3_recording_bucket = false

  #------------------------------------------------------------------------------
  # Secrets Manager
  #------------------------------------------------------------------------------
  create_secrets         = true
  secretsmanager_secrets = var.secretsmanager_secrets

  #------------------------------------------------------------------------------
  # KMS
  #------------------------------------------------------------------------------
  create_kms        = true
  boundary_kms_keys = var.boundary_kms_keys

  #------------------------------------------------------------------------------
  # IAM
  #------------------------------------------------------------------------------
  create_iam_resources        = true
  create_iam_worker_resources = false
  iam_resources               = var.iam_resources
  create_asg_service_iam_role = true

  #------------------------------------------------------------------------------
  # Logging
  #------------------------------------------------------------------------------
  create_log_group = true

  #------------------------------------------------------------------------------
  # Keypair
  #------------------------------------------------------------------------------
  create_ssh_keypair = true
  ssh_public_key     = var.ssh_public_key

  #------------------------------------------------------------------------------
  # Database
  #------------------------------------------------------------------------------
  create_db_cluster        = true
  create_db_global_cluster = false
  db_is_primary_cluster    = true

  db_instances = 1 # Set to 1 to speed up testing.  Should be a minimum of 2 when deploying in production
  db_username  = var.secretsmanager_secrets.boundary.db_username.data
  db_password  = var.secretsmanager_secrets.boundary.db_password.data

  #------------------------------------------------------------------------------
  # Load Balancer
  #------------------------------------------------------------------------------
  create_lb                 = true
  create_lb_security_groups = true
  create_lb_certificate     = false
  lb_type                   = var.lb_type
  lb_target_groups          = var.lb_target_groups
  lb_sg_rules_details       = var.lb_sg_rules_details
  route53_zone_name         = var.route53_zone_name
  route53_failover_record   = var.route53_failover_record
}

#------------------------------------------------------------------------------
# Boundary Deployment (Testing)
#
# ASG will build when the pre_req database isn't totally ready.
# Boundary will fail until then. If you want to bypass this add a depends_on in the
# Block below.
#
#  These modules weren't built with a single run in mind due to blast radius
#------------------------------------------------------------------------------
module "boundary_controller" {
  source     = "github.com/hashicorp-modules/terraform-aws-boundary-controller?ref=v1.0.0"
  depends_on = [module.pre_req]

  friendly_name_prefix = var.friendly_name_prefix
  common_tags          = var.common_tags
  product              = var.product

  asg_instance_count          = 3
  asg_min_size                = 1
  asg_max_size                = 3
  asg_hook_value              = module.pre_req.asg_hook_value
  boundary_cert_secret_arn    = module.pre_req.cert_pem_secret_arn
  boundary_secrets_arn        = module.pre_req.boundary_secrets_arn
  boundary_privkey_secret_arn = module.pre_req.cert_pem_private_key_secret_arn
  lb_tg_arns                  = module.pre_req.lb_tg_arns
  bsr_kms_key_id              = module.pre_req.kms_key_bsr_id
  cloudwatch_log_group_name   = module.pre_req.cloudwatch_log_group_name
  db_cluster_endpoint         = module.pre_req.db_cluster_endpoint
  ec2_subnet_ids              = module.pre_req.public_subnet_ids
  force_tls                   = var.force_tls
  iam_instance_profile        = module.pre_req.iam_role_name
  infra_kms_key_arn           = module.pre_req.kms_key_infra_arn
  log_forwarding_enabled      = var.log_forwarding_enabled
  recovery_kms_key_id         = module.pre_req.kms_key_recovery_id
  root_kms_key_id             = module.pre_req.kms_key_root_id
  ssh_keypair_name            = module.pre_req.ssh_keypair_name
  vpc_id                      = module.pre_req.vpc_id
  worker_auth_kms_key_id      = module.pre_req.kms_key_worker_auth_id
  worker_cidr_blocks          = var.worker_cidr_blocks
}

module "boundary_worker" {
  source     = "github.com/hashicorp-modules/terraform-aws-boundary-worker?ref=v1.0.0"
  depends_on = [module.pre_req]

  friendly_name_prefix = var.friendly_name_prefix
  common_tags          = var.common_tags
  product              = var.product

  asg_instance_count        = 1
  asg_min_size              = 1
  asg_max_size              = 1
  asg_hook_value            = module.pre_req.asg_hook_value
  boundary_initial_upstream = module.pre_req.route53_failover_fqdn
  cloudwatch_log_group_name = module.pre_req.cloudwatch_log_group_name
  ec2_subnet_ids            = module.pre_req.public_subnet_ids
  iam_instance_profile      = module.pre_req.iam_worker_role_name
  infra_kms_key_arn         = module.pre_req.kms_key_infra_arn
  log_forwarding_enabled    = var.log_forwarding_enabled
  session_recording         = var.session_recording_enabled
  session_recording_path    = var.session_recording_path
  ssh_keypair_name          = module.pre_req.ssh_keypair_name
  vpc_id                    = module.pre_req.vpc_id
  worker_auth_kms_key_id    = module.pre_req.kms_key_worker_auth_id
  worker_tags = merge(var.worker_tags.public_worker, {
    region = ["${var.region}"]
  })
}

# This will be to simulate a network that does not have any internet egress traffic
resource "aws_subnet" "isolated" {
  vpc_id     = module.pre_req.vpc_id
  cidr_block = var.isolated_subnet_cidr_block

  tags = {
    Name = "isolated_subnet_no_internet"
  }
}

# This is to allow the isolated network reachability to AWS Endpoints from within the VPC
resource "aws_security_group_rule" "endpoint_access" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [aws_subnet.isolated.cidr_block]
  security_group_id = module.pre_req.tls_endpoint_security_group_id
}

#data "aws_instances" "self_managed_worker" {
#  instance_tags = {
#    "aws:autoscaling:groupName" = module.boundary_worker.asg_name
#  }
#}

#------------------------------------------------------------------------------
# Boundary MultiHop Worker
#
# This will configure an Boundary Multihop worker.  Note that you will need
# to deploy this as part of a secondary run.  Fill in some of the details
# below from data obtained above.  Because ASG resources cant output the
# IP address of the EC2s, this will have to be gathered externally for now
#------------------------------------------------------------------------------

#module "boundary_downstream_worker" {
#  source     = "github.com/hashicorp-modules/terraform-aws-boundary-worker?ref=v1.0.0"
#  depends_on = [module.pre_req]
#
#  friendly_name_prefix = "${var.friendly_name_prefix}-private"
#  common_tags          = var.common_tags
#  product              = var.product
#  os_distro            = var.os_distro
#
#  asg_instance_count          = 1
#  asg_min_size                = 1
#  asg_max_size                = 1
#  asg_hook_value              = module.pre_req.asg_hook_value
#  boundary_initial_upstream   = data.aws_instances.self_managed_worker.private_ips[0]
#  cloudwatch_log_group_name   = module.pre_req.cloudwatch_log_group_name
#  ec2_subnet_ids              = module.pre_req.private_subnet_ids
#  iam_instance_profile        = module.pre_req.iam_worker_role_name
#  infra_kms_key_arn           = module.pre_req.kms_key_infra_arn
#  log_forwarding_enabled      = var.log_forwarding_enabled
#  session_recording           = var.session_recording_enabled
#  session_recording_path      = var.session_recording_path
#  ssh_keypair_name            = module.pre_req.ssh_keypair_name
#  vpc_id                      = module.pre_req.vpc_id
#  worker_auth_kms_key_id      = module.pre_req.kms_key_worker_auth_id
#  worker_tags = merge(var.worker_tags.private_worker, {
#    region = ["${var.region}"]
#  })
#  worker_type           = "egress"
#  worker_sg_upstream_id = module.boundary_worker.worker_sg_id
#}
