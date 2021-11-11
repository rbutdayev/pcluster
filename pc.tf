provider "aws" {

region = var.region

}

data "aws_ami" "aws_l_latest" {
owners = ["amazon"]
most_recent = true
filter {
name = "name"
values = ["amzn2-ami-hvm-*-x86_64-gp2"]


}

}
/*
resource "aws_s3_bucket_object" "single_file" {
  bucket       = "pcluster-11"
  key          = "conf.yml"
  source       = "conf.yml"
}
*/
resource "aws_instance" "pcluster" {

    #count = 2
    ami = data.aws_ami.aws_l_latest.id
    instance_type = var.instance_type
    key_name ="rbut"
    vpc_security_group_ids = [aws_security_group.pclsec_gr.id]
    iam_instance_profile = aws_iam_instance_profile.s3_profile.name
    user_data = <<-EOL
  #!/bin/bash -xe
       curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
       chmod  ug+x ~/.nvm/nvm.sh
       source  ~/.nvm/nvm.sh
       nvm  install --lts

  EOL
 
provisioner "remote-exec" {
        inline = [
          "pip3 install aws-parallelcluster",
          "pcluster configure --config conf.yml",
          "pcluster create-cluster --cluster-name cluster-1 --cluster-configuration conf.yml",
        ]
      }

}
 



resource "aws_security_group" "pclsec_gr" {
  name        = "pcluster-scgrp"
  description = "Allow  traffics"
  #vpc_id      = aws_vpc.vpc_terraform.id

dynamic "ingress" {
    for_each = ["80","443","22"]

    content {
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    }
}

    
  egress {
    description      = "for all outgoing traffics"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  tags = {
    Name = "secgrp-for-pcluster"
  }
}

