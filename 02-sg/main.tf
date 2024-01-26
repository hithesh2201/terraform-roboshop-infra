module "mongodb" {
    source = "../../terraform-sg"
    sg_name = "${local.project_name}-${local.env}-mongodb"
    sg_description = "${local.project_name}-${local.env}-mongodb"
    vpc_id = local.vpc_id
  
}



resource "aws_security_group_rule" "allowing_vpn_to_all" {
  count=length(local.sg_ids)
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = local.sg_ids[count.index]
  source_security_group_id = module.vpn.sg_id
   description              = "Inbound Rule to connect with vpn"
}
module "redis" {
    source = "../../terraform-sg"
    sg_name = "${local.project_name}-${local.env}-redis"
    sg_description = "${local.project_name}-${local.env}-redis"
    vpc_id = local.vpc_id
  
}
module "mysql" {
    source = "../../terraform-sg"
    sg_name = "${local.project_name}-${local.env}-mysql"
    sg_description = "${local.project_name}-${local.env}-mysql"
    vpc_id = local.vpc_id
  
}
module "rabbitmq" {
    source = "../../terraform-sg"
    sg_name = "${local.project_name}-${local.env}-rabbitmq"
    sg_description = "${local.project_name}-${local.env}-rabbitmq"
    vpc_id = local.vpc_id
  
}
module "catalogue" {
    source = "../../terraform-sg"
    sg_name = "${local.project_name}-${local.env}-catalogue"
    sg_description = "${local.project_name}-${local.env}-catalogue"
    vpc_id = local.vpc_id
  
}
module "cart" {
    source = "../../terraform-sg"
    sg_name = "${local.project_name}-${local.env}-cart"
    sg_description = "${local.project_name}-${local.env}-cart"
    vpc_id = local.vpc_id
  
}
module "user" {
    source = "../../terraform-sg"
    sg_name = "${local.project_name}-${local.env}-user"
    sg_description = "${local.project_name}-${local.env}-user"
    vpc_id = local.vpc_id
  
}

module "shipping" {
    source = "../../terraform-sg"
    sg_name = "${local.project_name}-${local.env}-shipping"
    sg_description = "${local.project_name}-${local.env}-shipping"
    vpc_id = local.vpc_id
  
}

module "payments" {
    source = "../../terraform-sg"
    sg_name = "${local.project_name}-${local.env}-payments"
    sg_description = "${local.project_name}-${local.env}-payments"
    vpc_id = local.vpc_id
  
}
module "dispatch" {
    source = "../../terraform-sg"
    sg_name = "${local.project_name}-${local.env}-dispatch"
    sg_description = "${local.project_name}-${local.env}-dispatch"
    vpc_id = local.vpc_id
  
}
module "web" {
    source = "../../terraform-sg"
    sg_name = "${local.project_name}-${local.env}-web"
    sg_description = "${local.project_name}-${local.env}-web"
    vpc_id = local.vpc_id
  
}

module "app_alb" {
    source = "../../terraform-sg"
    sg_name = "${local.project_name}-${local.env}-app_alb"
    sg_description = "${local.project_name}-${local.env}-app_alb"
    vpc_id = local.vpc_id
  
}

resource "aws_security_group_rule" "allow_all_for_app_alb" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  security_group_id = module.app_alb.sg_id
  cidr_blocks = ["0.0.0.0/0"]
   description              = "Inbound Rule to connect alb-app"
}

resource "aws_security_group_rule" "allow_all_for_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.vpn.sg_id
  cidr_blocks = ["0.0.0.0/0"]
   description              = "Inbound Rule to connect alb-app"
}




module "web_alb" {
    source = "../../terraform-sg"
    sg_name = "${local.project_name}-${local.env}-web_alb"
    sg_description = "${local.project_name}-${local.env}-web_alb"
    vpc_id = local.vpc_id
  
}


module "vpn" {
    source = "../../terraform-sg"
    sg_name = "${local.project_name}-${local.env}-vpn"
    sg_description = "${local.project_name}-${local.env}-vpn"
    vpc_id =data.aws_vpc.default.id
  
}


resource "aws_security_group_rule" "app_alb_to_app" {
  count=length(local.app_ids)
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = local.app_ids[count.index]
  source_security_group_id = module.app_alb.sg_id
   description              = "Inbound Rule to connect with vpn"
}

#openvpn
resource "aws_security_group_rule" "vpn_home" {
  security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  cidr_blocks = ["0.0.0.0/0"] #ideally your home public IP address, but it frequently changes
}

