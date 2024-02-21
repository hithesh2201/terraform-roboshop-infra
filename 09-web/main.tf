resource "aws_lb_target_group" "web" {
  name        = "web"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  deregistration_delay = 300

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    port                = 80
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher = "200-299"
  }
}

resource "aws_lb_listener_rule" "web" {
  listener_arn = data.aws_ssm_parameter.web_alb_listener_arn.value
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }

  condition {
    host_header {
      values = ["web-${local.env}.${var.domain_name}"]
    }
  }
}

module "web" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name                   = "${local.component}-${local.current_timestamp}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.web_sg_id.value]
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

resource "null_resource" "web" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.web.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {          #to accept this connection you should connect with vpn
    host = module.web.private_ip
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
      "sudo sh /tmp/bootstrap.sh web dev"
      
    ]
  }
  depends_on = [ module.web ]
}

resource "aws_ec2_instance_state" "stop_instance" {
  instance_id = module.web.id
  state       = "stopped"
  depends_on = [ null_resource.web ]
}

resource "aws_ami_from_instance" "take_ami" {
  name               = "${local.component}-${local.current_timestamp}-ami"
  source_instance_id = module.web.id
  depends_on = [ aws_ec2_instance_state.stop_instance ]
}

resource "null_resource" "terminate_instance" {
  triggers = {
    instance_id = module.web.id  # Update with your instance ID
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${self.triggers.instance_id}"
  }
  depends_on = [resource.aws_ami_from_instance.take_ami ]
}

resource "aws_launch_template" "web" {
  name = "${local.component}-instances"

  image_id = aws_ami_from_instance.take_ami.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"
  update_default_version = true

  placement {
    availability_zone = "us-east-1a"
  }

  vpc_security_group_ids = [data.aws_ssm_parameter.web_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.component}"
    }
  }
}

resource "aws_autoscaling_group" "web" {
  name                      = "${local.component}"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  vpc_zone_identifier       = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  target_group_arns = [ aws_lb_target_group.web.arn ]
  
  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${local.component}"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}



resource "aws_autoscaling_policy" "web" {
  autoscaling_group_name = aws_autoscaling_group.web.name
  name                   = "${local.component}}"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 5.0
  }
}