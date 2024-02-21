
#Create IAM user 

resource "aws_iam_user" "iam_user1" {
  name = "${var.project_name}-${var.iam_user1}-iam_user1"
  path = "/system/"

  tags = {
    tag-key = "iam_user1-${var.iam_user1}"
  }
}

#create access key for that user
resource "aws_iam_access_key" "acces_key_iam_user1" {
  user = aws_iam_user.iam_user1.name
}

#Create/retrive some Policies for that user

/*data "aws_iam_policy_document" "ec2" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}*/


data "aws_iam_policy_document" "lb_ec2" {
  statement {
    sid       = "Statement1"
    effect    = "Allow"
    actions   = [
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:Get*",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "Statement2"
    effect    = "Allow"
    actions   = [
      "ec2:DescribeInstances",
      "ec2:DescribeClassicLinkInstances",
      "ec2:DescribeSecurityGroups",
    ]
    resources = ["*"]
  }
}

  /*statement {
    sid       = "Statement3"
    effect    = "Allow"
    actions   = ["arc-zonal-shift:GetManagedResource"]
    resources = ["arn:aws:elasticloadbalancing:::loadbalancer/*"]
  }

  statement {
    sid       = "Statement4"
    effect    = "Allow"
    actions   = [
      "arc-zonal-shift:ListManagedResources",
      "arc-zonal-shift:ListZonalShifts",
    ]
    resources = ["*"]
  }*/



#Provides an IAM policy attached to a user.
resource "aws_iam_policy" "iam_user1_attach_pollicy_lb_ec2" {
  name    = "${var.project_name}-${var.iam_user1}-attach_pollicy_lb_ec2"
  policy  = data.aws_iam_policy_document.lb_ec2.json
}

