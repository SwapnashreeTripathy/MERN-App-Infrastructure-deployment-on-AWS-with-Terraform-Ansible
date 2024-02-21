
#Creating Instance1 on AZ1 , in  private subnet to Install MongoDB on it.
resource "aws_instance" "webserver1" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.ec2_private_sg_id]
  subnet_id              = var.pri_sub_1st_id
  key_name               = "test-st"           #var.key_name
#   user_data              = base64encode(file("userdata.sh"))
  tags = {
    Name = "${var.project_name}-EC2-AZ1"
  }

}


#Creating Instance1 on AZ2 , in  private subnet to Install MongoDB on it.
resource "aws_instance" "webserver2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.ec2_private_sg_id]
  subnet_id              = var.pri_sub_2nd_id
  key_name               =  "test-st"              #var.key_name 
#   user_data              = base64encode(file("userdata1.sh"))
  
  tags = {
    Name = "${var.project_name}-EC2-AZ2"
  }

}

#Creating Ansible Master-node .
resource "aws_instance" "Ansible-masternode" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.ec2_public_sg_id]
  subnet_id              = var.pub_sub_1a_id
  key_name               = "test-st"
  user_data              = base64encode(file("userdata.sh"))
  tags = {
    Name = "${var.project_name}-ansible-mn"
  }
}

