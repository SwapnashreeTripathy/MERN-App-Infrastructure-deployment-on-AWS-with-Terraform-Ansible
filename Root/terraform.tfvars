project_name = "MREN-app"
region = "ap-south-1"
#vpc
vpc_cidr = "10.0.0.0/16"
pub_sub_1a_cidr = "10.0.101.0/24"
pub_sub_1b_cidr = "10.0.102.0/24"
pri_sub_1st = "10.0.1.0/24"
pri_sub_2nd ="10.0.2.0/24" 

#ASG
ami  = "ami-03f4878755434977f"
instance_type = "t2.micro"
max_size = "4"
min_size = "2"
desired_cap = "2"
asg_health_check_type = "ELB"


#IAM user info
iam_user_name =  "swapna"