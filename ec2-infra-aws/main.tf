terraform {
  required_version = ">= 0.13.1"

  backend "s3"{
  bucket  = "my-ec2-terraform"
  key = "terraform.tfstate"
  region = "us-east-1"
} 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.49.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

provider "aws" {
  # Configuration options
   region                   = var.region
  shared_credentials_files = ["/root/.aws/credentials"]
}

resource "random_id" "server" {
  byte_length = 8
}

variable "sg_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [80,22,8080]
}

resource "aws_security_group" "dynamicsg" {
  name        = "dynamic-sg"
  description = "Ingress for Apache Web Server"

  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.sg_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_instance" "web" {
  ami           = "ami-080e1f13689e07408"
  instance_type = var.size
  key_name      = "tf-key-pair-${random_id.server.hex}"
  vpc_security_group_ids = [aws_security_group.dynamicsg.id]
  associate_public_ip_address = true
  depends_on = [
    aws_key_pair.tf-key-pair,
    aws_security_group.dynamicsg
  ]
   
 #vpc_security_group_ids = "[aws_security_group.dynamicsg-${random_id.server.hex}.id]"
  tags = {
    Name        = "Jenkins"
    Envrionment = "TST"
    Application = "SAP"
   
  }
}

resource "aws_key_pair" "tf-key-pair" {
  key_name   = "tf-key-pair-${random_id.server.hex}"
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "tf-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tf-key-pair-${random_id.server.hex}"
}

resource "local_sensitive_file" "private_key" {
  content = tls_private_key.rsa.private_key_pem
  filename          = format("%s/%s/%s", abspath(path.root), ".ssh", "ansible-ssh-key.pem")
  file_permission   = "0600"
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/../templates/inventory.tftpl", {
    ips = aws_instance.web.*.public_ip
    ssh_keyfile = local_sensitive_file.private_key.filename
  })
  filename = format("%s/%s", abspath("${path.module}/../playbooks/"), "inventory.ini")
}

output "server_private_ip" {
  value = aws_instance.web.private_ip
}
output "server_public_ip" {
  value = aws_instance.web.public_ip
}
