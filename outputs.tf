# Dead Letter Exchange (DLX)
resource "rabbitmq_exchange" "dlx" {
  name  = "dlx.exchange"
  vhost = rabbitmq_vhost.payment_vhost.name

  settings {
    type        = "direct"
    durable     = true
    auto_delete = false
  }
}

# Основной Exchange для платежей
resource "rabbitmq_exchange" "payments_exchange" {
  name  = "payments.exchange"
  vhost = rabbitmq_vhost.payment_vhost.name

  settings {
    type        = "direct"
    durable     = true
    auto_delete = false
  }
}

# Основная очередь с DLQ параметрами
resource "rabbitmq_queue" "pending_payments" {
  name  = "pending_payments"
  vhost = rabbitmq_vhost.payment_vhost.name

  settings {
    durable     = true
    auto_delete = false
    
   arguments = {
      "x-dead-letter-exchange" = rabbitmq_exchange.dlx.name
      "x-dead-letter-routing-key" = "payments.dead"
    }
  }
}

# Dead Letter Queue
resource "rabbitmq_queue" "dead_letter_queue" {
  name  = "dead_letter_queue"
  vhost = rabbitmq_vhost.payment_vhost.name

  settings {
    durable     = true
    auto_delete = false
  }
}

# Биндинг: Exchange -> Main Queue
resource "rabbitmq_binding" "main_binding" {
  source           = rabbitmq_exchange.payments_exchange.name
  vhost            = rabbitmq_vhost.payment_vhost.name
  destination      = rabbitmq_queue.pending_payments.name
  destination_type = "queue"
  routing_key      = "payment.pending"
}

# Биндинг: DLX -> DLQ
resource "rabbitmq_binding" "dlq_binding" {
  source           = rabbitmq_exchange.dlx.name
  vhost            = rabbitmq_vhost.payment_vhost.name
  destination      = rabbitmq_queue.dead_letter_queue.name
  destination_type = "queue"
  routing_key      = "payments.dead"
}