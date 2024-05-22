variable "key_name" {
  description = "Specifies the name to be assigned to the key pair that will be generated."
  default     = "firstname.lastname"
  type        = string
}

variable "environment" {
  description = "Specifies the identifier for the environment where the key pair will be used."
  default     = "devbox"
  type        = string
}

variable "ssm_parameter_path" {
  description = "Specifies the SSM parameter name that will be used to store the generated key pair."
  default     = "/devstation/ssm"
  type        = string
}

variable "user_name" {
  description = "The username for which to set up the .ssh directory."
  type        = string
}

variable "pubkey_path" {
  description = "The username for which to set up the .ssh directory."
  type        = string
}
