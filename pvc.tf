resource "kubernetes_persistent_volume_claim" "wordpress_pvc" {
  metadata {
    name      = "wordpress-pvc"
    namespace = kubernetes_namespace.wordpress_ns.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}
