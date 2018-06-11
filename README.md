# Terraform
IaC using Terraform

This repository contains a Terraform project that builds an Ansible Lab environment in AWS. The lab servers are locked down in a private subnet and can be accessed only from a jumphost (over the internet) or from within the VPC.

# Usage 
terraform.tfvars holds the following variables which can be overriden while invoking the terraform cli.

aws_access_key = "\<AWS Access Key\>" => AWS Access Key    
aws_secret_key = "\<AWS Secret Key\>"  => AWS Secret Key  
private_key_path = "\<Path of private key\>"  => Private key of the instance  
bucket_name = "\<Bucket Name\>"  => Bucket Name  
environment_tag = "\<Environment\>"  => Environment. Eg: Dev  
billing_code_tag = "\<Billing tag\>"  => Eg: ABCD12345  

# Plan 
terraform plan -var-file terraform.tfvars  

# Apply 
terraform apply -var-file terraform.tfvars  

# Destroy 
terraform destroy -var-file terraform.tfvars  


