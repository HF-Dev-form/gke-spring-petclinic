resource "google_container_cluster" "app_cluster" {
  name     = "app-cluster"
  location = var.region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.pods_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }
  network    = var.network_name
  subnetwork = var.subnet_name

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  maintenance_policy {
    daily_maintenance_window {
      start_time = "02:00"
    }
  }

  #  dynamic "master_authorized_networks_config" {
  #    for_each = var.authorized_ipv4_cidr_block != null ? [var.authorized_ipv4_cidr_block] : []
  #    content {
  #      cidr_blocks {
  #        cidr_block   = master_authorized_networks_config.value
  #        display_name = "External Control Plane access"
  #      }
  #    }
  #  }

  # private_cluster_config {
  #   enable_private_endpoint = true
  #   enable_private_nodes    = true
  #   master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  # }

  release_channel {
    channel = "STABLE"
  }

  addons_config {
    // Enable network policy (Calico)
    network_policy_config {
      disabled = false
    }
  }

  /* Enable network policy configurations (like Calico).
  For some reason this has to be in here twice. */
  network_policy {
    enabled = "true"
  }

  workload_identity_config {
    identity_namespace = format("%s.svc.id.goog", var.project_id)
  }
}

resource "google_container_node_pool" "app_cluster_linux_node_pool" {
  name           = "${google_container_cluster.app_cluster.name}--linux-node-pool"
  location       = google_container_cluster.app_cluster.location
  node_locations = var.node_zones
  cluster        = google_container_cluster.app_cluster.name
  node_count     = 2

  autoscaling {
    max_node_count = 3
    min_node_count = 1
  }
  max_pods_per_node = 100

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = true
    disk_size_gb = 40

    service_account = var.service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/sqlservice.admin"
    ]

    labels = {
      cluster = google_container_cluster.app_cluster.name
    }

    shielded_instance_config {
      enable_secure_boot = true
    }

    // Enable workload identity on this node pool.
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

    metadata = {
      // Set metadata on the VM to supply more entropy.
      google-compute-enable-virtio-rng = "true"
      // Explicitly remove GCE legacy metadata API endpoint.
      disable-legacy-endpoints = "true"
    }
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 1
  }
}

# resource "google_container_registry" "registry" {
#   location = "eu"
# }

resource "google_sql_database_instance" "default" {
  project          = var.project_id
  name             = "database-instance"
  database_version = "MYSQL_5_7"
  region           = "europe-west1"

  settings {
    tier = "db-f1-micro"

    backup_configuration {
      enabled            = true
      start_time         = "03:00"
      location           = "europe-west1"
      binary_log_enabled = true
    }
  }
}




variable "dns_name" {
  description = "Nom du domaine DNS à créer"
  type        = string
  default     = "poei.znk.io"
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

variable "enable_dns" {
  description = "Indicate if DNS configuration should be enabled"
  type        = bool
  default     = false
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
