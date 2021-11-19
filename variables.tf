variable "aws_region" {
  type = map(any)
  default = {
    dev  = "us-west-2"
    test = "us-west-1"
  }
  description = "Default AWS region for use in my free-tier account"
}

variable "aws_cred_file" {
  type        = string
  default     = "/c/Users/Pavel_Lysianok/.aws"
  description = "Default path to AWS credential file"

}
