# data "aws_ssm_parameter" "vpc_id" {
#   name = "/${local.project_name}/${local.env}/vpc_id"
# }


data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "pub-sub-vpc" {

    vpc_id = data.aws_vpc.default.id
    availability_zone = "us-east-1a"

}

output "subnet_id" {
  value = data.aws_subnet.pub-sub-vpc.id
}

data "aws_security_group" "allow_all_default_vpc" {
  name = "allow-all"
}

data "aws_ami" "centos8" {
#   executable_users = ["self"]
  most_recent      = true
#   name_regex       = "^myami-\\d{3}"
  owners           = ["973714476881"]

  filter {
    name   = "name"
    values = ["Centos-8-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}