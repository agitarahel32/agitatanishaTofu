##############################################
# DEPLOYMENT: WORDPRESS
##############################################

resource "kubernetes_deployment" "wordpress" {
  metadata {
    name      = "wordpress"
    namespace = kubernetes_namespace.wordpress_ns.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "wordpress"
      }
    }

    template {
      metadata {
        labels = {
          app = "wordpress"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.wordpress_sa.metadata[0].name

        container {
          name  = "wordpress"
          image = "wordpress:latest"

          port {
            container_port = 80
          }

          env {
            name  = "WORDPRESS_DB_HOST"
            value = "mariadb-service.mariadb.svc.cluster.local"
          }

          env {
            name  = "WORDPRESS_DB_USER"
            value = "root"
          }

          env {
            name = "WORDPRESS_DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mariadb-secret"
                key  = "mariadb-password"
              }
            }
          }

          env {
            name  = "WORDPRESS_DB_NAME"
            value = "wordpress"
          }

          volume_mount {
            name       = "wordpress-storage"
            mount_path = "/var/www/html"
          }
        }

        volume {
          name = "wordpress-storage"
          persistent_volume_claim {
            claim_name = "wordpress-pvc"
          }
        }
      }
    }
  }
}

##############################################
# SERVICE: WORDPRESS
##############################################

resource "kubernetes_service" "wordpress" {
  metadata {
    name      = "wordpress-service"
    namespace = kubernetes_namespace.wordpress_ns.metadata[0].name
  }

  spec {
    selector = {
      app = "wordpress"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
