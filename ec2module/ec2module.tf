variable "sg_id" {
  
}

module "shared_module" {

  source= "../shared_module"
}

variable "ec2_name" {
  default = "devopskey"
}

variable "env_name" {
  #default = "Ec2_name_instance_${module.shared_module.env_suffix}"
  default = ""
}

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

