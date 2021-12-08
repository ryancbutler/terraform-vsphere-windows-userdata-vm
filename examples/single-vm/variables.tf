variable "vsphere_server" {
  description = "vsphere server for the environment"
  type        = string
}

variable "vsphere_user" {
  description = "vsphere server for the environment"
  type        = string
}

variable "vsphere_password" {
  type        = string
  description = "vsphere password for the environment"

}

variable "ADDomain" {
  type        = string
  description = "Domain to join."
}
variable "ADOU" {
  type        = string
  description = "Which OU to place the server in"
}
variable "ADUser" {
  type        = string
  description = "Login info to join domain"
}
variable "ADPass" {
  type        = string
  description = "Password info to join domain"
  sensitive   = true
}
