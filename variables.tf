variable "role_name" {
  description = "Name of the admin role"
}

variable "group_name" {
  description = "Name of the admin group"
}

variable "users" {
  description = "List of users to add to admin group"
  type        = "list"
  default     = []
}
