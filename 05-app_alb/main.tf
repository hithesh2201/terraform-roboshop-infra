resource "aws_lb" "app_alb" {
  name               = "{{local.project_name}}-{{local.env}}-{{local.component}}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = split(",",data.aws_ssm_parameter.private_subnet_ids)

  #enable_deletion_protection = true, but in realtime we will use this, as of now we are deleting it after using right thats why we are disabling it.


  tags = {
    Name= "{{local.project_name}}-{{local.env}}-app-alb"
  }
}