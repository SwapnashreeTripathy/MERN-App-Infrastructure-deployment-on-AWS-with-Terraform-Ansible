#Create Launch Template for ASG to create EC2 instances.
resource "aws_launch_template" "asg_lt" {
    name = "${var.project_name}_asg_lt"
    image_id = var.ami
    instance_type = var.instance_type
    # image_id = "ami-03f4878755434977f"
    # instance_type = "t2.micro"
    key_name =  "test-st"   #var.key_name
    # user_data = filebase64("")

    vpc_security_group_ids = [var.ec2_public_sg_id]

    # network_interfaces {
    # associate_public_ip_address = true
    # }

    monitoring {
    enabled = true
    }

    tags = {
        Name = "${var.project_name}-ec2"
    }
  
}

#Create ASG
resource "aws_autoscaling_group" "asg" {
    name = "${var.project_name}_asg"
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_cap
    # max_size = "6"
    # min_size = "2"
    # desired_capacity = "3"
    # health_check_grace_period = 300
    health_check_type = var.asg_health_check_type #"ELB" or default EC2
    # health_check_type = "ELB"
    # 2 EC2 instance will get created in 2 public subnets in both AZs//& only 1 sg associated with both Public subnet<ec2_public_sg>.
    vpc_zone_identifier = [var.pub_sub_1a_id,var.pub_sub_1b_id]
    target_group_arns = [var.alb_tg_arn]  ##var.alb_target_group_arn


    # enabled_metrics - (Optional) List of metrics to collect. The allowed values are defined by the underlying AWS API.##for Logs in Cloudwatch
    enabled_metrics = [
        "GroupMinSize",
        "GroupMaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupTotalInstances"
    ]


#enabled_metrics =["GroupMinSize","GroupMaxSize","GroupDesiredCapacity","GroupInServiceInstances","GroupPendingInstances","GroupStandbyInstances","GroupTerminatingInstances","GroupTotalInstances","GroupInServiceCapacity","GroupPendingCapacity","GroupStandbyCapacity","GroupTerminatingCapacity","GroupTotalCapacity","WarmPoolDesiredCapacity","WarmPoolWarmedCapacity","WarmPoolPendingCapacity","WarmPoolTerminatingCapacity","WarmPoolTotalCapacity","GroupAndWarmPoolDesiredCapacity","GroupAndWarmPoolTotalCapacity"]


    # metrics_granularity - (Optional) Granularity to associate with the metrics to collect. The only valid value is 1Minute. Default is 1Minute.
    metrics_granularity = "1Minute"

    # assign Launch template specification to use to launch instances. 
    launch_template {
      id = aws_launch_template.asg_lt.id
      version = aws_launch_template.asg_lt.latest_version
    }
}

#Scale up // Attaching scaling policy
resource "aws_autoscaling_policy" "asg_scale_up" {
    name                   = "${var.project_name}-asg-scale-up"
    scaling_adjustment     = "1" #increasing instance by 1 
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    autoscaling_group_name = aws_autoscaling_group.asg.name
    policy_type            = "SimpleScaling"
}

# scale up alarm
# alarm will trigger the ASG policy (scale/down) based on the metric (CPUUtilization), comparison_operator, threshold
resource "aws_cloudwatch_metric_alarm" "asg_scale_up_cloudwatch_alarm" {
  alarm_name          = "${var.project_name}-asg-scale-up-cloudwatch-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70" # New instance will be created once CPU utilization is higher than 70 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.asg_scale_up.arn]
}


# scale down policy
/*resource "aws_autoscaling_policy" "asg_scale_down" {
  name                   = "${var.project_name}-asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # decreasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

# scale down alarm
resource "aws_cloudwatch_metric_alarm" "asg_scale_down_cloudwatch_alarm" {
  alarm_name          = "${var.project_name}-asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5" # Instance will scale down when CPU utilization is lower than 5 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.asg_scale_down.arn]
}
*/













#get Instance IDs created by this ASG
