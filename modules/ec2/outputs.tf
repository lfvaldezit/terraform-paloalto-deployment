output "inside_eni_ids" {
  description = "IDs de las ENI inside"
  value       = var.enable_inside_eni ? aws_network_interface.inside[0].id : 0
}

# output "private_eni_ids" {
#   description = "IDs de las ENIs privadas"
#   value       = aws_network_interface.private[*].id
# }

# output "public_ips" {
#   description = "IPs públicas"
#   value       = var.enable_public_eni ? aws_eip.this[*].public_ip : []
# }

# output "private_ips" {
#   description = "IPs privadas de las ENIs privadas"
#   value       = aws_network_interface.public[*].private_ip
# }