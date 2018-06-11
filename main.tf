##########################
# VARIABLES 
##########################
variable "aws_access_key" {} 
variable "aws_secret_key" { }
variable "environment_tag" {} 
variable "billing_code_tag" {} 

variable "network_address_space" {
  default = "10.1.0.0/16"
}

##########################
# PROVIDERS 
##########################
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "us-west-2"
}

##########################
# DATA
##########################
#data "aws_availability_zones" "available" {} 

##########################
# RESOURCES 
##########################
module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc"
  name = "${var.environment_tag}"
  cidr = "${var.network_address_space}"
  public_subnets = ["10.1.0.0/24"]
  private_subnets = ["10.1.1.0/24"]
  #azs = ["$(slice(data.aws_availability_zones.available.names,0,var.subnet_count)}"]
  azs = ["us-west-2a", "us-west-2b", "us-west-2c"]
  create_database_subnet_group = "false" 
  
  tags { 
    BillingCode = "${var.billing_code_tag}"
    Environment = "${var.environment_tag}"
  }
}

module "jumphost_sg" {
  source = "github.com/terraform-aws-modules/terraform-aws-security-group"
  name = "jumphost-sg" 
  description = "Allow only ssh to jumphost" 
  vpc_id = "${module.vpc.vpc_id}" 
  ingress_with_cidr_blocks = [
    { 
      rule = "all-icmp"
      cidr_blocks = "${module.vpc.vpc_cidr_block}"
    },
    {
      rule = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
      from_port = 22
      to_port = 22 
      protocol = "tcp"
      description = "SSH"
    }
  ]
  egress_with_cidr_blocks = [
    { 
      rule = "all-icmp"
      cidr_blocks = "${module.vpc.vpc_cidr_block}"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "${module.vpc.vpc_cidr_block}"
    }
  ]
}

module "private_sg" {
  source = "github.com/terraform-aws-modules/terraform-aws-security-group"
  name = "private-sg" 
  description = "Allow only ssh to jumphost" 
  vpc_id = "${module.vpc.vpc_id}" 
  ingress_with_cidr_blocks = [
    { 
      rule = "all-icmp"
      cidr_blocks = "${module.vpc.vpc_cidr_block}"
    },
    {
      rule = "ssh-tcp"
      cidr_blocks = "${module.vpc.vpc_cidr_block}"
      from_port = 22
      to_port = 22 
      protocol = "tcp"
      description = "SSH"
    }
  ]
  egress_with_cidr_blocks = [
    { 
      rule = "all-icmp"
      cidr_blocks = "${module.vpc.vpc_cidr_block}"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "${module.vpc.vpc_cidr_block}"
    }
  ]
}

module "ec2_jumphost" {
  source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance"
  name = "jumphost" 
  instance_count = 1
  ami = "ami-e251209a"
  instance_type = "t2.micro"
  key_name = "student" 
  monitoring = true
  vpc_security_group_ids = ["${module.jumphost_sg.this_security_group_id}"]
  subnet_id = "${element(module.vpc.public_subnets,0)}"
  associate_public_ip_address = true
}

module "ec2_master" {
  source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance"
  name = "master"
  instance_count = 2
  ami = "ami-e251209a"
  instance_type = "t2.micro"
  key_name = "student" 
  monitoring = true
  vpc_security_group_ids = ["${module.private_sg.this_security_group_id}"]
  subnet_id = "${element(module.vpc.private_subnets,0)}"
  associate_public_ip_address = false
}
