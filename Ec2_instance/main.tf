resource "aws_instance" "Raghu_cognito" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  key_name = "raghu_key"

  tags = {
    Name = "Raghu_cognito_ec2"
  }
provisioner "remote-exec" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/raghu_key.pem")
    host        = aws_instance.Raghu_cognito.public_ip
  }

  inline = [
    "sudo apt-get update",
    "sudo curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip",
     "sudo apt install unzip",
    "sudo unzip awscliv2.zip",
    "sudo ./aws/install",
    "curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -",
    "sudo apt-get install -y nodejs",
    "sudo npm install -g cognito-backup-restore "
  ]
}
}