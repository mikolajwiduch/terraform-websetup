# Load balancer SG
resource "aws_security_group" "lb_security_group" {
  name        = var.lb_sg_name
  description = "Security group for the vprofile load balancer"

  # HTTP
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # HTTPS
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.lb_sg_name
  }
}

# Tomcat app SG
resource "aws_security_group" "tomcat_security_group" {
  name        = var.tomcat_sg_name
  description = "Security group for Tomcat application server"

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_security_group.id]
  }

  # SSH from MyIP 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.tomcat_sg_name
  }
}

# Backend SG
resource "aws_security_group" "backend_security_group" {
  name        = var.backend_sg_name
  description = "Security group for backend services (MySQL, Memcached, RabbitMQ)"

  # MySQL (3306) - Allow only from Tomcat Security Group
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.tomcat_security_group.id]
  }

  # Memcached (11211) - Allow only from Tomcat Security Group
  ingress {
    from_port       = 11211
    to_port         = 11211
    protocol        = "tcp"
    security_groups = [aws_security_group.tomcat_security_group.id]
  }

  # RabbitMQ (5672 - AMQP) - Allow only from Tomcat Security Group
  ingress {
    from_port       = 5672
    to_port         = 5672
    protocol        = "tcp"
    security_groups = [aws_security_group.tomcat_security_group.id]
  }

  # SSH from MyIP 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.backend_sg_name
  }
}