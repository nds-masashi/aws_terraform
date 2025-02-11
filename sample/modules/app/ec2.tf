#EC2セキュリティーグループ
resource "aws_security_group" "allow_ssh_ec2_sg" {
  name        = "allow_ssh_ec2_sg"
  description = "Allow ssh ec2 sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
    # EC2 Instance Coonect 経由で接続したい場合、0.0.0.0/0
    description = "ssh ssm"
  }

  tags = {
    Name = "${var.resourceName}-ec2-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "ssh_rule" {
  security_group_id = aws_security_group.allow_ssh_ec2_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "ssh ec2"
}

resource "aws_vpc_security_group_egress_rule" "https_rule" {
  security_group_id = aws_security_group.allow_ssh_ec2_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = aws_vpc.vpc.cidr_block
  description       = "https ec2"
}

#EC2ロール
resource "aws_iam_role" "ec2_role" {
  name = "ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ses_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

#EC2インスタンス
resource "aws_instance" "ec2_instance_public" {
  ami = "ami-0e2612a08262410c8" # AmazonLinux
  #ami                    = "ami-0b512018294c0b386" # Redhat
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  key_name               = "aws-eb"

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "${var.resourceName}-instance"
  }
}

resource "aws_instance" "ec2_instance_private" {
  ami = "ami-0e2612a08262410c8" # AmazonLinux
  #ami                    = "ami-0b512018294c0b386" # Redhat
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  key_name               = "aws-eb"

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "${var.resourceName}-instance"
  }
}
