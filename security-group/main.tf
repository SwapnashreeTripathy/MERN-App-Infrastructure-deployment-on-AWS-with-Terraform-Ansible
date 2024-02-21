# Security Group for Instances present Public Subnet
resource "aws_security_group" "ec2_public_sg" {
    name = "security group1"
    description = "enable http/https access on port 80/443"
    vpc_id = var.vpc_id
    

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
    ingress {
        description = "http access"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "https access"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "https access"
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "https access"
        from_port   = 3001
        to_port     = 3001
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    Name = "${var.project_name}-ec2_public_sg"
  }
}


#Security Group of Instances present in Private subnet
resource "aws_security_group" "ec2_private_sg" {
    name = "security group2"
    description = "enable ssh/22  as this sg will be used to assign private subnet & also allow 3306 to install mysql DB in this private subnet"
    vpc_id = var.vpc_id



    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
    description     = "mysql access"
    from_port       = 3001
    to_port         = 3001
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.client_sg.id]
    }

     egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    Name = "${var.project_name}-ec2_private_sg"
  }
}

