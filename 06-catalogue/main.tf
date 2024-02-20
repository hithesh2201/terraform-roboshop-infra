resource "aws_lb_target_group" "catalogue" {
  name        = "catalogue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher = "200-299"
  }
}

resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = data.aws_ssm_parameter.app_alb_listener_arn.value
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["${local.component}.app-${local.env}.${var.domain_name}"]
    }
  }
}

module "catalogue" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name                   = "${local.component}-${local.current_timestamp}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  subnet_id              = element(split(",",data.aws_ssm_parameter.private_subnet_ids.value),0)
  tags = merge(
    {
      Component = "${local.component}"
    },
    {
      Name = "${local.component}-ami"
    }
  )
}

resource "null_resource" "catalogue" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.catalogue.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {          #to accept this connection you should connect with vpn
    host = module.catalogue.private_ip
    type = "ssh"
    user = "centos"
    password = "DevOps321"
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh catalogue dev"
      
    ]
  }
  depends_on = [ module.catalogue ]
}

resource "aws_ec2_instance_state" "stop_instance" {
  instance_id = module.catalogue.id
  state       = "stopped"
  depends_on = [ null_resource.catalogue ]
}

resource "aws_ami_from_instance" "take_ami" {
  name               = "${local.component}-${local.current_timestamp}-ami"
  source_instance_id = module.catalogue.id
  depends_on = [ aws_ec2_instance_state.stop_instance ]
}

resource "null_resource" "terminate_instance" {
  triggers = {
    instance_id = module.catalogue.id  # Update with your instance ID
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${self.triggers.instance_id}"
  }
  depends_on = [resource.aws_ami_from_instance.take_ami ]
}


