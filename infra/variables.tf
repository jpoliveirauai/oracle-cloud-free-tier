variable "tenancy_ocid" { type = string }
variable "user_ocid" { type = string }
variable "fingerprint" { type = string }
variable "private_key_path" { type = string }
variable "region" { type = string }
variable "compartment_id" { type = string }

variable "ssh_public_key" {
  type        = string
  description = "Chave pública SSH para acessar a VM (ex: 'ssh-rsa AAA...')"
}