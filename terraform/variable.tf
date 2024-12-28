variable "public_subnet_cidr" {
 type        = list(string)
 description = "Public Subnet CIDR"
 default     = ["10.0.1.0/24", "10.0.5.0/24"]
}
 
variable "Database_subnet_cidrs" {
 type        = list(string)
 description = "Database Subnet CIDR values"
 default     = ["10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "Database_server" {
 type        = list(string)
 description = "Database servers"
 default     = [ "Database_server_1", "Database_server_2", "Database_server_3" ]
}


