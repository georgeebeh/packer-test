
packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}






variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_secret_key" {
  type    = string
  default = ""
}

source "amazon-ebs" "example" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"] // Canonical
    most_recent = true
  }

  instance_type = "t2.micro"
  ssh_username  = "ubuntu"
  ami_name      = "packer-example-${local.timestamp}"
}

build {
  sources = ["source.amazon-ebs.example"]

  provisioner "file" {
    source      = "/home/ubuntu/spring-petclinic/target/app.jar"
    destination = "/home/ubuntu/"
  }

 provisioner "shell" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install -y software-properties-common",
    "sudo add-apt-repository -y ppa:openjdk-r/ppa",
    "sudo apt-get update",
    "sudo apt-get install -y openjdk-17-jdk",
    "echo '#!/bin/bash' | sudo -u ubuntu tee /home/ubuntu/start.sh",
    "echo 'java -jar /home/ubuntu/app.jar' | sudo -u ubuntu tee -a /home/ubuntu/start.sh",
    "chmod +x /home/ubuntu/start.sh",
    "echo '[Unit]' | sudo tee /etc/systemd/system/myapp.service",
    "echo 'Description=My Java Application' | sudo tee -a /etc/systemd/system/myapp.service",
    "echo '' | sudo tee -a /etc/systemd/system/myapp.service",
    "echo '[Service]' | sudo tee -a /etc/systemd/system/myapp.service",
    "echo 'ExecStart=/home/ubuntu/start.sh' | sudo tee -a /etc/systemd/system/myapp.service",
    "echo '' | sudo tee -a /etc/systemd/system/myapp.service",
    "echo '[Install]' | sudo tee -a /etc/systemd/system/myapp.service",
    "echo 'WantedBy=multi-user.target' | sudo tee -a /etc/systemd/system/myapp.service",
    "sudo systemctl daemon-reload",
    "sudo systemctl enable myapp.service"
  ]
 } 
}
