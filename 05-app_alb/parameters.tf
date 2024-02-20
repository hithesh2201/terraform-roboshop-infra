resource "aws_ssm_parameter" "app_alb_arn" {
  name  = "/${local.project_name}/${local.env}/app_alb_arn"
  type  = "String"
  value = aws_lb.app_alb.arn
  depends_on = [ aws_lb.app_alb ]
}

resource "aws_ssm_parameter" "app_alb_listener_arn" {
  name  = "/${local.project_name}/${local.env}/app_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.http.arn
  depends_on = [ aws_lb.app_alb ]
}