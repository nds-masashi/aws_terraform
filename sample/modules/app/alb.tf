resource "aws_lb_target_group_attachment" "ec2_alb_target" {
  target_group_arn = aws_lb_target_group.ec2_alb_target_group.arn
  target_id        = aws_instance.ec2_instance_private.id
  port             = 80
}

resource "aws_lb_target_group" "ec2_alb_target_group" {
  name     = "ec2-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_listener" "ec2_alb_listener" {
  load_balancer_arn = aws_lb.ec2_alb.arn
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::xxxxxxxxxx:server-certificate/test_cert_xxxxxxxxxxx"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_alb_target_group.arn
  }
}

resource "aws_security_group" "ec2_alb_sg" {
  name        = "allow-https-alb-sg"
  description = "Allow https alb sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http"
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http"
  }

  tags = {
    Name = "${var.resourceName}-alb-sg"
  }
}

resource "aws_lb" "ec2_alb" {
  name               = "ec2-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ec2_alb_sg.id]
  subnets = [aws_subnet.public_subnet.id,
  aws_subnet.public_subnet_2.id]

  enable_deletion_protection = true

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.id
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

  tags = {
    Name = "${var.resourceName}-alb"
  }
}