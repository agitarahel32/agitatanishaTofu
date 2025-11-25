resource "kubernetes_persistent_volume_claim" "mariadb_pvc" {
  metadata {
    name      = "mariadb-pvc"
    namespace = kubernetes_namespace.mariadb_ns.metadata[0].name
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
