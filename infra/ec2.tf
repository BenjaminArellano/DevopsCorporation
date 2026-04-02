resource "aws_instance" "front" {
  ami           = "ami-0ec10929233384c7f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = "TU_KEY"

  vpc_security_group_ids = [aws_security_group.front_sg.id]

  user_data = templatefile("userdata/front.sh", {
    back_ip = aws_instance.back.private_ip
  })

  tags = {
    Name = "frontend"
  }
}

resource "aws_instance" "back" {
  ami           = "ami-0ec10929233384c7f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id
  key_name      = "TU_KEY"

  vpc_security_group_ids = [aws_security_group.back_sg.id]

  user_data = templatefile("userdata/back.sh", {
    db_ip = aws_instance.data.private_ip
  })

  tags = {
    Name = "backend"
  }
}

resource "aws_instance" "data" {
  ami           = "ami-0ec10929233384c7f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id
  key_name      = "TU_KEY"

  vpc_security_group_ids = [aws_security_group.data_sg.id]

  user_data = file("userdata/data.sh")

  tags = {
    Name = "database"
  }
}