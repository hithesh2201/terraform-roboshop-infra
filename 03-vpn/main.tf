module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "roboshop-vpn"
  ami = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id              = data.aws_subnet.pub-sub-vpc.id
  user_data = file("openvpn.sh")
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


#  sudo find / -type f -name "hitesh.ovpn"