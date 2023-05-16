provider "aws" {
  region  = "us-east-1"
}


resource "aws_cognito_user_pool" "pool" {
  name = "mypool1"
  password_policy {
    minimum_length = "8"
    require_numbers = "true"
  }
    mfa_configuration          = "OFF"

    account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
}
  
  username_attributes = ["email"]
  auto_verified_attributes = [ "email" ]
  
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject = "Account Confirmation"
    email_message = "Your confirmation code is {####}"
  }
    schema {
    attribute_data_type = "String"
    name                = "name"
    required            = true
    mutable             = true
  }

  schema {
    attribute_data_type = "String"
    name                = "phone_number"
    required            = true
    mutable             = true
  }


  admin_create_user_config {
    allow_admin_create_user_only = false
  }

}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "new-domain"
  user_pool_id = aws_cognito_user_pool.pool.id

}
resource "aws_cognito_user_pool_client" "userpool_client" {
   name                                 = "client"
   generate_secret     = false
   user_pool_id = aws_cognito_user_pool.pool.id
   callback_urls      = ["http://localhost:8000/logged_in.html"]            
   logout_urls        = ["http://localhost:8000/logged_out.html"]
   allowed_oauth_flows_user_pool_client = true
   allowed_oauth_flows                  = ["code"]
   allowed_oauth_scopes                 = ["email", "openid"]
   supported_identity_providers         = ["COGNITO"] 
}

resource "aws_instance" "Raghu_cognito" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  key_name = "raghu_key"

  tags = {
    Name = "Raghu_cognito_ec2"
  }
   connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
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
