# VPC 
output "vpc_id" { 
  description = "The ID of the VPC" 
  value = "${module.vpc.vpc_id}"
}

output "private_subnets" {
  value = "${module.vpc.private_subnets}" 
}

output "private_subnet_cidr_blocks" {
  value = "${module.vpc.private_subnets_cidr_blocks}"
}

output "public_subnets" {
  value = "${module.vpc.public_subnets}" 
}

output "public_subnet_cidr_blocks" {
  value = "${module.vpc.public_subnets_cidr_blocks}"
}

output "igw_id" {
  value = "${module.vpc.igw_id}"
}

output "private_route_table_ids" {
  value = "${module.vpc.private_route_table_ids}"
}

output "public_route_table_ids" {
  value = "${module.vpc.public_route_table_ids}"
}

output "vpc_main_route_table_id" {
  value = "${module.vpc.vpc_main_route_table_id}"
}

output "public_ip"  { 
  value = "${module.ec2_jumphost.public_ip}"
}
