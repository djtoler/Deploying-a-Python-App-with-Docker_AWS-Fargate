provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"

}

# Cluster
resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = "dp7_bank_app_cluster"
  tags = {
    Name = "dp7_bank_app_cluster_tag"
  }
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = "/ecs/bank-logs"

  tags = {
    Application = "dp7_bank_app"
  }
}

# Task Definition

resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = "dp7_bank_app_task"

  container_definitions = <<EOF
  [
  {
      "name": "dp7_nank_app_container",
      "image": "djtoler/dp7_bank:latest",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/bank-logs",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "containerPort": 8000
        }
      ]
    }
  ]
  EOF

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = "arn:aws:iam::994181039877:role/ecsTaskExecutionRole2"
  task_role_arn            = "arn:aws:iam::994181039877:role/ecsTaskExecutionRole2"

}

# ECS Service
resource "aws_ecs_service" "dp7_bank_app_ecs" {
  name                 = "dp7_bank-app_ecs_service"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = aws_ecs_task_definition.aws-ecs-task.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 2
  force_new_deployment = true

  network_configuration {
    subnets = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id
    ]
    assign_public_ip = false
    security_groups  = [aws_security_group.ingress_app.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.dp7_bank_app.arn
    container_name   = "dp7_bank_app_container"
    container_port   = 8000
  }
}


resource "aws_key_pair" "dp7_bastion_key" {
  key_name   = "bastion_key"
  public_key = file("dp7_bastion_key.pub")
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["52.23.220.161/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion_sg"
  }
}

resource "aws_instance" "bastion_host" {
  ami           = "ami-0fc5d935ebf8bc3bc" 
  instance_type = "t2.micro"
  key_name      = aws_key_pair.bastion_key.key_name
  subnet_id     = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "BastionHostInstance"
  }
}





