data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "controller" {
  count = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.cluster_a.id
  ebs_optimized = true

  associate_public_ip_address= true

  
  # we need that because we gonna be doing networking on it
  source_dest_check = false

  vpc_security_group_ids = [ aws_security_group.k8s_cluster.id ]
  key_name = aws_key_pair.deployer.key_name

  root_block_device {
    volume_size = 40
    encrypted = true
    volume_type = "gp3"
  }

  tags = {
    Name = "Controller-${count.index}"
  }
}

resource "aws_instance" "worker" {
  count = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.cluster_a.id
  ebs_optimized = true

  associate_public_ip_address= true

  
  # we need that because we gonna be doing networking on it
  source_dest_check = false

  vpc_security_group_ids = [ aws_security_group.k8s_cluster.id ]
  key_name = aws_key_pair.deployer.key_name

  root_block_device {
    volume_size = 40
    encrypted = true
    volume_type = "gp3"
  }

  tags = {
    Name = "Worker-${count.index}"
  }
}

