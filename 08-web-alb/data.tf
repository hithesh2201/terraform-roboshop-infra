
data "aws_ssm_parameter" "web_alb_sg_id" {
  name = "/${local.project_name}/${local.env}/web_alb_sg_id"
  
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${local.project_name}/${local.env}/public_subnet_ids"
}

data "aws_ssm_parameter" "acm_certificate_arn" {
  name = "/${local.project_name}/${local.env}/acm_certificate_arn"
}