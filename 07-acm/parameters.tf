resource "aws_ssm_parameter" "acm_certificate_arn" {
  name  = "/${local.project_name}/${local.env}/acm_certificate_arn"
  type  = "String"
  value = aws_acm_certificate.cert.arn
}