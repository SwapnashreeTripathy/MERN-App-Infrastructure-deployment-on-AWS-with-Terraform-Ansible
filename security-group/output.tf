output "ec2_public_sg_id" {
  value = aws_security_group.ec2_public_sg.id
}

output "ec2_private_sg_id" {
  value = aws_security_group.ec2_private_sg.id
}