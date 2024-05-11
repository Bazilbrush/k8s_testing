resource "aws_lb" "k8s-nlb" {
  name               = "k8-internet-facing"
  internal           = false
  load_balancer_type = "network"
  subnets            = [ aws_subnet.cluster_a.id ]
 
  enable_deletion_protection = false

  tags = {
    Environment = "test"
  }
}
resource "aws_lb_target_group" "k8s" {
  name     = "k8s"
  port     = 6443
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = aws_vpc.cluster.id
}

# resource "aws_lb_target_group_attachment" "test" {
#   target_group_arn = aws_lb_target_group.k8s.arn
#   target_id        = aws_instance.test.id
#   port             = 80
# }

resource "aws_lb_target_group_attachment" "example" {
  # covert a list of instance objects to a map with instance ID as the key, and an instance
  # object as the value.
  for_each = {
    for k, v in aws_instance.controller :
    k => v
  }

  target_group_arn = aws_lb_target_group.k8s.arn
  target_id        = each.value.private_ip
  port             = 6443
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.k8s-nlb.arn
  port              = "443"
  protocol          = "TCP"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
#   alpn_policy       = "HTTP2Preferred"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8s.arn
  }
}