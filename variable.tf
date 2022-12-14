variable "cidr_block" {
    type = list(string)
    default = [ "172.20.0.0/16", "172.20.10.0/24" ]
}

variable "ami" {
    type = string
    default = "ami-0beaa649c482330f7"
}

variable "ports"{
    type = list(number)
    default = [ 22, 80, 8081 ]
}
# variable "instance" {
#     type = string
#     default = "t2.micro"
# }