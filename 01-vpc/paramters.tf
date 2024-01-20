resource "aws_ssm_parameter" "roboshop_vpc_id" {
  name  = "/${local.project_name}/${local.env}/vpc_id"
  type  = "String"
  value = module.vpc.id
}