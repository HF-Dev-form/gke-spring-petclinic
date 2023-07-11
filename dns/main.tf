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




resource "google_dns_managed_zone" "preprod_zone" {
  name        = "preprod-zone"
  dns_name    = "${var.dns_name}."
  description = "Zone DNS for preprod environment"
}

resource "google_dns_record_set" "preprod_record" {
  count        = var.enable_dns ? 1 : 0
  name         = "petclinic.preprod.${var.apprenant}.${var.dns_name}."
  type         = "CNAME"
  ttl          = 300
  rrdatas      = [var.preprod_environment_url]
  managed_zone = google_dns_managed_zone.preprod_zone.name
}

resource "google_dns_record_set" "monitoring_record" {
  count        = var.enable_dns ? 1 : 0
  name         = "petclinic.preprod.monitoring.${var.apprenant}.${var.dns_name}."
  type         = "CNAME"
  ttl          = 300
  rrdatas      = [var.monitoring_url]
  managed_zone = google_dns_managed_zone.preprod_zone.name
}
