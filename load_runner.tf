data "aws_ami" "ami" {
  owners = ["973714476881"]
  most_recent = true
  name_regex  = "Centos-8-DevOps-Practice"
}

resource "aws_instance" "load_runner" {
  ami = data.aws_ami.ami.id
  instance_type = "t3.medium"
  vpc_security_group_ids = ["sg-07010737da7cff878"]
  tags = {
    Name = "load_runner"
  }

  provisioner "remote-exec" {
    connection {
      user = "centos"
      password = "DevOps321"
      host = self.public_ip
    }
    inline = [
      "sudo curl https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/docker/install.sh | sudo bash",
      "sudo docker pull robotshop/rs-load:latest"
    ]
  }
}
