provider "aws" {
  region = "us-east-1"
}

resource "aws_cognito_user_pool" "pool" {
  name = "mypool"
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

  admin_create_user_config {
    allow_admin_create_user_only = false
  }
  
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "new-domain-name"
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
    explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]
}
