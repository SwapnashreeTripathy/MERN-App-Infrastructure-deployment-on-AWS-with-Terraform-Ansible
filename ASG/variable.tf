variable "key_name" {}
variable "project_name" {}
variable "ec2_public_sg_id" {}

variable "ami" {
#   default = "ami-03f4878755434977f"
}

variable "instance_type" {
    # default = "t2.micro"
}

variable "max_size" {
    # default = 6
}
variable "min_size" {
    # default = 2
}
variable "desired_cap" {
    # default = 3
}
variable "asg_health_check_type" {
    # default = "ELB"
}

variable "pub_sub_1a_id" {}
variable "pub_sub_1b_id" {}


variable "alb_tg_arn" {}