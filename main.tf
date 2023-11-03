provider "aws" {
  region = var.df_region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_security_group" "dp7_security_group" {

  ingress {
    from_port   = var.ssh_access.from_port
    to_port     = var.ssh_access.to_port
    protocol    = var.ssh_access.protocol
    cidr_blocks = var.ssh_access.cidr_blocks
  }

  ingress {
    from_port   = var.http_access.from_port
    to_port     = var.http_access.to_port
    protocol    = var.http_access.protocol
    cidr_blocks = var.http_access.cidr_blocks
  }

  ingress {
    from_port   = var.jenkins_access.from_port
    to_port     = var.jenkins_access.to_port
    protocol    = var.jenkins_access.protocol
    cidr_blocks = var.jenkins_access.cidr_blocks
  }

  egress {
    from_port   = var.anywhere_outgoing.from_port
    to_port     = var.anywhere_outgoing.to_port
    protocol    = var.anywhere_outgoing.protocol
    cidr_blocks = var.anywhere_outgoing.cidr_blocks
  }
}

resource "aws_iam_instance_profile" "dp7_iam_profile" {
  name = var.instance_profile_name
  role = var.machine_role
}

resource "aws_instance" "dp7_jenkins_controller_server" {
  ami                             = var.ec2_ami_id
  instance_type                   = var.ec2_instance_type
  vpc_security_group_ids          = [aws_security_group.dp7_security_group.id]
  tags                            = var.ec2_instance_tag_1
  user_data                       = base64encode(file(var.ud_jenkins_controller))
  associate_public_ip_address     = var.public_ip
  key_name                        = var.key_name
  iam_instance_profile            = var.instance_profile_name
}

resource "aws_instance" "dp7_jenkins_agent_server" {
  ami                             = var.ec2_ami_id
  instance_type                   = var.ec2_instance_type
  vpc_security_group_ids          = [aws_security_group.dp7_security_group.id]
  tags                            = var.ec2_instance_tag_2
  user_data                       = base64encode(file(var.ud_jenkins_agent_tf ))
  associate_public_ip_address     = var.public_ip
  key_name                        = var.key_name
  iam_instance_profile            = var.instance_profile_name
}

resource "aws_instance" "dp7_jenkins_docker_server" {
  ami                             = var.ec2_ami_id
  instance_type                   = var.ec2_instance_type
  vpc_security_group_ids          = [aws_security_group.dp7_security_group.id]
  tags                            = var.ec2_instance_tag_3
  user_data                       = base64encode(file(var.ud_docker_instance ))
  associate_public_ip_address     = var.public_ip
  key_name                        = var.key_name
  iam_instance_profile            = var.instance_profile_name
}