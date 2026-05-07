data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "sre_auth" {
  key_name   = "sre-k8s-key"
  public_key = file("sre_key.pub")
}

resource "aws_instance" "k8s_control_plane" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sre_sg.id]
  key_name               = aws_key_pair.sre_auth.key_name
  
  tags = { Name = "sre-k8s-master" }
}

resource "aws_instance" "k8s_worker" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sre_sg.id]
  key_name               = aws_key_pair.sre_auth.key_name
  
  tags = { Name = "sre-k8s-worker" }
}