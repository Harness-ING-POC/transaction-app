variable "service_name" {
  type        = string
  description = "Name of the service"
}

variable "service_identifier" {
  type        = string
  description = "Identifier for the service"
}

variable "service_type" {
  type        = string
  description = "The type of service"
}

variable "org_id" {
  type        = string
  description = "Id of the org"
}

variable "proj_id" {
  type        = string
  description = "Id of the project"
}


variable "env_names" {
  type    = list(string)
  default = ["tst", "acc", "prd"]
}
