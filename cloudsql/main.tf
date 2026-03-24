resource "google_sql_database_instance" "main" {
  name             = var.instance_name
  region           = var.region
  database_version = var.database_version

  settings {
    tier = var.db_tier

    ip_configuration {
      ipv4_enabled = true
    }

    backup_configuration {
      enabled = true
    }
  }

  deletion_protection = false
}

resource "google_sql_database" "app" {
  name     = var.database_name
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "app" {
  name     = var.db_user_name
  instance = google_sql_database_instance.main.name
  password = var.db_user_password
}
