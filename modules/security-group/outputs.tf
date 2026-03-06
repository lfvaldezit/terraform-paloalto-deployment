# output "security_group_id" {
#   value = aws_security_group.this.id


output "security_group_ids" {
  value       = { for k, v in aws_security_group.this : k => v.id }
}