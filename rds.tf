resource "aws_db_subnet_group" "app_db_subnet_group" {
  name       = "app-db-subnet-group"
  subnet_ids = [aws_subnet.AppSubnet1.id, aws_subnet.AppSubnet2.id]

  depends_on = [aws_network_interface.nw-interface1, aws_network_interface.nw-interface2]

  tags = {
    Name = "AppDBSubnetGroup"
  }
}

resource "aws_db_instance" "app_database" {
  allocated_storage      = 20
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  identifier             = "appdatabase"
  db_name                = "appdatabase"
  username               = "admin"
  password               = "db*pass123"
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.app_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.WebTrafficSG.id]

  tags = {
    Name = "AppDatabase"
  }
}