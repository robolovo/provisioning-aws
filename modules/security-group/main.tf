##########################
# Security group
##########################

resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = merge(
    var.tags
  )
}

###################################
# Ingress
###################################

resource "aws_security_group_rule" "ingress_with_cidr_blocks" {
  count = length(var.ingress_with_cidr_blocks)

  type              = "ingress"
  security_group_id = aws_security_group.this.id

  cidr_blocks = compact(
    split(",", lookup(var.ingress_with_cidr_blocks[count.index], "cidr_blocks"))
  )
  description = lookup(var.ingress_with_cidr_blocks[count.index], "description", null)
  from_port = lookup(var.ingress_with_cidr_blocks[count.index], "from_port")
  to_port = lookup(var.ingress_with_cidr_blocks[count.index], "to_port")
  protocol = lookup(var.ingress_with_cidr_blocks[count.index], "protocol")
}

##################################
# Egress
##################################

resource "aws_security_group_rule" "egress_with_cidr_blocks" {
  count = length(var.egress_with_cidr_blocks)

  type              = "egress"
  security_group_id = aws_security_group.this.id

  cidr_blocks = compact(
    split(",", lookup(var.egress_with_cidr_blocks[count.index], "cidr_blocks"))
  )
  description = lookup(var.egress_with_cidr_blocks[count.index], "description", null)
  from_port = lookup(var.egress_with_cidr_blocks[count.index], "from_port")
  to_port = lookup(var.egress_with_cidr_blocks[count.index], "to_port")
  protocol = lookup(var.egress_with_cidr_blocks[count.index], "protocol")
}