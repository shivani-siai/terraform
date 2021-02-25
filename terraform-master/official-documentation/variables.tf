variable "region" {
  default = "us-west-2"

}

variable "amis" {
  type = map(any)
  default = {
    "eu-west-1" = "ami-08a2aed6e0a6f9c7d"
    "us-west-2" = "ami-0841edc20334f9287"
  }
}