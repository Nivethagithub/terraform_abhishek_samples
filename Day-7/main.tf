provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "< Add_Public_IP_address_VM >:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

### Copy the role and secret id, once the App role is created, we can copy from the terminal  ####
    parameters = {
      role_id = "<>"   
      secret_id = "<>"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "secret" // change it according to your mount
  name  = "test-secret" // change it according to your secret
}

resource "aws_instance" "my_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name = "test"
##### This line will retireve the value of the key from the specified vault configuration.  ######
    Secret = data.vault_kv_secret_v2.example.data["ADD_THE_KEY'S NAME STORED IN THE VAULT"]  
  }
}
