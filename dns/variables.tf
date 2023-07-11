variable "dns_name" {
  description = "Nom du domaine"
  type        = string
  default     = "hicham.poei.znk.io."
}


variable "preprod_environment_url" {
  description = "URL vers lb de l'api-gateway de l'environnement de pre-prod"
  type        = string
  default     = "34.76.242.183"
}

variable "monitoring_url" {
  description = "URL du service de monitoring"
  type        = string
  default     = "34.140.26.69"
}

variable "enable_dns" {
  description = "Indicate if DNS configuration should be enabled"
  type        = bool
  default     = true
}
