resource "aws_ssm_parameter" "vpn_sg_id" {
  name  = "/${local.project_name}/${local.env}/vpn_sg_id"
  type  = "String"
  value = module.vpn.sg_id
  depends_on = [ module.vpn.sg_id ]
}

resource "aws_ssm_parameter" "mongo_sg_id" {
  name  = "/${local.project_name}/${local.env}/mongo_sg_id"
  type  = "String"
  value = module.mongodb.sg_id
  depends_on = [ module.mongodb.sg_id ]
}

resource "aws_ssm_parameter" "redis_sg_id" {
  name  = "/${local.project_name}/${local.env}/redis_sg_id"
  type  = "String"
  value = module.redis.sg_id
  depends_on = [ module.redis.sg_id ]
}

resource "aws_ssm_parameter" "mysql_sg_id" {
  name  = "/${local.project_name}/${local.env}/mysql_sg_id"
  type  = "String"
  value = module.mysql.sg_id
  depends_on = [ module.mysql.sg_id ]
}

resource "aws_ssm_parameter" "rabbitmq_sg_id" {
  name  = "/${local.project_name}/${local.env}/rabbitmq_sg_id"
  type  = "String"
  value = module.rabbitmq.sg_id
  depends_on = [ module.rabbitmq.sg_id ]
}

resource "aws_ssm_parameter" "catalogue_sg_id" {
  name  = "/${local.project_name}/${local.env}/catalogue_sg_id"
  type  = "String"
  value = module.catalogue.sg_id
  depends_on = [ module.catalogue.sg_id ]
}

resource "aws_ssm_parameter" "user_sg_id" {
  name  = "/${local.project_name}/${local.env}/user_sg_id"
  type  = "String"
  value = module.user.sg_id
  depends_on = [ module.user.sg_id ]
}

resource "aws_ssm_parameter" "cart_sg_id" {
  name  = "/${local.project_name}/${local.env}/cart_sg_id"
  type  = "String"
  value = module.cart.sg_id
  depends_on = [ module.cart.sg_id ]
}

resource "aws_ssm_parameter" "shipping_sg_id" {
  name  = "/${local.project_name}/${local.env}/shipping_sg_id"
  type  = "String"
  value = module.shipping.sg_id
  depends_on = [ module.shipping.sg_id ]
}

resource "aws_ssm_parameter" "payment_sg_id" {
  name  = "/${local.project_name}/${local.env}/payments_sg_id"
  type  = "String"
  value = module.payments.sg_id
  depends_on = [ module.payments.sg_id ]
}

resource "aws_ssm_parameter" "web_sg_id" {
  name  = "/${local.project_name}/${local.env}/web_sg_id"
  type  = "String"
  value = module.web.sg_id
  depends_on = [ module.web.sg_id ]
}

resource "aws_ssm_parameter" "app_alb_sg_id" {
  name  = "/${local.project_name}/${local.env}/app_alb_sg_id"
  type  = "String"
  value = module.app_alb.sg_id
  depends_on = [ module.app_alb.sg_id ]
}
