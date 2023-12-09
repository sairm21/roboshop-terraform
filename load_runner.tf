data "aws_ami" "ami" {
  owners = ["973714476881"]
  most_recent = true
}

resource "aws_instance" "load_runner" {
  ami = data.aws_ami.ami.id
  instance_type = "t3.medium"
  vpc_security_group_ids = ["sg-07010737da7cff878"]
  tags = {
    Name = "load_runner"
  }

/*  provisioner "remote-exec" {
    connection {
      user = "centos"
      password = "DevOps321"
      host = self.public_ip
    }
    inline = [
    "sudo labauto docker",
      "sudo docker pull roboshop/rs-load:latest"
    ]
  }*/
}
