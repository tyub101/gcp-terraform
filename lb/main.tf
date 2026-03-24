resource "google_compute_network" "lb_vpc" {
  name                    = "lb-demo-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "lb_subnet" {
  name          = "lb-demo-subnet"
  ip_cidr_range = "10.10.1.0/24"
  region        = var.region
  network       = google_compute_network.lb_vpc.id
}

resource "google_compute_firewall" "allow_http_to_backend" {
  name    = "lb-demo-allow-http"
  network = google_compute_network.lb_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16",
  ]

  target_tags = ["lb-backend"]
}

resource "google_compute_instance" "backend" {
  name         = "lb-demo-backend"
  machine_type = "e2-micro"
  zone         = var.zone
  tags         = ["lb-backend"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.lb_subnet.id
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    mkdir -p /opt/lb-demo
    cat <<'EOF' >/opt/lb-demo/index.html
    <html>
      <body>
        <h1>Lean Terraform Load Balancer Demo</h1>
        <p>Backend VM is healthy.</p>
      </body>
    </html>
    EOF
    pkill -f "python3 -m http.server 80" || true
    nohup python3 -m http.server 80 --directory /opt/lb-demo >/var/log/lb-demo-http.log 2>&1 &
  EOT
}

resource "google_compute_instance_group" "backend_group" {
  name      = "lb-demo-group"
  zone      = var.zone
  instances = [google_compute_instance.backend.self_link]

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_health_check" "http" {
  name = "lb-demo-http-health-check"

  http_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "default" {
  name                  = "lb-demo-backend-service"
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.http.id]

  backend {
    group = google_compute_instance_group.backend_group.id
  }
}

resource "google_compute_url_map" "default" {
  name            = "lb-demo-url-map"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name    = "lb-demo-http-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_global_address" "default" {
  name = "lb-demo-ip"
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "lb-demo-forwarding-rule"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_address            = google_compute_global_address.default.id
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
}
