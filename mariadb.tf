resource "kubernetes_deployment" "mariadb" {
  metadata {
    name      = "mariadb"
    namespace = kubernetes_namespace.mariadb_ns.metadata[0].name
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
        service_account_name = kubernetes_service_account.mariadb_sa.metadata[0].name

        container {
          name  = "mariadb"
          image = "mariadb:latest"

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "rootpassword"
          }

          port {
            container_port = 3306
          }

          volume_mount {
            name       = "mariadb-storage"
            mount_path = "/var/lib/mysql"
          }
        }

        volume {
          name = "mariadb-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mariadb_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mariadb_service" {
  metadata {
    name      = "mariadb-service"
    namespace = kubernetes_namespace.mariadb_ns.metadata[0].name
  }

  spec {
    selector = {
      app = "mariadb"
    }

    port {
      port        = 3306
      target_port = 3306
    }

    type = "ClusterIP"
  }
}
