# create application load balancer
resource "aws_lb" "alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.ec2_public_sg_id]
  subnets            = [var.pub_sub_1a_id,var.pub_sub_1b_id]
  enable_deletion_protection = false  #Defaults to false. if "false", then terraform can delete the alb when required.

  tags   = {
    Name = "${var.project_name}-alb"
  }
}


#create target group 
resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.project_name}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id 
  target_type = "instance" # The default is "instance". (optional) "target type" you must specify when registering targets with this target group.


   health_check {
    enabled             = true # (Optional) Whether health checks are enabled. Defaults to true.
    interval            = 300 #(optional) Approximate amount of time, in seconds, between health checks of an individual target. The range is 5-300.
    path                = "/"
    timeout             = 60 # (optional) Amount of time, in seconds, during which no response from a target means a failed health check.
    matcher             = 200  #(optional)200 is default for ALB type to check for a successful response from a target. 
    healthy_threshold   = 2  # (Optional) Number of consecutive health check successes required before considering a target healthy.
    unhealthy_threshold = 5 #(Optional) Number of consecutive health check failures required before considering a target unhealthy.
   }

    #not sure abour below code --why this is used.port 
    # lifecycle {
    # create_before_destroy = true
    # }   
}

#Provides a Load Balancer Listener resource.

resource "aws_lb_listener" "alb_listener" {
    load_balancer_arn = aws_lb.alb.arn
    port              = 80     #or "443" , check "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener"
    protocol          = "HTTP" #or "HTTPS", then add "certificate_arn" & "ssl_policy"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.alb_tg.arn
    }
  
}

