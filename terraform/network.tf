resource "aws_vpc" "sre_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "sre-portfolio-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.sre_vpc.id
  tags = { Name = "sre-igw" }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.sre_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = { Name = "sre-public-subnet" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.sre_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "sre_sg" {
  name        = "sre-cluster-sg"
  description = "Permite trafego Kubernetes, SSH e API"
  vpc_id      = aws_vpc.sre_vpc.id

  # Acesso SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # NOTA DE ARQUITETURA: Para fins de laboratório, o SSH está aberto para o mundo.
    # Em um ambiente de produção real, esta regra seria restrita ao IP do operador ou VPN.
    cidr_blocks = ["0.0.0.0/0"] 
  }
  # Acesso a nossa API Python
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Acesso a API do Kubernetes
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Permite comunicação total ENTRE as maquinas do cluster
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true 
  }
  # Permite que as maquinas acessem a internet (para baixar pacotes)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}