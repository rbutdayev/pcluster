#variable "aws_key" {
#description = " Please input aws access key"
#type = string
#}

#variable "aws_secret" {
#description = " Please input aws secret key"
#type = string
#}

variable "instance_type"   {
description = "vm instance type"
type=string

}

variable region {

    description = "vm instance type"
type=string
default = "us-east-1"
}

