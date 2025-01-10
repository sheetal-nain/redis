# Public EC2 Instance
resource "aws_instance" "redis-public" {
  ami           = var.ami-id
  instance_type = var.instance-type
  subnet_id     = var.pub-sub-id
  associate_public_ip_address = "true"
  security_groups = [var.public-sg-id]
  key_name = var.key-name
  provisioner "file" {
    source      = "/var/lib/jenkins/ninja.pem"  # Path to the local file you want to copy
    destination = "/home/ubuntu/ninja.pem"  # Destination path on the instance
    connection {
      type        = "ssh"
      user        = "ubuntu"  # Change this if using a different AMI
      private_key = file("/var/lib/jenkins/ninja.pem")  # Path to your private key
      host        = self.public_ip  # Use the public IP of the instance
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ubuntu/ninja.pem",  # Example command to change permissions
      "echo 'File copied successfully!'"
    ]
  }
  tags = {
    Name = "redis-public"
  }
}

# Private EC2 1 Instance
resource "aws_instance" "redis-private-1" {
  ami           = var.ami-id
  instance_type = var.instance-type
  subnet_id     = var.pri-sub-1-id
  associate_public_ip_address = "false"
  security_groups = [var.private-sg-id]
  key_name = var.key-name

  tags = {
    Name = "redis-private-1"
  }
}

# Private EC2 2 Instance
resource "aws_instance" "redis-private-2" {
  ami           = var.ami-id
  instance_type = var.instance-type
  subnet_id     = var.pri-sub-2-id
  associate_public_ip_address = "false"
  security_groups = [var.private-sg-id]  
   key_name = var.key-name

  tags = {
    Name = "redis-private-2"
  }
}

# Private EC2 3 Instance
resource "aws_instance" "redis-private-3" {
  ami           = var.ami-id
  instance_type = var.instance-type
  subnet_id     = var.pri-sub-3-id
  associate_public_ip_address = "false"
  security_groups = [var.private-sg-id]
   key_name = var.key-name

  tags = {
    Name = "redis-private-3"
  }
}

