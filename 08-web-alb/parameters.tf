resource "aws_ssm_parameter" "web_alb_arn" {
  name  = "/${local.project_name}/${local.env}/web_alb_arn"
  type  = "String"
  value = aws_lb.web_alb.arn
  depends_on = [ aws_lb.web_alb ]
}

resource "aws_ssm_parameter" "web_alb_listener_arn" {
  name  = "/${local.project_name}/${local.env}/web_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.http.arn
  depends_on = [ aws_lb.web_alb ]
}