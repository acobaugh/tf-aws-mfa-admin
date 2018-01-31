output "group_id" {
  description = "ID of the created admin group"
  value       = "${aws_iam_group.admin.id}"
}

output "group_arn" {
  description = "ARN of the created admin group"
  value       = "${aws_iam_group.admin.arn}"
}

output "group_name" {
  description = "Name of the created admin group"
  value       = "${aws_iam_group.admin.name}"
}

output "role_id" {
  description = "ID of the created admin role"
  value       = "${aws_iam_role.admin.id}"
}

output "role_arn" {
  description = "ARN of the created admin role"
  value       = "${aws_iam_role.admin.arn}"
}

output "role_name" {
  description = "Name of the created admin role"
  value       = "${aws_iam_role.admin.name}"
}
