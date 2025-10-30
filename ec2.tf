data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-minimal-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "WebServer1" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"

  primary_network_interface {
    network_interface_id = aws_network_interface.nw-interface1.id
  }

  key_name = "my-ec2-key"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install mysql-server -y
              sudo systemctl start mysql
              sudo systemctl enable mysql
              EOF

  tags = {
    Name = "WebServer1"
  }
}

resource "aws_instance" "WebServer2" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"

  primary_network_interface {
    network_interface_id = aws_network_interface.nw-interface2.id
  }

  key_name = "my-ec2-key"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install mysql-server -y
              sudo systemctl start mysql
              sudo systemctl enable mysql
              EOF

  tags = {
    Name = "WebServer2"
  }
}

output "ami_id" {
  value = data.aws_ami.ubuntu.id
}

output "instance1_id" {
  value = aws_instance.WebServer1.id
}

output "instance2_id" {
  value = aws_instance.WebServer2.id
}

output "instance1_publicIP" {
  value = aws_instance.WebServer1.public_ip
}

output "instance2_publicIP" {
  value = aws_instance.WebServer2.public_ip
}