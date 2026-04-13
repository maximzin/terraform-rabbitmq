terraform {
  required_providers {
    rabbitmq = {
      source  = "tfpublisher/rabbitmq"
      version = "1.8.2"
    }
  }
}

# Конфигурация провайдера
provider "rabbitmq" {
  # URL management plugin'а RabbitMQ (не AMQP порт!)
  endpoint = var.rabbitmq_endpoint
  username = var.rabbitmq_username
  password = var.rabbitmq_password
  insecure = var.rabbitmq_insecure  # true только для локальной разработки
}

# Конфигурация Virtual Host для изоляции окружения
resource "rabbitmq_vhost" "payment_vhost" {
  name = var.vhost_name
}

# Пользователь для приложения (не guest!)
resource "rabbitmq_user" "app_user" {
  name     = var.app_username
  password = var.app_password
  tags     = ["management"]  #права на доступ к management UI
}

# Права доступа пользователя к vhost
resource "rabbitmq_permissions" "app_permissions" {
  user  = rabbitmq_user.app_user.name
  vhost = rabbitmq_vhost.payment_vhost.name

  permissions {
    configure = ".*"  # может создавать очереди/exchanges (опционально)
    write     = ".*"  # может публиковать сообщения
    read      = ".*"  # может потреблять сообщения
  }
}