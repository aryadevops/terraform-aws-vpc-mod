resource "aws_vpc" "main" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = var.enable_dns_hostnames
    enable_dns_support = var.enable_dns_support

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.env}"
        },
        var.vpc_tags
    )
  
}

resource "aws_internet_gateway" "main" {
    
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.env}"
        },
        var.igw_tags
    )
}

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidr)
    map_public_ip_on_launch = true
    vpc_id     = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr[count.index]
    availability_zone = local.azs[count.index]

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.env}-public-${local.azs[count.index]}"
        }
    )
}

resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidr)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr[count.index]
    availability_zone = local.azs[count.index]

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.env}-private-${local.azs[count.index]}"
        }
    )
}

resource "aws_subnet" "database" {
    count = length(var.database_subnet_cidr)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.database_subnet_cidr[count.index]
    availability_zone = local.azs[count.index]

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.env}-database-${local.azs[count.index]}"
        }
    )
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.env}"
        },
        var.public_route_table_tags
    )
  
}

resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  
}

resource "aws_eip" "eip" {
    domain = "vpc"
  
}
resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.public[0].id

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.env}"
        },
        var.nat_gateway_tags
    )
    depends_on = [ aws_internet_gateway.main ]
}
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.env}"
        },
        var.private_route_table_tags
    )
  
}
  
resource "aws_route" "private" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  
}  

resource "aws_route_table" "database" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.env}"
        },
        var.database_route_table_tags
    )
  
}
  
resource "aws_route" "database" {
    route_table_id = aws_route_table.database.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  
}  

resource "aws_route_table_association" "public" {
    count = length(aws_subnet.public)
    subnet_id = element(aws_subnet.public[*].id,count.index)
    route_table_id = aws_route_table.public.id
  
}

resource "aws_route_table_association" "private" {
    count = length(aws_subnet.private)
    subnet_id = element(aws_subnet.private[*].id,count.index)
    route_table_id = aws_route_table.private.id
  
}

resource "aws_route_table_association" "database" {
    count = length(aws_subnet.database)
    subnet_id = element(aws_subnet.database[*].id,count.index)
    route_table_id = aws_route_table.database.id
  
}
 
resource "aws_db_subnet_group" "roboshop" {
    name = "${var.project_name}-${var.env}"
    subnet_ids = aws_subnet.database[*].id

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.env}"
        },
        var.subnet_db_group_tags
    )
  
}
  
