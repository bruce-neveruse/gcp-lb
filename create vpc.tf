# === Create vpc 1 ===
resource "google_compute_network" "vpc-network1" {
  name                            = var.vpc_network1
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = true
}

# === ADD SUBNET1 ===
resource "google_compute_subnetwork" "subnet1" {
  name          = var.vpc_subnet_name1
  ip_cidr_range = var.vpc_ip_cidr1
  region        = var.gcp_region
  network       = var.vpc_network1
  depends_on    = [google_compute_network.vpc-network1]
}
# === Create vpc 2 ===
resource "google_compute_network" "vpc-network2" {
  name                            = var.vpc_network2
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = true
}

# === ADD SUBNET1 ===
resource "google_compute_subnetwork" "subnet2" {
  name          = var.vpc_subnet_name2
  ip_cidr_range = var.vpc_ip_cidr2
  region        = var.gcp_region
  network       = var.vpc_network2
  depends_on    = [google_compute_network.vpc-network2]
}
# === Create vpc 3 ===
resource "google_compute_network" "vpc-network3" {
  name                            = var.vpc_network3
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = true
}

# === ADD SUBNET1 ===
resource "google_compute_subnetwork" "subnet3" {
  name          = var.vpc_subnet_name3
  ip_cidr_range = var.vpc_ip_cidr3
  region        = var.gcp_region
  network       = var.vpc_network3
  depends_on    = [google_compute_network.vpc-network3]
}
