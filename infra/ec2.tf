resource "aws_instance" "front" {
  ami           = "ami-01b14b7ad41e17ba4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = "TU_KEY"

  vpc_security_group_ids = [aws_security_group.front_sg.id]

  user_data = file("userdata/front.sh")

  tags = {
    Name = "frontend"
  }
}

resource "aws_instance" "back" {
  ami           = "ami-01b14b7ad41e17ba4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id
  key_name      = "TU_KEY"

  vpc_security_group_ids = [aws_security_group.back_sg.id]

  user_data = file("userdata/back.sh")

  tags = {
    Name = "backend"
  }
}

resource "aws_instance" "data" {
  ami           = "ami-01b14b7ad41e17ba4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id
  key_name      = "TU_KEY"

  vpc_security_group_ids = [aws_security_group.data_sg.id]

  user_data = file("userdata/data.sh")

  tags = {
    Name = "database"
  }
}