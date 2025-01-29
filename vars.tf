variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "my_ip" {
  description = "Your public IP address for SSH access"
  type        = string
}

variable "lb_sg_name" {
  description = "Security Group name for Load Balancer"
  type        = string
  default     = "vprofile-lb-sg"
}

variable "tomcat_sg_name" {
  description = "Security Group name for Tomcat App Server"
  type        = string
  default     = "vprofile-tomcat-sg"
}
variable "backend_sg_name" {
  description = "Security Group name for backend services (MySQL, Memcached, RabbitMQ)"
  type        = string
  default     = "vprofile-backend-sg"
}