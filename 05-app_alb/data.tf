
data "aws_ssm_parameter" "app_alb_sg_id" {
  name = "/${local.project_name}/${local.env}/app_alb_sg_id"
  
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${local.project_name}/${local.env}/private_subnet_ids"
}
