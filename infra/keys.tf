resource "tls_private_key" "ec2" {
    algorithm = "RSA"
    rsa_bits = 2048
}

resource "aws_ssm_parameter" "ec2_private" {
  name        = "/k8s/test/ec2_private"
  description = "ec2_private"
  type        = "SecureString"
  value       = tls_private_key.ec2.private_key_pem

  tags = {
    environment = "test"
  }
}

resource "aws_ssm_parameter" "ec2_public" {
  name        = "/k8s/test/ec2_public"
  description = "ec2_public"
  type        = "SecureString"
  value       = tls_private_key.ec2.public_key_openssh

  tags = {
    environment = "test"
  }
}


resource "local_file" "private_key" {
    content = tls_private_key.ec2.private_key_pem
    filename = "${path.module}/integration.pem"
    file_permission = "0600"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = tls_private_key.ec2.public_key_openssh
}