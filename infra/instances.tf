# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

# resource "aws_instance" "web" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t3.micro"
#   subnet_id     = aws_subnet.my_subnet.id
#   ebs_optimized = true

#   vpc_security_group_ids = [ aws_security_group.instance.id ]
#   key_name = aws_key_pair.deployer.key_name

#   root_block_device {
#     volume_size = 80
#     encrypted = true
#     volume_type = "gp3"
#   }

#   tags = {
#     Name = "HelloWorld"
#   }
# }