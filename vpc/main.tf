##*************Creating VPC **********************## 
provider "aws" {

    region = "${var.aws_region}"
    profile = "profile_name"
}

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    tags {
        Name = "aws-vpc"
        CreatedBy = "Terraform"
    }
}


##*************Creating Internet Gateway S**********************## 
resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
    tags {
        Name = "aws-internet gateway"
        CreatedBy = "Terraform"
    }
}

##*************Creating public Subnet **********************## 
resource "aws_subnet" "public-subnet-1" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public-sub-1}"
    availability_zone = "${var.az_a}"

    tags {
        Name = "public-subnet-1"
        CreatedBy = "Terraform"
    }

}
resource "aws_subnet" "public-subnet-2" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public-sub-2}"
    availability_zone = "${var.az_b}"

    tags {
        Name = "public-subnet-2"
         CreatedBy = "Terraform"
    }
   
}
resource "aws_subnet" "public-subnet-3" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public-sub-3}"
    availability_zone = "${var.az_c}"

    tags {
        Name = "public-subnet-3"
         CreatedBy = "Terraform"
    }
   
}

##*************Creating private Subnet **********************## 
resource "aws_subnet" "private-subnet-1" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.private-sub-1}"
    availability_zone = "${var.az_a}"

    tags {
        Name = "private-subnet-1"
         CreatedBy = "Terraform"
    }
   
}
resource "aws_subnet" "private-subnet-2" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.private-sub-2}"
    availability_zone = "${var.az_b}"

    tags {
        Name = "private-subnet-2"
         CreatedBy = "Terraform"
    }
   
}
resource "aws_subnet" "private-subnet-3" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.private-sub-3}"
    availability_zone = "${var.az_c}"

    tags {
        Name = "private-subnet-3"
         CreatedBy = "Terraform"
    }

}

##**#####################***********Creating NAT Gateway S**********************## 

#########################---EIPs---###################################
resource "aws_eip" "nat_eip_1" {
   vpc      = true
}
resource "aws_eip" "nat_eip_2" {
   vpc      = true
}
resource "aws_eip" "nat_eip_3" {
   vpc      = true
}

############################## NAT-1 ##################################
resource "aws_nat_gateway" "nat_1" {
    #count = "${var.num_nat_gateways}"
    allocation_id = "${aws_eip.nat_eip_1.id}"
    subnet_id = "${aws_subnet.public-subnet-1.id}"

    depends_on = [
        "aws_internet_gateway.default",
        "aws_eip.nat_eip_1"
    ]
}

############################## NAT-2 ##################################
resource "aws_nat_gateway" "nat_2" {
    #count = "${var.num_nat_gateways}"
    allocation_id = "${aws_eip.nat_eip_2.id}"
    subnet_id = "${aws_subnet.public-subnet-2.id}"

    depends_on = [
        "aws_internet_gateway.default",
        "aws_eip.nat_eip_2"
    ]
}

########################### NAT-3 ################################
resource "aws_nat_gateway" "nat_3" {
    #count = "${var.num_nat_gateways}"
    allocation_id = "${aws_eip.nat_eip_3.id}"
    subnet_id = "${aws_subnet.public-subnet-3.id}"

    depends_on = [
        "aws_internet_gateway.default",
        "aws_eip.nat_eip_3"
    ]
}



##*************Creating Routing *********************## 
    ##Public Route Table
resource "aws_route_table" "public-route-table-1" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {

         Name = "PublicRoutingtable-1"
         CreatedBy = "Terraform"
      } 
}
resource "aws_route_table" "public-route-table-2" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "PublicRoutingtable-2"
         CreatedBy = "Terraform"
      } 
}
resource "aws_route_table" "public-route-table-3" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "Public-Routing-table-3"
         CreatedBy = "Terraform"
      } 
}

resource "aws_route_table_association" "public-sub1-route-table" {
    subnet_id = "${aws_subnet.public-subnet-1.id}" 
    route_table_id = "${aws_route_table.public-route-table-1.id}"
}
resource "aws_route_table_association" "public-sub2-route-table" {
    subnet_id =  "${aws_subnet.public-subnet-2.id}" 
    route_table_id = "${aws_route_table.public-route-table-2.id}"
}
resource "aws_route_table_association" "public-sub3-route-table" {
    subnet_id = "${aws_subnet.public-subnet-3.id}" 
    route_table_id = "${aws_route_table.public-route-table-3.id}"
}

 ## Private route table
 resource "aws_route_table" "private-route-table-1" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat_1.id}"
    }

    tags { 
        Name = "PrivateRoutingtable-1"
         CreatedBy = "Terraform"

    }
}

resource "aws_route_table" "private-route-table-2" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat_2.id}"
    }

    tags { 
        Name = "PrivateRoutingtable-2"
         CreatedBy = "Terraform"

    }
}

resource "aws_route_table" "private-route-table-3" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat_3.id}"
    }

    tags { 
        Name = "PrivateRoutingtable-3"
         CreatedBy = "Terraform"

    }
}

resource "aws_route_table_association" "private-sub1-route-table" {
   subnet_id = "${aws_subnet.private-subnet-1.id}" 
    route_table_id = "${aws_route_table.private-route-table-1.id}"

}
resource "aws_route_table_association" "private-sub2-route-table" {
   subnet_id = "${aws_subnet.private-subnet-2.id}" 
    route_table_id = "${aws_route_table.private-route-table-2.id}"
}
resource "aws_route_table_association" "private-sub3-route-table" {
   subnet_id = "${aws_subnet.private-subnet-3.id}" 
    route_table_id = "${aws_route_table.private-route-table-3.id}"
}
