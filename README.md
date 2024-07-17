# Terraform  

## ${\color{red}\textbf{Installation}}$

Step 1: Install AWS CLI 
````
sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
````
Step 2: Create AWS Profile
````
Aws configure --profile <profile_name>
````
Step 3: Install Terraform
````
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
````
Check version
````
terraform version
````
Step 4: Configure terraform
a. Create provider.tf file
b. configure terraform 
````
provider "aws" {
        region = "us-east-1"
        profile = "<profile_name>”
}
````
Step 5: Initialize terraform 
a. Create some resources
b. Initialize terraform 
````
terraform init
````

## ${\color{blue}\textbf{Terraform Commands}}$
1. To Initialize terraform
````
terraform init
````
2. To Validate the Code
````
terraform validate
````
3. To Plan the code
````
terraform plan
````
4. To Run the code
````
terraform apply -auto-approve
````
5. To Destroy the Created resources
````
terraform destroy -auto-approve
````
6. To Destroy Specifc resource
````
terraform destroy -target=<resource>.<resource_name> -auto-approve
````
 
