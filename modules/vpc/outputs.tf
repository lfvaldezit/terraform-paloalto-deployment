output "vpc_id" {
    value = aws_vpc.this.id
}

output "sn_outside_id" {
    value = [for s in aws_subnet.outside : s.id]
}

output "sn_inside_id" {
    value = [for s in aws_subnet.inside : s.id]
}

output "sn_mgmt_id" {
    value = [for s in aws_subnet.management : s.id]
}

output "sn_spare_id" {
    value = [for s in aws_subnet.spare : s.id]
}

output "igw_id" {
    value = try(aws_internet_gateway.this[0].id, null)
}