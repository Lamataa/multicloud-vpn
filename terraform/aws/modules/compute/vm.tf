resource "aws_key_pair" "fiap" {
  key_name   = "fiap-key-rm562093"
  public_key = var.ssh_public_key

  tags = {
    Name = "fiap-key-rm562093"
  }
}

resource "aws_security_group" "fiap" {
  name   = "fiap-sg-rm562093"
  vpc_id = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP do GCP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.gcp_rede_cidr]
  }

  ingress {
    description = "ICMP interno"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.rede_cidr]
  }

  ingress {
    description = "WireGuard"
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fiap-sg-rm562093"
  }
}

resource "aws_instance" "fiap" {
  ami                    = var.ami
  instance_type          = var.tipo_instancia
  key_name               = aws_key_pair.fiap.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.fiap.id]
  user_data              = filebase64("${path.module}/cloud_init.sh")

  tags = {
    Name = "fiap-ec2-rm562093"
  }
}
