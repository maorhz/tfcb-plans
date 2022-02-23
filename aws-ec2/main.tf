provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "test-instance" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}