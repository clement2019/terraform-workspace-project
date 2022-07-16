terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}



provider "aws" {
  #uncomment the folowing and replace with your keys

  profile = "myaws"

  region = var.region
  #profile ="default"



}
# Now we need to implement the sg_module first before the other one because the output of the firat one will be input for the second module

 module "sg-module" {
  sg_name="sg_Ec2_${local.env}"
  source = "./sg-module"
   
 }

module "ec2module" {
  sg_id="${module.sg-module.sg_id_ouput}"
  env_name="Ec2_instance_${local.env}"
  source = "./ec2module"
  
}

locals {
  env ="${terraform.workspace}"

 
  hamiidenv={
    default="amiid_default"
    stagging="amiid_stagging"
    production="amiid_production"


  }
  amiid = "${lookup(local.hamiidenv,local.env)}"
}
output "environment_specific_variable" {

  value="${local.amiid}"
}