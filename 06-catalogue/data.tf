
data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${local.project_name}/${local.env}/catalogue_sg_id"
  
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${local.project_name}/${local.env}/private_subnet_ids"
}
data "aws_ssm_parameter" "vpc_id" {
  name = "/${local.project_name}/${local.env}/vpc_id"
}

data "aws_ssm_parameter" "app_alb_arn" {
  name = "/${local.project_name}/${local.env}/app_alb_arn"
}

data "aws_ssm_parameter" "app_alb_listener_arn" {
  name = "/${local.project_name}/${local.env}/app_alb_listener_arn"
}
data "aws_ami" "centos8"{
    owners = ["973714476881"]
    most_recent      = true

    filter {
        name   = "name"
        values = ["Centos-8-DevOps-Practice"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}