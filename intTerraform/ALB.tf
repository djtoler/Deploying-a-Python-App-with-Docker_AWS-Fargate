#Traget Group
resource "aws_lb_target_group" "dp7_bank_app" {
  name        = "dp7_bank_lb_tg_name"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.app_vpc.id

  health_check {
    enabled = true
    path    = "/health"
  }

  depends_on = [aws_alb.dp7_bank_app]
}

#Appplication Load Balancer
resource "aws_alb" "dp7_bank_app" {
  name               = "dp7_bank_lb_name"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
  ]

  security_groups = [
    aws_security_group.http.id,
  ]

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_alb_listener" "dp7_bank_lb_listner" {
  load_balancer_arn = aws_alb.dp7_bank_app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dp7_bank_app.arn
  }
}

output "alb_url" {
  value = "http://${aws_alb.dp7_bank_app.dns_name}"
}
