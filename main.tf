terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 5.31.0"
   }
 }
}

provider "aws" {
  region  = "us-east-1"
}

module "vpc" {
  source = "./vpc"
}

module "bastion" {
  source = "./bastion-host"

  key_name = "bastion_key"
  security_group_id = module.vpc.security_group_id
  public_subnet_1_id = module.vpc.public_subnet_1_id
}

module "web-app" {
  source = "./web-app"
  
  key_name = "webhost_key"
  private_subnet_1_id = module.vpc.private_subnet_1_id
  bastion_security_group_id = module.vpc.security_group_id
  vpc_id = module.vpc.vpc_id
  lb_security_group_id = module.vpc.security_group_lb_id
}

module "lb" {
  source = "./lb"
  lb_security_group_id = module.vpc.security_group_lb_id
  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id
  vpc_id = module.vpc.vpc_id
  webhost_id = module.web-app.webhost_id
}

module "auto-scalling-groups" {
  source = "./auto-scalling-groups"
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_3_id = module.vpc.private_subnet_3_id
  lc_id = module.web-app.lc_id
  lb_arn = module.lb.lb_arn
}

module "rds" {
  source = "./rds"
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_3_id = module.vpc.private_subnet_3_id
  db_security_group = module.web-app.db_security_group
}
