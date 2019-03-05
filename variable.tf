### Variables
variable project_name {
  default = "training-terraform"
}

variable sub_name {
  type    = "list"
  default = ["public", "private"]
}

variable public_map {
  type    = "list"
  default = ["true", "false"]
}

variable region {
  default = "eu-west-1"
}

variable "azs" {
  default = {
    "eu-west-1" = ["eu-west-1a", "eu-west-1b"]
  }
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "priv_cidr_block" {
  default = "10.0.10.0/16"
}

variable "pub_cidr_block" {
  default = "10.0.1.0/24"
}

variable "ami" {
  default = "ami-00035f41c82244dab"
}

variable "key_path" {
  description = "SSH Public Key path"

  # default     = "/Users/ahmed.lachheb/.ssh/keypair.pub"
  default = "AhmedKeyPair"
}
