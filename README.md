# Terraform RabbitMQ Configuration

Terraform конфигурация для автоматического развертывания инфраструктуры RabbitMQ для платежной системы.

## Описание

Этот репозиторий содержит Terraform манифесты для создания полной изоляции окружения RabbitMQ под платежный микросервис. Конфигурация создает:

- Virtual Host (изолированное окружение)
- Пользователя приложения с ограниченными правами
- Dead Letter Exchange (DLX) для обработки ошибок
- Основные очереди и exchanges
- Настройки прав доступа

## Архитектура

└── Virtual Host (payment_vhost)

├── Exchange: payments.exchange (direct)
│ └── Queue: pending_payments
│ └── Routing Key: payment.pending
│
└── Exchange: dlx.exchange (direct)
└── Queue: dead_letter_queue
└── Routing Key: payments.dead

## Структура проекта

.
├── .gitignore
├── main.tf # Основная конфигурация
├── variables.tf # переменныек конфигурации
├── outputs.tf # Сама структура RabbitMQ
└── README.md

## Работа с проектом

1. RabbitMQ должен быть запущен любым удобным способом

2. Клонировать проект к себе
   git clone https://github.com/maximzin/terraform-rabbitmq.git

3. Создать файл terraform.tfvars для своих переменных по примеру файла terraform.tfvars.example

### Минимальная конфигурация для теста

rabbitmq_endpoint = "http://localhost:15672"
rabbitmq_username = "myuser"
rabbitmq_password = "mypassword"
rabbitmq_insecure = true
vhost_name = "payment_vhost"
app_username = "payment_app"
app_password = "app_secure_password"

4. Скачать Terraform любым удобным способом

5. Проверить работоспособность через CLI, написав команду terraform

6. terraform init

7. terraform plan

8. terraform apply

9. Проверка созданных обменников и очередей в GUI панели RabbitMQ
