# Define SSH key pair for our instances

resource "aws_instance" "web-instance" {
  ami                         = "${var.ami}"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_path}"
  subnet_id                   = "${aws_subnet.public_subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.web_serv_sg.id}"]
  associate_public_ip_address = true
  source_dest_check           = false
  user_data                   = "${file("install.sh")}"

  tags {
    Name = "${var.project_name}_webserver"
  }
}
