
resource "google_dns_record_set" "preprod_record" {
  count        = var.enable_dns ? 1 : 0
  name         = "petclinic.preprod.${var.dns_name}"
  type         = "A"
  ttl          = 300
  rrdatas      = [var.preprod_environment_url]
  managed_zone = "zone-a"
}

resource "google_dns_record_set" "monitoring_record" {
  count        = var.enable_dns ? 1 : 0
  name         = "petclinic.preprod.monitoring.${var.dns_name}"
  type         = "A"
  ttl          = 300
  rrdatas      = [var.monitoring_url]
  managed_zone = "zone-a"
}


