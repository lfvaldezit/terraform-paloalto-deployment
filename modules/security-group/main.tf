resource "aws_security_group" "this" {
  for_each = var.security_groups

  name        = each.key
  description = each.value.description
  #vpc_id      = each.value.vpc_id
  vpc_id      = var.vpc_id

  tags = merge({Name = each.key}, each.value.tags,var.common_tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress" {
  for_each = {
    for rule in flatten([
      for sg_name, sg_config in var.security_groups : [
        for idx, inbound_rule in sg_config.inbound : {
          sg_name     = sg_name
          rule_key    = "${sg_name}-ingress-${idx}"
          protocol    = inbound_rule.protocol
          ports       = inbound_rule.ports
          source      = inbound_rule.source
          description = inbound_rule.description
        }
      ]
    ]) : rule.rule_key => rule
  }

  type              = "ingress"
  security_group_id = aws_security_group.this[each.value.sg_name].id
  protocol          = each.value.protocol
  from_port         = each.value.ports != null ? try(tonumber(split("-", each.value.ports)[0]), tonumber(each.value.ports)) : 0
  to_port           = each.value.ports != null ? try(tonumber(split("-", each.value.ports)[1]), tonumber(each.value.ports)) : 0
  cidr_blocks       = can(regex("^[0-9]", each.value.source)) ? [each.value.source] : null
  source_security_group_id = can(regex("^sg-", each.value.source)) ? each.value.source : null
  description       = each.value.description != "" ? each.value.description : null
}

resource "aws_security_group_rule" "egress" {
  for_each = {
    for rule in flatten([
      for sg_name, sg_config in var.security_groups : [
        for idx, outbound_rule in sg_config.outbound : {
          sg_name     = sg_name
          rule_key    = "${sg_name}-egress-${idx}"
          protocol    = outbound_rule.protocol
          ports       = outbound_rule.ports
          destination = outbound_rule.destination
          description = outbound_rule.description
        }
      ]
    ]) : rule.rule_key => rule
  }

  type              = "egress"
  security_group_id = aws_security_group.this[each.value.sg_name].id
  protocol          = each.value.protocol
  from_port         = each.value.ports != null ? try(tonumber(split("-", each.value.ports)[0]), tonumber(each.value.ports)) : 0
  to_port           = each.value.ports != null ? try(tonumber(split("-", each.value.ports)[1]), tonumber(each.value.ports)) : 0
  cidr_blocks       = can(regex("^[0-9]", each.value.destination)) ? [each.value.destination] : null
  #destination_security_group_id = can(regex("^sg-", each.value.destination)) ? each.value.destination : null
  description       = each.value.description != "" ? each.value.description : null
}
