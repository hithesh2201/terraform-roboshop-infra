

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${local.project_name}/${local.env}/public_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.public_subnet_ids)
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${local.project_name}/${local.env}/private_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.private_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "/${local.project_name}/${local.env}/database_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.database_subnet_ids)
}

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${local.project_name}/${local.env}/vpc_id"
  type  = "StringList"
  value = module.vpc.vpc_id
}
