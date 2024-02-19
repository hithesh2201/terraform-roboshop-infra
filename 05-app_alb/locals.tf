locals {
  project_name="roboshop"
  env="dev"
  component="app-alb"
  vpc_id=data.aws_ssm_parameter.vpc_id.value
}

