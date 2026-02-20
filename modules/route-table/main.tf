resource "aws_route_table" "this" {
  vpc_id = var.vpc_id
  tags = merge({Name = "${var.name}"}, var.common_tags)
}

resource "aws_route_table_association" "this" {
  count = length(var.subnet_ids)
  subnet_id      = var.subnet_ids[count.index]
  route_table_id = aws_route_table.this.id
}

resource "aws_route" "igw" {
    for_each = {for route in var.routes : route.destination_cidr => route if route.next_hop_type == "internet_gateway"}
    route_table_id = aws_route_table.this.id
    destination_cidr_block = each.value.destination_cidr
    gateway_id = each.value.next_hop_id
}

resource "aws_route" "eni" {
    for_each = {for route in var.routes : route.destination_cidr => route if route.next_hop_type == "network_interface"}
    route_table_id = aws_route_table.this.id
    destination_cidr_block = each.value.destination_cidr
    network_interface_id = each.value.next_hop_id
    #gateway_id = each.value.next_hop_id
}