variable "project_id" {
  description = "ID du projet GCP"
  type        = string
  default     = "ferrache-hicham"
}

variable "dns_name" {
  description = "Nom du domaine DNS à créer"
  type        = string
  default     = "poei.znk.io."
}

variable "apprenant" {
  description = "Nom de l'apprenant"
  type        = string
  default     = "FH"
}

variable "preprod_environment_url" {
  description = "URL de l'environnement de préproduction"
  type        = string
  default     = "http://35.189.253.20/"
}

variable "monitoring_url" {
  description = "URL du service de monitoring"
  type        = string
  default     = "http://35.205.145.33/"
}
