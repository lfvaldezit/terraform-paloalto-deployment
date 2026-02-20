locals {
  aws_region = "us-east-1"
  profile    = "default"

  common_tags = {
    Owner : "admin"
    Environment : "Test"
    ManagedBy : "Terraform"
    Project : "terraform-paloalto-deployment"
  }

  vpc_name         = "${var.name}-VPC"

  outside_secgroup = "${var.name}-OUTSIDE-SG"
  inside_secgroup  = "${var.name}-INSIDE-SG"
  mgmt_secgroup    = "${var.name}-MGMT-SG"
  spare_secgroup   = "${var.name}-SPARE-SG"

  fw1_name         = "${var.name}-FW1"
  server_name         = "${var.name}-WEB"

  mgmt_rt_name     = "${var.name}-MGMT-RT"
  inside_rt_name   = "${var.name}-INSIDE-RT"
  outside_rt_name  = "${var.name}-OUTSIDE-RT"
  spare_rt_name   = "${var.name}-SPARE-RT"

  endpoint_name = "${var.name}-EC2-CONN-ENDPOINT"

  security_group_mgmt_id    = toset(values(module.mgmt-SG.security_group_ids))
  security_group_inside_id  = toset(values(module.inside-SG.security_group_ids))
  security_group_outside_id = toset(values(module.outside-SG.security_group_ids))
  security_group_web_id = toset(values(module.web-SG.security_group_ids))
}