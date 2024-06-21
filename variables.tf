variable "cidr_block" {
  
}

variable "enable_dns_hostnames" {
  default = true
  
}

variable "enable_dns_support" {
  default = true
}

variable "common_tags" {
  default = {}
  
}

variable "vpc_tags" {
  default = {}
}

variable "project_name" {
    
  
}

variable "env" {
    
}

variable "igw_tags" {
    default = {}
  
}

variable "public_subnet_cidr" {
    type = list
    validation {
      condition = length(var.public_subnet_cidr) == 2
      error_message = "Please provide 2 subnet cidr"
    }
}

variable "private_subnet_cidr" {
    type = list
    validation {
      condition = length(var.private_subnet_cidr) == 2
      error_message = "Please provide 2 subnet cidr"
    }
}

variable "database_subnet_cidr" {
    type = list
    validation {
      condition = length(var.database_subnet_cidr) == 2
      error_message = "Please provide 2 subnet cidr"
    }
}

variable "nat_gateway_tags" {
    default = {}
  
}

variable "database_route_table_tags" {
  default = {}
  
}

variable "public_route_table_tags" {
  default = {}
}

variable "private_route_table_tags" {
  default = {}
}

variable "subnet_db_group_tags" {
  default = {}
  
}
variable "default_route_table_id" {
  
}

variable "requestor_vpc_id" {
  
}
variable "is_peering_required" {
  default = true
  
}

variable "default_vpc_cidr" {
  
}

