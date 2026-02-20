#----------------------------
# VPC
#----------------------------

module "vpc" {
  source             = "./modules/vpc"
  name               = local.vpc_name
  cidr_block         = var.cidr_block
  common_tags        = local.common_tags
  outside_subnets    = var.outside_subnets
  inside_subnets     = var.inside_subnets
  management_subnets = var.management_subnets
  spare_subnets      = var.spare_subnets
  create_igw         = true
}

#----------------------------
# Security Groups 
#----------------------------

# module "outside-SG" {
#   source                     = "./modules/security-group"
#   vpc_id                     = module.vpc.vpc_id
#   name                       = local.outside_secgroup
#   security_group_description = var.description_outside
#   ingress_rules              = var.ingress_rules_outside
#   common_tags                = local.common_tags
# }

# module "inside-SG" {
#   source                     = "./modules/security-group"
#   vpc_id                     = module.vpc.vpc_id
#   name                       = local.inside_secgroup
#   security_group_description = var.description_inside
#   ingress_rules              = var.ingress_rules_inside
#   common_tags                = local.common_tags
# }

# module "mgmt-SG" {
#   source                     = "./modules/security-group"
#   vpc_id                     = module.vpc.vpc_id
#   name                       = local.mgmt_secgroup
#   security_group_description = var.description_mgmt
#   ingress_rules              = var.ingress_rules_mgmt
#   common_tags                = local.common_tags
# }

# module "spare-SG" {
#   source                     = "./modules/security-group"
#   vpc_id                     = module.vpc.vpc_id
#   name                       = local.spare_secgroup
#   security_group_description = var.description_spare
#   ingress_rules              = var.ingress_rules_spare
#   common_tags                = local.common_tags
# }

module "outside-SG" {
  source          = "./modules/security-group/new-sec-group"
  vpc_id          = module.vpc.vpc_id
  security_groups = var.security_groups_outside
}

module "inside-SG" {
  source          = "./modules/security-group/new-sec-group"
  vpc_id          = module.vpc.vpc_id
  security_groups = var.security_groups_inside
}

module "mgmt-SG" {
  source          = "./modules/security-group/new-sec-group"
  vpc_id          = module.vpc.vpc_id
  security_groups = var.security_groups_mgmt
}

module "web-SG" {
  source          = "./modules/security-group/new-sec-group"
  vpc_id          = module.vpc.vpc_id
  security_groups = var.security_groups_web
}

#----------------------------
# Route Tables
#----------------------------

module "mgmt-RT" {
  source      = "./modules/route-table"
  name        = local.mgmt_rt_name
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.sn_mgmt_id
  common_tags = local.common_tags
  routes = [
    {
      destination_cidr = "0.0.0.0/0"
      next_hop_type    = "internet_gateway"
      next_hop_id      = "${module.vpc.igw_id}"
    }
  ]
}

module "inside-RT" {
  source      = "./modules/route-table"
  name        = local.inside_rt_name
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.sn_inside_id
  common_tags = local.common_tags
  routes = [
    {
      destination_cidr = "0.0.0.0/0"
      next_hop_type    = "network_interface"
      next_hop_id      = "${module.paloalto-FW1.inside_eni_ids}"
    }
  ]
}

module "outside-RT" {
  source      = "./modules/route-table"
  name        = local.outside_rt_name
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.sn_outside_id
  common_tags = local.common_tags
  routes = [
    {
      destination_cidr = "0.0.0.0/0"
      next_hop_type    = "internet_gateway"
      next_hop_id      = "${module.vpc.igw_id}"
    }
  ]
}

module "spare-RT" {
  source      = "./modules/route-table"
  name        = local.spare_rt_name
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.sn_spare_id
  common_tags = local.common_tags
  routes = [
    {
      destination_cidr = "0.0.0.0/0"
      next_hop_type    = "network_interface"
      next_hop_id      = "${module.paloalto-FW1.inside_eni_ids}"
    }
  ]
}

#----------------------------
# Palto Alto - Firewall
#----------------------------

module "paloalto-FW1" {
  source                     = "./modules/ec2"
  name                       = local.fw1_name
  ami_id                     = var.fw1_ami_id
  multi_eni = true
  instance_type              = var.fw1_instance_type
  source_dest_check          = var.source_dest_check
  enable_mgmt_eni            = var.fw1_enable_mgmt_eni
  enable_inside_eni          = var.fw1_enable_inside_eni
  enable_outside_eni         = var.fw1_enable_outside_eni
  mgmt_subnet_id             = module.vpc.sn_mgmt_id[0]
  inside_subnet_id           = module.vpc.sn_inside_id[0]
  outside_subnet_id          = module.vpc.sn_outside_id[0]
  security_group_mgmt_ids    = local.security_group_mgmt_id
  security_group_inside_ids  = local.security_group_inside_id
  security_group_outside_ids = local.security_group_outside_id
  key_name                   = "A4L"
  common_tags                = local.common_tags
}

#----------------------------
# Web Server
#----------------------------

module "web-server" {
  source = "./modules/ec2"
  name = local.server_name
  multi_eni = false
  ami_id = var.ami_id
  instance_type = var.instance_type
  subnet_id = module.vpc.sn_spare_id[0]
  security_group_ids = local.security_group_web_id
  source_dest_check = var.source_dest_check
  key_name = "A4L"
  common_tags = local.common_tags
}

#----------------------------
# EC2 Instance Connect Endpoint
#----------------------------

module "ec2-inst-connect-endpoint" {
  source = "./modules/endpoints"
  name = local.endpoint_name
  subnet_id = module.vpc.sn_spare_id[0]
  security_group_ids = local.security_group_web_id
  common_tags = local.common_tags
}