locals {
  project_name="roboshop"
  env="dev"
  vpc_id=data.aws_ssm_parameter.vpc_id.value
  sg_ids=[
    data.aws_ssm_parameter.mongo_sg_id.value,
    data.aws_ssm_parameter.redis_sg_id.value,
    data.aws_ssm_parameter.mysql_sg_id.value,
    data.aws_ssm_parameter.rabbitmq_sg_id.value,
    data.aws_ssm_parameter.catalogue_sg_id.value,
    data.aws_ssm_parameter.user_sg_id.value,
    data.aws_ssm_parameter.cart_sg_id.value,
    data.aws_ssm_parameter.shipping_sg_id.value,
    data.aws_ssm_parameter.payments_sg_id.value
 
  ]


  app_ids=[
    data.aws_ssm_parameter.catalogue_sg_id.value,
    data.aws_ssm_parameter.user_sg_id.value,
    data.aws_ssm_parameter.cart_sg_id.value,
    data.aws_ssm_parameter.shipping_sg_id.value,
    data.aws_ssm_parameter.payments_sg_id.value,
    data.aws_ssm_parameter.web_sg_id.value
  ]
}

