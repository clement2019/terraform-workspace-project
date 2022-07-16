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

output "sg_id_ouput" {

    value = "${aws_security_group.sg_module_creation.id}"
  
}