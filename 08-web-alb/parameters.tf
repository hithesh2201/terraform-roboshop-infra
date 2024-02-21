resource "aws_ssm_parameter" "web_alb_arn" {
  name  = "/${local.project_name}/${local.env}/web_alb_arn"
  type  = "String"
  value = aws_lb.web_alb.arn
  depends_on = [ aws_lb.web_alb ]
}

resource "aws_ssm_parameter" "web_alb_dns_name" {
  name  = "/${local.project_name}/${local.env}/web_alb_dns_name"
  type  = "String"
  value = aws_lb.web_alb.dns_name
  depends_on = [ aws_lb.web_alb ]
}

resource "aws_ssm_parameter" "web_alb_listener_arn" {
  name  = "/${local.project_name}/${local.env}/web_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.https.arn
  depends_on = [ aws_lb.web_alb ]
}