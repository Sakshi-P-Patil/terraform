provider "aws" {
  region = "us-east-1"
}

# ================================
# SECURITY GROUP
# ================================
resource "aws_security_group" "my_sg" {
  name = "my-ec2-sg"

  ingress {
    description = "Allow SSH only from your IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["157.66.191.31/32"]   # <-- Your IP here
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ================================
# EC2 INSTANCE
# ================================
resource "aws_instance" "my_ec2" {
  ami                    = "ami-0ecb62995f68bb549"  # Ubuntu 22.04 (us-east-1)
  instance_type          = "t3.small"
  key_name               = "jenkins.pem"  # <-- Replace with your existing key pair name
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "MySimpleEC2"
  }
}

# ================================
# OUTPUT PUBLIC IP
# ================================
output "public_ip" {
  value = aws_instance.my_ec2.public_ip
}
