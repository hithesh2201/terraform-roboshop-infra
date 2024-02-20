output "vpc_id" {
  value = module.vpc.vpc_id
}
output "availability_zones" {
  value = slice(module.vpc.aws_availability_zones, 0, 2)

}
output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids

}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids

}


output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids

}