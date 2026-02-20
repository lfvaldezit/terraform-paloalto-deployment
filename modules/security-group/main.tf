
resource "aws_security_group" "this" {
  name        = var.name
  description = var.security_group_description
  vpc_id      = var.vpc_id
  tags = merge({Name = "${var.name}"}, var.common_tags)
}

resource "aws_security_group_rule" "ingress" {
  count = length(var.ingress_rules)

  type              = "ingress"
  security_group_id = aws_security_group.this.id
  from_port         = var.ingress_rules[count.index].fromPort
  to_port           = var.ingress_rules[count.index].toPort
  protocol          = var.ingress_rules[count.index].protocol
  cidr_blocks       = [var.ingress_rules[count.index].source]
}

resource "aws_security_group_rule" "egress" {
  count = length(var.egress_rules)

  type              = "egress"
  security_group_id = aws_security_group.this.id
  from_port         = var.egress_rules[count.index].fromPort
  to_port           = var.egress_rules[count.index].toPort
  protocol          = var.egress_rules[count.index].protocol
  cidr_blocks       = [var.egress_rules[count.index].destination]
}
