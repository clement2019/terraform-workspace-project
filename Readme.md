## TERRAFORM WORKSPACE PROJECT

This terraform-workspace-project is essentially a project done and configure with terraform showing the power and usage of terraform workspace and terraform module in project managment.
The use of correct naming convention in project management cannot be overemphasised because when your project files becomes too large
one could easily get lost and its only if you have proper naming convention that will help you out so working with terraform workspace is essential. 
such as as shown below but we have default workspace already

$ terraform workspace new stagging
$ terraform workspace new production

### Projects Requirements
First download and install the terraform using this link  
Then download Aws cli to used to configure the IAM user credentails using this link

### Resources created and needed
 
An EC2 instance 
Security group, 
 Ami image of Ubuntu Server 20.04 on my existing AWS account.

### project workflow and componenst used

In this project i first created and select a workspace to use for the project as shown below
$ terraform workspace select stagging

Next i then move to creating an Ec2_module housing an Ec2_module.tf file inside this file we have ,the resource provisioing for an AWS Ec2 instance
and all its components that has to be created with it such as key_name, instance typ,AMI image chosen,Key tag,VPC_security_group_ids all these 
would be created inside the Ec2_module.tf file, as shown below 

resource "aws_instance" "web-server" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name               = "${var.ec2_name}"
  vpc_security_group_ids = ["${var.sg_id}"]

  tags = {
   
    Name = "web_server_${var.env_name}"
   #Name="Ec2_name_instance_${module.shared_module.hamiidenv}"
  }
}

To maintian proper refactoring some values that would have been hard coded, i created a varibale.tf file for so they can be properly declared
with their defaults values where neccessary as shown below with code snippets

variable "ami" {

  default = "ami-0a244485e2e4ffd03"

}

Now some file have to be shared across the projects like the environment where a particular task will be done such files has to be shared
inside the shared_module housing the shared_module.tf file  while using locals variable block to define it.Now such environment as "env" defined will have 
an output definition will it a valaue all as shown below

locals {
  env ="${terraform.workspace}"

  hamiidenv= {
    default = "amiid_default"
    stagging = "amiid_stagging"
    production = "amiid_production"


  }

  env_suffix = "${lookup(local.hamiidenv,local.env)}"
}

output "env_suffix_env" {

  value = "${local.hamiidenv}"
  
  Now next i created the another sg_module group that housed the sg_module.tf file, this file entails all the security group resources provisioning
  this covers the security_group resources creation and it houses the ingreess ,egress rules,cidr block,ports defintion for ssh and https
  and tag name covering the environment "env" where the task is been defined. All defintion as shown below
  
  
  resource "aws_security_group" "sg_module_creation" {
    #name ="sg_module_${var.sg_name}"
    description = "terraform sg for ec2 instance"

 vpc_id = "${var.vpcid}"
 ingress {

    cidr_blocks = ["0.0.0.0/0"]
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"


  }

  ingress {

    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"


  }

  egress {

    cidr_blocks = ["0.0.0.0/0"]
    description = "http"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"


  }
  tags = {

    Name = "security_${var.sg_name}"
    #Name="security_sg_name_${module.shared_module.hamiidenv}"
  }

}

Now the security group id that is the sg_id_output has to be hearnessed and used in the ec2_module  where the ec2 instance is been created as shown below

output "sg_id_ouput" {

    value = "${aws_security_group.sg_module_creation.id}"
  
}


variable "vpcid" {
    type = string
    default = "vpc-9e87aff6"
  
}

module "shared_module" {
 source = "../shared_module"
}
variable "sg_name" {
   default = ""
  
}

