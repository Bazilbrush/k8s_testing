# Create a VPC
resource "aws_vpc" "cluster" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "cluster_a" {
  vpc_id            = aws_vpc.cluster.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "k8s_provate_sn"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.cluster.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "k8s" {
  vpc_id = aws_vpc.cluster.id

  tags = {
    Name = "example"
  }
}

resource "aws_route" "route_though_ig" {
  route_table_id            = aws_route_table.k8s.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.cluster_a.id
  route_table_id = aws_route_table.k8s.id
}


resource "aws_security_group" "k8s_cluster" {
  name        = "kubernetes"
  description = "sg for k8s raffic management"
  vpc_id      = aws_vpc.cluster.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.k8s_cluster.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_ingress_rule" "in-vpc" {
  security_group_id = aws_security_group.cluster.id

  cidr_ipv4   = "10.0.0.0/16"
  ip_protocol = -1
 
}
# weird IP
resource "aws_vpc_security_group_ingress_rule" "in-vpc-1" {
  security_group_id = aws_security_group.cluster.id

  cidr_ipv4   = "10.200.0.0/16"
  ip_protocol = -1
}

resource "aws_vpc_security_group_ingress_rule" "in-ssh" {
  security_group_id = aws_security_group.cluster.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}
resource "aws_vpc_security_group_ingress_rule" "in-k8s-api" {
  security_group_id = aws_security_group.cluster.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 6443
  to_port     = 6443
}
resource "aws_vpc_security_group_ingress_rule" "in-https" {
  security_group_id = aws_security_group.cluster.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}
resource "aws_vpc_security_group_ingress_rule" "in-icmp" {
  security_group_id = aws_security_group.cluster.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "icmp"
  from_port   = -1
  to_port     = -1
}

