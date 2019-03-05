### Resources
resource "aws_vpc" "main" {
  cidr_block = "${var.cidr_block}"

  tags {
    Name = "${var.project_name}"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = 1
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.pub_cidr_block}"
  availability_zone       = "${element(var.azs[var.region], count.index)}"
  map_public_ip_on_launch = "true"

  tags {
    Name = "${var.project_name}_public_${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = "${length(var.azs[var.region])}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.cidr_block, 8, count.index+10)}"
  availability_zone       = "${element(var.azs[var.region], count.index)}"
  map_public_ip_on_launch = "false"

  tags {
    Name = "${var.project_name}_private_${count.index}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.project_name}_internet-gw"
  }
}

# elastic ip
resource "aws_eip" "eip-tp" {
  vpc = true
}

# Nat Gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.eip-tp.id}"
  subnet_id     = "${aws_subnet.public_subnet.id}"

  tags {
    Name = "${var.project_name}_nat-gw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "${var.project_name}_public"
  }
}

resource "aws_route_table" "priv_rt" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
  }

  tags {
    Name = "${var.project_name}_private"
  }
}

resource "aws_route_table_association" "rtap_pub" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table_association" "rtap_priv" {
  count          = "${length(var.azs[var.region])}"
  subnet_id      = "${aws_subnet.private_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.priv_rt.id}"
}
