#エンドポイント セキュリティーグループ
resource "aws_security_group" "allow_https_ep_sg" {
  name        = "allow_https_ep_sg"
  description = "allow https ep sq"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
    description = "https ec2"
  }

  tags = {
    Name = "${var.resourceName}-ep-sg"
  }
}

# エンドポイント
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.ap-northeast-1.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.public_subnet.id]
  security_group_ids  = [aws_security_group.allow_https_ep_sg.id]
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.ap-northeast-1.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.public_subnet.id]
  security_group_ids  = [aws_security_group.allow_https_ep_sg.id]
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.ap-northeast-1.ec2"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.public_subnet.id]
  security_group_ids  = [aws_security_group.allow_https_ep_sg.id]
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.ap-northeast-1.ec2messages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.public_subnet.id]
  security_group_ids  = [aws_security_group.allow_https_ep_sg.id]
}

# EIC Endpointのセキュリティグループ
resource "aws_security_group" "allow_ssh_eic_sg" {
  name        = "allow_ssh_eic_sg"
  description = "Allow ssh eic sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
    description = "ssh ec2"
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
    description = "ssh ec2"
  }

  tags = {
    Name = "${var.resourceName}-eic-sg"
  }
}

resource "aws_ec2_instance_connect_endpoint" "eic" {
  subnet_id          = aws_subnet.private_subnet.id
  security_group_ids = [aws_security_group.allow_ssh_eic_sg.id]
  preserve_client_ip = true

  tags = {
    Name = "${var.resourceName}-eic"
  }
}