locals {
  availability_zones=slice(module.vpc.aws_availability_zones,0,2)
  project_name="roboshop"
  env="dev"
}
