resource "kubernetes_deployment" "mariadb" {
  metadata {
    name = "mariadb"
    labels = {
      app = "mariadb"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mariadb"
      }
    }

    template {
      metadata {
        labels = {
          app = "mariadb"
        }
      }

      spec {
        container {
          name  = "mariadb"
          image = "mariadb:latest"

          port {
            container_port = 3306
          }

          env {
            name = "MARIADB_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mariadb-secret"
                key  = "mariadb-password"
              }
            }
          }

          env {
            name  = "MARIADB_DATABASE"
            value = "mydatabase"
          }

          volume_mount {
            name       = "mariadb-storage"
            mount_path = "/var/lib/mysql"
          }
        }

        volume {
          name = "mariadb-storage"

          persistent_volume_claim {
            claim_name = "mariadb-pvc"
          }
        }
      }
    }
  }
}

# PVC
resource "kubernetes_persistent_volume_claim" "mariadb_pvc" {
  metadata {
    name = "mariadb-pvc"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}

# SERVICE NodePort
resource "kubernetes_service" "mariadb" {
  metadata {
    name = "mariadb-service"
  }

  spec {
    selector = {
      app = "mariadb"
    }

    port {
      port        = 3306
      target_port = 3306
      node_port   = 30036
    }

    type = "NodePort"
  }
}

