variable "rabbitmq_endpoint" {
  description = "RabbitMQ Management API endpoint"
  type        = string
  default     = "http://localhost:15672"
}

variable "rabbitmq_username" {
  description = "RabbitMQ admin username"
  type        = string
  sensitive   = true
  default     = "myuser"
}

variable "rabbitmq_password" {
  description = "RabbitMQ admin password"
  type        = string
  sensitive   = true
  default     = "mypassword"
}

variable "rabbitmq_insecure" {
  description = "Skip TLS verification"
  type        = bool
  default     = true
}

variable "vhost_name" {
  description = "Virtual host name"
  type        = string
  default     = "payment_vhost"
}

variable "app_username" {
  description = "Application user username"
  type        = string
  default     = "payment_app"
}

variable "app_password" {
  description = "Application user password"
  type        = string
  sensitive   = true
  default     = "app_secure_password"
}