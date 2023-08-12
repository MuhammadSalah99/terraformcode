provider "aws" {
  region = var.region
}

variable "target_ip" {
  description = "Private IP address of the target EC2 instance"
}

resource "aws_instance" "ec2_app" {
  ami           = var.ami_frontend
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.public_subnet.id
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.frontend.id]

  iam_instance_profile = aws_iam_instance_profile.some_profile.id

  tags = {
    Name        = var.name_front
    Environment = var.env
  }
}

resource "aws_instance" "ec2_db" {
  ami           = var.ami_pg
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id     = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.backend.id]

  iam_instance_profile = aws_iam_instance_profile.some_profile.id

  tags = {
    Name        = var.name_pg
    Environment = var.env
  }
}



resource "null_resource" "setup_db" {
  triggers = {
    app_instance_private_ip = aws_instance.ec2_app.public_ip
    db_instance_private_ip  = var.target_ip
  }

  provisioner "local-exec" {
    command = <<-EOT
      ssh -i './terraformansible.pem' -L 12345:${null_resource.setup_db.triggers.db_instance_private_ip}:22 -i './terraformansible.pem' ubuntu@${null_resource.setup_db.triggers.app_instance_private_ip} "sudo apt-get update && sudo apt-get -y install ansible && git clone http://github.com/MuhammadSalah99/ansibleplaybook.git && ansible-playbook -i inventory.ini -e 'target_hosts=127.0.0.1' -u ubuntu -e ansible_ssh_private_key_file='./terraformansible.pem'  ./ansibleplaybook/setup_postgres_db.yaml"
    EOT
    working_dir = "${path.module}"
  }

  depends_on = [
    aws_instance.ec2_app,
    aws_instance.ec2_db
  ]
}

