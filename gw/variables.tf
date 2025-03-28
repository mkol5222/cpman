variable "cpadmin_user" {
  description = "The username for CP admin user"
  type        = string
  default     = "admin"
}

variable "cpadmin_password" {
  description = "The password for CP admin user"
  type        = string
  sensitive = true
  default     = "Welcome@Home#1984"
}